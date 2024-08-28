<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<%
    // Retrieve login credentials from the form
    String phone = request.getParameter("phone"); 
    String password = request.getParameter("password");

    boolean isValidUser = false;
    String tutorName = "";
    String tutorId = "";

    // Check if phone and password are provided
    if (phone == null || password == null) {
        out.println("Error: Phone number and password are required.");
        return;
    }

    try {
        Class.forName("com.mysql.jdbc.Driver");

        // Establish connection to the database
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            // Prepare the SQL statement to check the tutor's credentials
            String sql = "SELECT id, name FROM tutors WHERE phone = ? AND password = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, phone); 
                stmt.setString(2, password);

                // Execute the query
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        isValidUser = true;
                        tutorId = rs.getString("id");
                        tutorName = rs.getString("name");
                    }
                }
            }
        }

        // Redirect the tutor based on validation result
        if (isValidUser) {
            // Store the tutor's details in the session
            session.setAttribute("tutorName", tutorName);
            session.setAttribute("tutorId", tutorId);

            // Redirect to the tutor's dashboard page
            response.sendRedirect("tutor-dashboard.jsp");
        } else {
            // Display an error message if login failed
            out.println("Invalid phone number or password. Please try again.");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("SQL Error: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: MySQL Driver not found.");
    }
%>
