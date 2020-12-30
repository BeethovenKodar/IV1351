package DBApplication.view;

import java.util.*;

public class CommandLibrary {

    private static final String BASE = "> ";
    private final List<String> cmds = new ArrayList<>(Arrays.asList(
        "LIST_RENTABLE_INSTRUMENTS",
        "RENT",
        "TERMINATE",
        "LIST_MY_RENTALS",
        "LOG_IN",
        "QUIT",
        "--info"
    ));

    /**
     * Investigates the given command.
     * @param command The command from user
     * @return The command if it exists, or ILLEGAL_CMD if not.
     */
    public String getAction(String command) {
        if (cmds.contains(command))
            return command;
        else return "ILLEGAL_CMD";
    }

    /**
     * Instructions on how to use the CLI.
     */
    public void showHandbook() {
        System.out.println(BASE + "LIST_RENTABLE_INSTRUMENTS [instrumentType], lists all rentable instruments of given type");
        System.out.println(BASE + "QUIT, quits the application");
        System.out.println(BASE + "RENT [instrumentID], rents the instrument which id was specified");
        System.out.println(BASE + "TERMINATE [rentalID], terminates a rental of an instrument");
        System.out.println(BASE + "LIST_MY_RENTALS, shows your current rentals");
        System.out.println(BASE + "LOG_IN [email], logs you in");
    }
}
