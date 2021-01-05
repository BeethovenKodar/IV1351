package DBApplication.controller;

import DBApplication.model.RentalModel;

import java.util.List;

public class RentalController {

    private RentalModel rm;
    
    public RentalController () {
        this.rm = new RentalModel();
    }

    public List<String[]> listInstrumentsByType(String type) {
        return rm.listInstrumentsByType(type);
    }

    public boolean verifyUser() {
        return rm.verifyUser();
    }

    public int checkRentalLimit() {
        return rm.checkRentalLimit();
    }

    public void rentInstrument(int instrumentID) {
        rm.rentInstrument(instrumentID);
    }

    public List<String[]> listStudentRentals() {
        return rm.listStudentRentals();
    }

    public boolean terminateRental(int rentalID) {
        return rm.terminateRental(rentalID);
    }

    public void logIn(String email) {
        rm.logIn(email);
    }

    public boolean isRentable(int instrumentID) {
        return rm.isRentable(instrumentID);
    }
}
