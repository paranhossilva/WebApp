package Conexao;

import java.sql.*;

public abstract class Conn {

    protected static Connection myConn = null;
    protected static Statement myStmt = null;
    protected static ResultSet myRs = null;
    protected static String jdbcURL, jdbcUsername, jdbcPassword;
    protected String sql;
    
    protected Conn(String jdbcURL, String jdbcUsername, String jdbcPassword){
        this.jdbcURL = jdbcURL;
        this.jdbcUsername = jdbcUsername;
        this.jdbcPassword = jdbcPassword;
    }

    protected void connect() {
        try {
            Class.forName("com.mysql.jdbc.Driver");
            myConn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            myStmt = myConn.createStatement();
        } catch (Exception e) {}
    }

    protected void close() throws SQLException {
        if (myRs != null) {
            myRs.close();
        }

        if (myStmt != null) {
            myStmt.close();
        }

        if (myConn != null) {
            myConn.close();
        }
    }
}
