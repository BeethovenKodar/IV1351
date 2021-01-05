package DBApplication.model;

import DBApplication.integration.DBHandler;

import java.util.ArrayList;
import java.util.List;

/**
 * This class serves the purpose of containing all business logic around rentals for soundgood.
 */
public class RentalModel {

    DBHandler dbh;
    //private boolean loggedIn = false;
    private int studentID = -1;
    private List<Integer> rentableInstrumentsIDs;
    private List<String[]> currentRentalsByStudent;

    public RentalModel() {
        this.dbh = new DBHandler();
        rentableInstrumentsIDs = new ArrayList<>();
        currentRentalsByStudent = new ArrayList<>();
    }

    public List<String[]> listInstrumentsByType(String type) {
        List<String[]> rentableInstruments = dbh.listInstrumentsByType(type);
        rentableInstrumentsIDs = new ArrayList<>();
        rentableInstruments.forEach((instr) -> rentableInstrumentsIDs.add(Integer.parseInt(instr[0])));
        return rentableInstruments;
    }

    public void logIn(String email) {
        studentID = dbh.logIn(email);
    }

    public boolean verifyUser() {
        return studentID != -1;
    }

    public int checkRentalLimit() {
        return dbh.checkRentalLimit(studentID);
    }

    public void rentInstrument(int instrumentID) {
        dbh.rentInstrument(instrumentID, studentID);
        rentableInstrumentsIDs.remove(Integer.valueOf(instrumentID));
    }

    public boolean terminateRental(int rentalID) {
        boolean success = false;
        for (String[] rentals : currentRentalsByStudent) {
            if (String.valueOf(rentalID).equals(rentals[1])) {
                dbh.terminateRental(rentalID, Integer.parseInt(rentals[1]));
                success = true;
            }
        }
        return success;
    }

    public List<String[]> listStudentRentals() {
        currentRentalsByStudent = dbh.listStudentRentals(studentID);
        return currentRentalsByStudent;
    }

    public boolean isRentable(int instrumentID) {
        return rentableInstrumentsIDs.contains((instrumentID));
    }
}
