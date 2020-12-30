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
        if (rentableInstrumentsIDs.contains(instrumentID)) {
            dbh.rentInstrument(instrumentID, studentID);
            rentableInstrumentsIDs.remove(Integer.valueOf(instrumentID));
        } else {
            System.out.println("> This instrument ID is not available for rent");
        }
    }

    public void terminateRental(int rentalID) {
        currentRentalsByStudent.forEach((li) -> {
            if(String.valueOf(rentalID).equals(li[1]))
                dbh.terminateRental(rentalID, Integer.parseInt(li[0]));
        });

    }

    public List<String[]> listStudentRentals() {
        currentRentalsByStudent = dbh.listStudentRentals(studentID);
        return currentRentalsByStudent;
    }
}
