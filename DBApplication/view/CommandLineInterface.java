package DBApplication.view;

import DBApplication.controller.CmdFailedException;
import DBApplication.controller.RentalController;

import java.util.Arrays;
import java.util.List;
import java.util.Scanner;

public class CommandLineInterface {

    private final RentalController rc;
    private final CommandLibrary cmdLib;
    private final Scanner console;

    private static final String BASE = "> ";
    private String[] userParams = new String[0];
    
    public CommandLineInterface (RentalController rc) {
        this.rc = rc;
        this.cmdLib = new CommandLibrary();
        this.console = new Scanner(System.in);
    }

    public void startApp() {
        boolean activeSession = true;
        String userCmd;
        System.out.println("\n" + BASE + "Entered Soundgood CLI");
        while(activeSession) {
            try {
                resetUserInput();
                switch(userCmd = readUserInput()) {
                    case "ILLEGAL_CMD" : {
                        invalidCommand(userCmd);
                        break;
                    }
                    case "--info" : {
                        cmdLib.showHandbook();
                        break;
                    }
                    case "LIST_RENTABLE_INSTRUMENTS" : {
                        if (userParams.length != 1) {
                            invalidSyntax(userCmd);
                            break;
                        }
                        List<String[]> results = rc.listInstrumentsByType(userParams[0]);
                        if (results.size() == 0) {
                            System.out.println(BASE + "No available instruments of given type");
                        } else {
                            System.out.println(BASE + "Instruments for rent:");
                            System.out.println("[rentalID, type, brand, monthly price]");
                            results.forEach((li) -> System.out.println(BASE + Arrays.toString(li)));
                        }
                        break;
                    }
                    case "RENT" : {
                        if (userParams.length != 1) {
                            invalidSyntax(userCmd);
                            break;
                        }
                        rc.rentInstrument(Integer.parseInt(userParams[0]));
                        System.out.println(BASE + "Rental was successful");
                        break;
                    }
                    case "TERMINATE" : {
                        if (userParams.length != 1) {
                            invalidSyntax(userCmd);
                            break;
                        }
                        rc.terminateRental(Integer.parseInt(userParams[0]));
                        System.out.println(BASE + "Termination was successful");
                        break;
                    }
                    case "LIST_MY_RENTALS" : {
                        if (userParams.length != 0) {
                            invalidSyntax(userCmd);
                            break;
                        }
                        List<String[]> rentals = rc.listStudentRentals();
                        if (rentals.size() == 0) {
                            System.out.println(BASE + "Not currently renting any instruments");
                        } else {
                            System.out.println(BASE + "Rented instruments:");
                            System.out.println(BASE + "[rentalID, type, brand, monthly price]");
                            rentals.forEach((li) -> {
                                System.out.println(BASE + "[" + li[1] + ", " + li[2] + ", " + li[3]+ ", " + li[4] + "]");
                            });
                        }
                        break;
                    }
                    case "LOG_IN" : {
                        if (userParams.length != 1) {
                            invalidSyntax(userCmd);
                            break;
                        }
                        rc.logIn(userParams[0]);
                        System.out.println(BASE + "Successful login");
                        break;
                    }
                    case "QUIT" : {
                        if (userParams.length > 0) {
                            invalidSyntax(userCmd);
                            break;
                        }
                        activeSession = false;
                        break;
                    }
                }
            } catch (CmdFailedException cfe) {
                System.out.println(BASE + "ERROR: " + cfe.getMessage());
                cfe.printStackTrace();
            }
        }
    }

    /**
     * Splits up the given CLI statement into a command and parameters.
     */
    private String readUserInput() {
        System.out.print(BASE);
        String[] userInput = console.nextLine().split(" ", 2);
        if (userInput.length > 1)
            userParams = userInput[1].split(" ", 0);
        return cmdLib.getAction(userInput[0]);
    }

    private void resetUserInput() {
        userParams = new String[0];
    }

    private void invalidCommand(String userCmd) {
        System.out.println(BASE + "Invalid command: " + userCmd + 
            ", type --info for command listing and syntax.");           
    }

    private void invalidSyntax(String userCmd) {
        System.out.println(BASE + "Incorrect syntax for: " + userCmd + 
            ", type --info for command listing and syntax.");
    }
}
