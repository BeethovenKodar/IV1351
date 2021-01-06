package DBApplication.controller;

import DBApplication.model.SoundgoodException;
import DBApplication.model.RentalModel;

import java.util.List;

public class RentalController {

    private final RentalModel rm;
    
    public RentalController () {
        this.rm = new RentalModel();
    }

    public List<String[]> listInstrumentsByType(String type) {
        return rm.listInstrumentsByType(type);
    }

    public void rentInstrument(int instrumentID) throws CmdFailedException {
        try {
            rm.rentInstrument(instrumentID);
        } catch (SoundgoodException se) {
            throw new CmdFailedException("Could not rent instrument", se);
        }
    }

    public List<String[]> listStudentRentals() throws CmdFailedException {
        try {
            return rm.listStudentRentals();
        } catch (SoundgoodException se) {
            throw new CmdFailedException("Could not list rentals", se);
        }
    }

    public void terminateRental(int rentalID) throws CmdFailedException {
        try {
            rm.terminateRental(rentalID);
        } catch (SoundgoodException se) {
            throw new CmdFailedException("Could not terminate rental", se);
        }
    }

    public void logIn(String email) throws CmdFailedException {
        try {
            rm.logIn(email);
        } catch (SoundgoodException se) {
            throw new CmdFailedException("Could not log in", se);
        }
    }
}
