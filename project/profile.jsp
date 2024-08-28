<%@ page import="java.sql.*" %>

<%
    // Retrieve tutor details from the session
    String tutorName = (String) session.getAttribute("tutorName");
    String tutorId = (String) session.getAttribute("tutorId");

    // If the tutor is not logged in, redirect to login page
    if (tutorName == null || tutorId == null) {
        response.sendRedirect("login.html");
        return;
    }

    // Variables to hold tutor details
    String tutorPhone = "", tutorNotes = "", tutorProfilePic = "images/default.png";

    try {
        // Load MySQL JDBC driver
        Class.forName("com.mysql.jdbc.Driver");

        // Establish connection to the database
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            // Fetch tutor details from the database
            String sql = "SELECT phone, notes, profilePic FROM tutors WHERE id = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, tutorId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    tutorPhone = rs.getString("phone");
                    tutorNotes = rs.getString("notes");
                    tutorProfilePic = rs.getString("profilePic") != null ? rs.getString("profilePic") : "images/default.png";
                }
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - <%= tutorName %></title>
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
                <li><a href="index.html#about">About Us</a></li>
                <li><a href="index.html#courses">Our Courses</a></li>
                <li><a href="index.html#contact">Contact Us</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main class="tutor-profile-container">
        <div class="profile-card">
            <img src="<%= tutorProfilePic %>" alt="<%= tutorName %>" class="profile-picture-large">
            <h1><%= tutorName %></h1>
            <p><strong>Phone Number:</strong> <a href="tel:<%= tutorPhone %>"><%= tutorPhone %></a></p>
            <p><strong>About Me:</strong> <%= tutorNotes != null ? tutorNotes : "No notes available." %></p>
        </div>
        
        <!-- Profile Picture Update Form -->
        <form action="update-profile.jsp" method="post" enctype="multipart/form-data">
            <input type="hidden" name="tutorId" value="<%= tutorId %>">
            <label for="profilePic">Update Profile Picture:</label>
            <input type="file" name="profilePic" id="profilePic" accept="image/*" required>
            <button type="submit">Update Picture</button>
        </form>
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
