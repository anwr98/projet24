<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tutors for <%= request.getParameter("course") %></title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <header>
        <div id="logo-container">
            <img src="images/logo.png" alt="Courses Online" id="logo" onclick="location.href='index.html';">
        </div>
        <nav>
            <ul>
                <li><a href="index.html">Home</a></li>
                <li><a href="about.html">About Us</a></li>
                <li><a href="contact.html">Contact Us</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <h1>Tutors for <%= request.getParameter("course") %></h1>
        <div id="tutor-list">
            <%
                String course = request.getParameter("course");

                // Ensure the course parameter is provided
                if (course != null && !course.isEmpty()) {
                    try {
                        // Load the MySQL JDBC Driver
                        Class.forName("com.mysql.jdbc.Driver");

                        // Establish connection to the database
                        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

                            // SQL query to get all tutors for the specified course
                            String sql = "SELECT * FROM tutors WHERE course = ?";
                            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                                stmt.setString(1, course); // Set the course parameter in the query
                                ResultSet rs = stmt.executeQuery();

                                // Check if there are any results
                                if (!rs.isBeforeFirst()) {
                                    out.println("<p>No tutors available for " + course + " at the moment.</p>");
                                }

                                // Display each tutor
                                while (rs.next()) {
                                    String name = rs.getString("name");
                                    String email = rs.getString("email");
                                    String notes = rs.getString("notes");
                                    String profilePic = rs.getString("profilePic");

                                    out.println("<div class='tutor-item'>");
                                    out.println("<img src='" + profilePic + "' alt='" + name + "' style='width:150px;height:auto;'>");
                                    out.println("<h2>" + name + "</h2>");
                                    out.println("<p>Email: " + email + "</p>");
                                    out.println("<p>" + notes + "</p>");
                                    out.println("</div>");
                                }
                            }
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("Error: " + e.getMessage());
                    }
                } else {
                    out.println("<p>No course selected.</p>");
                }
            %>
        </div>
    </main>

    <footer>
        <div class="footer-content">
            <p>Follow us:</p>
            <a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i></a>
            <a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i></a>
        </div>
    </footer>
</body>
</html>