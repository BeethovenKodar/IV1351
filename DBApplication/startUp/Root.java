package DBApplication.startUp;

import DBApplication.controller.RentalController;
import DBApplication.view.CommandLineInterface;

class Root {

    public static void main(String[] args) {
        CommandLineInterface CLI = new CommandLineInterface(new RentalController());
        CLI.startApp();
    }
}