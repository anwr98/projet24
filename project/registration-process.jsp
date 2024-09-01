<%@ page import="java.sql.*" %>

<%
    // Retrieve form data from the registration page
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    String course = request.getParameter("course");
    String errorMessage = null;

    try {
        // Load the MySQL JDBC Driver
        Class.forName("com.mysql.jdbc.Driver");

        // Establish a connection to the database
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            // Check if the phone number or email already exists
            String checkSql = "SELECT phone, email FROM tutors WHERE phone = ? OR email = ?";
            try (PreparedStatement checkStmt = con.prepareStatement(checkSql)) {
                checkStmt.setString(1, phone);
                checkStmt.setString(2, email);
                ResultSet rs = checkStmt.executeQuery();

                if (rs.next()) {
                    // Either phone number or email already exists, return an error
                    if (rs.getString("phone").equals(phone)) {
                        errorMessage = "Phone number already registered. Please use a different phone number.";
                    } else if (rs.getString("email").equals(email)) {
                        errorMessage = "Email already registered. Please use a different email.";
                    }
                    request.setAttribute("errorMessage", errorMessage);
                    request.getRequestDispatcher("create-registration.jsp").forward(request, response);
                    return;
                }
            }

            // Prepare an SQL statement to insert the tutor's information into the database
            String sql = "INSERT INTO tutors (name, email, phone, password, course) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                // Set the parameters for the SQL statement
                stmt.setString(1, name);
                stmt.setString(2, email);
                stmt.setString(3, phone);
                stmt.setString(4, password);
                stmt.setString(5, course);

                // Execute the SQL statement
                int rowsInserted = stmt.executeUpdate();

                // Redirect the tutor to the login page after successful registration
                if (rowsInserted > 0) {
                    response.sendRedirect("login.html?success=true");
                } else {
                    out.println("<p>Registration failed. Please try again.</p>");
                }
            }
        }

    } catch (SQLException e) {
        // Print any SQL errors that occur
        e.printStackTrace();
        out.println("SQL Error: " + e.getMessage());

    } catch (ClassNotFoundException e) {
        // Print any ClassNotFoundException errors (if the JDBC driver is not found)
        e.printStackTrace();
        out.println("Error: MySQL Driver not found.");
    }
%>
