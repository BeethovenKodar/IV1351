package DBApplication.integration;

import java.sql.*;

import java.util.ArrayList;
import java.util.List;
import java.lang.ClassNotFoundException;

/**
 * This class creates the connection between the application and the database.
 */
public class DBHandler {

    private static PreparedStatement listInstrumentsByTypeStmt;
    private static PreparedStatement checkRentedInstrumentsStmt;
    private static PreparedStatement mapEmailToStudentIDStmt;
    private static PreparedStatement updateInstrumentForRentStmt;
    private static PreparedStatement insertInstrumentRentalStmt;
    private static PreparedStatement setInstrumentRentalEndDateStmt;
    private static PreparedStatement listStudentRentalsStmt;

    private static Connection con = null;

    public DBHandler() {
        accessDB();
    }

    private static void accessDB() {
        String port = "jdbc:postgresql://localhost:5432/SoundgoodDatabase";
        String userName = "postgres";
        String password = "example";
        try {
            Class.forName("org.postgresql.Driver");
            con = DriverManager.getConnection(port, userName, password);
            con.setAutoCommit(false);
            setPreparedStatements();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    private static void setPreparedStatements() throws SQLException {
        listInstrumentsByTypeStmt = getInstance().prepareStatement(
        "SELECT * \n" +
            "FROM instrument_for_rent \n" +
            "WHERE rented = 'false' AND instrument_type = ?"
        );
        checkRentedInstrumentsStmt = getInstance().prepareStatement(
        "SELECT student_id, COUNT(ri.student_id) AS rented_instruments\n" +
            "FROM rented_instrument AS ri\n" +
            "WHERE ri.student_id = ? AND ri.rental_end_date IS NULL\n" +
            "GROUP BY student_id;"
        );
        mapEmailToStudentIDStmt = getInstance().prepareStatement(
        "SELECT student_id\n" +
           "FROM student AS s, person AS p\n" +
           "WHERE p.email = ? AND s.person_id = p.person_id;"
        );
        updateInstrumentForRentStmt = getInstance().prepareStatement(
       "UPDATE instrument_for_rent\n" +
           "SET rented = ?\n" +
           "WHERE instrument_id = ?"
        );
        insertInstrumentRentalStmt = getInstance().prepareStatement(
       "INSERT INTO rented_instrument (rental_start_date, student_id, instrument_id)\n" +
           "VALUES (?, ?, ?);"
        );
        setInstrumentRentalEndDateStmt = getInstance().prepareStatement(
       "UPDATE rented_instrument\n" +
           "SET rental_end_date = ?\n" +
           "WHERE rental_id = ? AND rental_end_date IS NULL;"
        );
        listStudentRentalsStmt = getInstance().prepareStatement(
       "SELECT ri.instrument_id, ri.rental_id, ifr.instrument_type, ifr.instrument_brand, ifr.instrument_monthly_rent\n" +
           "FROM instrument_for_rent AS ifr, rented_instrument AS ri\n" +
           "WHERE ifr.instrument_id = ri.instrument_id AND ri.student_id = ? AND ri.rental_end_date IS NULL;"
        );
    }

    /**
     * This method makes sure only one connection to the database exists, singleton
     * pattern.
     */
    private static Connection getInstance() {
        if (con == null)
            accessDB();
        return con;
    }

    /**
     * Part one of task 4 in the project. 
     * @param type A type of instrument that the student specifies.
     * @return The rows of the DB that fulfilled the query given.
     */
    public List<String[]> listInstrumentsByType(String type) {
        List<String[]> results = new ArrayList<>();
        ResultSet rs = null;
        boolean isEmpty = false;
        try {
            listInstrumentsByTypeStmt.setString(1, type);
            rs = listInstrumentsByTypeStmt.executeQuery();
            isEmpty = !rs.isBeforeFirst();
            while (rs.next()) {
                results.add(new String[] {
                    rs.getString("instrument_id"),
                    rs.getString("instrument_type"),
                    rs.getString("instrument_brand"),
                    rs.getString("instrument_monthly_rent")
                });
            }
            getInstance().commit();
        } catch (SQLException e) {
            handleException(e, "Could not access DB");
        } finally {
            if (!isEmpty)
                closeResultSet(rs);
        }
        return results;
    }

    public int logIn (String email) {
        ResultSet rs = null;
        int studentID = -1;
        boolean isEmpty = true;
        try {
            mapEmailToStudentIDStmt.setString(1, email);
            rs = mapEmailToStudentIDStmt.executeQuery();
            isEmpty = !rs.isBeforeFirst();
            if (!isEmpty) {
                rs.next();
                studentID = Integer.parseInt(rs.getString("student_id"));
            }
            getInstance().commit();
        } catch (SQLException sqle) {
            handleException(sqle, "Could not access DB");
        } finally {
            if (!isEmpty)
                closeResultSet(rs);
        }
        return studentID;
    }

    /**
     * One method for updating the instrument_for_rent table, boolean x decides operation.
     */
    private void updateInstrumentForRent(boolean TorF, int instrumentID) throws SQLException {
        updateInstrumentForRentStmt.setBoolean(1, TorF);
        updateInstrumentForRentStmt.setInt(2, instrumentID);
        updateInstrumentForRentStmt.executeUpdate();
    }

    public void rentInstrument(int instrumentID, int studentID) {
        try {
            updateInstrumentForRent(true, instrumentID);
            insertInstrumentRentalStmt.setDate(1, java.sql.Date.valueOf(java.time.LocalDate.now()));
            insertInstrumentRentalStmt.setInt(2, studentID);
            insertInstrumentRentalStmt.setInt(3, instrumentID);
            insertInstrumentRentalStmt.executeUpdate();
            getInstance().commit();
        } catch (SQLException e){
            handleException(e, "Could not access DB");
        }
    }

    public void terminateRental(int rentalID, int instrumentID) {
        try {
            updateInstrumentForRent(false, instrumentID);
            setInstrumentRentalEndDateStmt.setDate(1, java.sql.Date.valueOf(java.time.LocalDate.now()));
            setInstrumentRentalEndDateStmt.setInt(2, rentalID);
            setInstrumentRentalEndDateStmt.executeUpdate();
            getInstance().commit();
        } catch (SQLException e){
            handleException(e, "Could not access DB");
        }
    }

    public List<String[]> listStudentRentals(int studentID) {
        List<String[]> results = new ArrayList<>();
        ResultSet rs = null;
        boolean isEmpty = false;
        try {
            listStudentRentalsStmt.setInt(1, studentID);
            rs = listStudentRentalsStmt.executeQuery();
            isEmpty = !rs.isBeforeFirst();
            while (rs.next()) {
                results.add(new String[] {
                        rs.getString("instrument_id"),
                        rs.getString("rental_id"),
                        rs.getString("instrument_type"),
                        rs.getString("instrument_brand"),
                        rs.getString("instrument_monthly_rent")
                });
            }
            getInstance().commit();
        } catch (SQLException e) {
            handleException(e, "Could not access DB");
        } finally {
            if (!isEmpty)
                closeResultSet(rs);
        }
        return results;
    }

    private void closeResultSet(ResultSet rs) {
        try {
            rs.close();
        } catch (SQLException resultSetError) {
            handleException(resultSetError, "Could not close ResultSet");
        }
    }

    private void handleException(SQLException sqle, String message) {
        try {
            sqle.printStackTrace();
            System.out.println(message);
            getInstance().rollback();
        } catch (SQLException rollbackError) {
            rollbackError.printStackTrace();
            System.out.println("Could not rollback");
        }
    }
}