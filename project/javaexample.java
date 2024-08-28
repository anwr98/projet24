// File: src/DatabaseConnection.java
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    public static Connection getConnection() throws SQLException {
        String url = "jdbc:mysql://localhost:3306/coding_courses";
        String user = "coding_user";
        String password = "0503089535a";
        return DriverManager.getConnection(url, user, password);
    }
}
