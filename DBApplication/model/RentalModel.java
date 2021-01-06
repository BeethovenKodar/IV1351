package DBApplication.model;

import DBApplication.integration.DBHandler;

import java.util.ArrayList;
import java.util.List;

/**
 * This class serves the purpose of containing all business logic around rentals for soundgood.
 */
public class RentalModel {

    private final DBHandler dbh;
    private int studentID = -1;
    private List<Integer> rentableInstrumentsIDs;
    private List<String[]> currentRentalsByStudent;

    public RentalModel() {
        this.dbh = new DBHandler();
        rentableInstrumentsIDs = new ArrayList<>();
        currentRentalsByStudent = new ArrayList<>();
    }

    public List<String[]> listInstrumentsByType(String type) {
        rentableInstrumentsIDs = new ArrayList<>();
        List<String[]> rentableInstruments = dbh.listInstrumentsByType(type);
        rentableInstruments.forEach((instrument) -> rentableInstrumentsIDs.add(Integer.parseInt(instrument[0])));
        return rentableInstruments;
    }

    public void logIn(String email) throws SoundgoodException {
        if ((studentID = dbh.logIn(email)) == -1)
            throw new SoundgoodException("No student connected to the given email " + email);
        currentRentalsByStudent = dbh.listStudentRentals(studentID);
    }

    public void rentInstrument(int instrumentID) throws SoundgoodException {
        verifyUser();
        checkRentalLimit();
        isRentable(instrumentID);
        dbh.rentInstrument(instrumentID, studentID);
        rentableInstrumentsIDs.remove(Integer.valueOf(instrumentID));
        currentRentalsByStudent = dbh.listStudentRentals((studentID));
    }

    public void terminateRental(int rentalID) throws SoundgoodException {
        verifyUser();
        int foundIndex = isTerminable(rentalID);
        dbh.terminateRental(rentalID, Integer.parseInt(currentRentalsByStudent.get(foundIndex)[0]));
        currentRentalsByStudent.remove(foundIndex);
    }

    public List<String[]> listStudentRentals() throws SoundgoodException {
        verifyUser();
        return currentRentalsByStudent;
    }

    private int isTerminable(int rentalID) throws SoundgoodException {
        int index = -1;
        for (int i = 0; i < currentRentalsByStudent.size(); i++) {
            if (currentRentalsByStudent.get(index = i)[1].equals(String.valueOf(rentalID)))
                break;
        }
        if (index == -1) throw new SoundgoodException("No rental with given ID connected to this student");
        else return index;
    }

    private void verifyUser() throws SoundgoodException {
        if (studentID == -1)
            throw new SoundgoodException("No user is logged in");
    }

    private void checkRentalLimit() throws SoundgoodException {
        if (currentRentalsByStudent.size() >= 2) {
            throw new SoundgoodException("Another rental would exceed limit of maximum 2 rentals," +
                    " use TERMINATE [rentalID] to rent this one instead");
        }
    }

    private void isRentable(int instrumentID) throws SoundgoodException {
        if (!rentableInstrumentsIDs.contains((instrumentID))) {
            throw new SoundgoodException("This instrumentID is not available, have you " +
                    "checked LIST_RENTABLE_INSTRUMENTS [type]?");
        }
    }
}
