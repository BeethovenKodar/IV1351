package DBApplication.view;

import DBApplication.controller.RentalController;

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class CommandLineInterface {

    private RentalController rc = null;
    private CommandLibrary cmdLib = null;
    private Scanner console = null;

    private static final String BASE = "> ";
    private boolean activeSession = false;
    String userParams[] = new String[0];
    String userCmd = null;
    
    public CommandLineInterface (RentalController rc) {
        this.rc = rc;
        this.cmdLib = new CommandLibrary();
        this.console = new Scanner(System.in);
    }

    public void startApp() {
        this.activeSession = true;
        System.out.println("\n" + BASE + "Entered Soundgood CLI");
        while(activeSession) {
            resetUserInput();
            readUserInput();
            switch(userCmd) {
                case "ILLEGAL_CMD" : {
                    invalidCommand();
                    break;
                }
                case "--info" : {
                    cmdLib.showHandbook();
                    break;
                }
                case "LIST_RENTABLE_INSTRUMENTS" : {
                    if (userParams.length != 1) {
                        invalidSyntax();
                        break;
                    }
                    List<String[]> results = rc.listInstrumentsByType(userParams[0]);
                    if (results.size() == 0) {
                        System.out.println(BASE + "No available instrument of given type");
                    } else {
                        System.out.println(BASE + "Instruments for rent:");
                        System.out.println("[rentalID, type, brand, monthly price]");
                        results.forEach((li) -> System.out.println(BASE + Arrays.toString(li)));
                    }
                    break;
                }
                case "RENT" : {
                    if (userParams.length != 1) {
                        invalidSyntax();
                        break;
                    }
                    if (!rc.verifyUser()) {
                        System.out.println(BASE + "Must be logged in to rent, use LOG_IN [email] command");
                    } else if (rc.checkRentalLimit() >= 2) {
                        System.out.println(BASE + "Another rental would exceed limit of maximum 2 rentals," +
                                " use TERMINATE [rentalID] to rent this one");
                    } else {
                        rc.rentInstrument(Integer.parseInt(userParams[0]));
                        System.out.println(BASE + "Instrument was successfully rented");
                    }
                    break;
                }
                case "TERMINATE" : {
                    if (userParams.length != 1) {
                        invalidSyntax();
                        break;
                    }
                    if (!rc.verifyUser()) {
                        System.out.println(BASE + "Must be logged in to terminate a rental, use LOG_IN [email] command");
                    } else {
                        rc.terminateRental(Integer.parseInt(userParams[0]));
                        System.out.println(BASE + "Termination of rental successful");
                    }
                    break;
                }
                case "LIST_MY_RENTALS" : {
                    if (userParams.length != 0) {
                        invalidSyntax();
                        break;
                    }
                    if (!rc.verifyUser()) {
                        System.out.println(BASE + "Must be logged in to list your rentals, use LOG_IN [email] command");
                        break;
                    }
                    List<String[]> rentals = rc.listStudentRentals();
                    if (rentals.size() == 0) {
                        System.out.println(BASE + "Not currently renting any instruments");
                    } else {
                        System.out.println(BASE + "Rented instruments:");
                        System.out.println(BASE + "[rentalID, type, brand, monthly price]");
                        rentals.forEach((li) -> {
                            System.out.println(BASE + "[" + li[1] + " " + li[2] + " " + li[3]+ " " + li[4] + "]");
                        });
                    }
                    break;
                }
                case "LOG_IN" : {
                    if (userParams.length != 1) {
                        invalidSyntax();
                        break;
                    }
                    rc.logIn(userParams[0]);
                    if (rc.verifyUser()) {
                        System.out.println(BASE + "Successfull login! Welcome " + userParams[0]);
                    } else {
                        System.out.println(BASE + "Could not find user connected to " + userParams[0]);
                    }
                    break;
                }
                case "QUIT" : {
                    if (userParams.length > 0) {
                        invalidSyntax();
                        break;
                    }
                    activeSession = false;
                    break;
                }
            }
        }
    }

    /**
     * Splits up the given CLI statement into a command and parameters.
     */
    private void readUserInput() {
        System.out.print(BASE);
        String[] userInput = console.nextLine().split(" ", 2);
        userCmd = cmdLib.getAction(userInput[0]);
        if (userInput.length > 1)
            userParams = userInput[1].split(" ", 0);
    }

    private void resetUserInput() {
        userCmd = null;
        userParams = new String[0];
    }

    private void invalidCommand() {
        System.out.println(BASE + "Invalid command: " + userCmd + 
            ", type --info for command listing and syntax.");           
    }

    private void invalidSyntax() {
        System.out.println(BASE + "Incorrect syntax for: " + userCmd + 
            ", type --info for command listing and syntax.");
    }
}
