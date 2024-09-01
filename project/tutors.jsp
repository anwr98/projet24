<%@ page import="java.sql.*, java.net.URLDecoder" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tutors</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <div id="logo-container">
            <img src="images/logo.png" alt="Courses Online" id="logo" onclick="location.href='index.jsp';">
        </div>
        <nav>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="index.jsp#about">About Us</a></li>
                <li><a href="index.jsp#courses">Our Courses</a></li>
                <li><a href="index.jsp#contact">Contact Us</a></li>
                <li><a href="login.jsp">Login</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <%
            String course = request.getParameter("course");
            if (course != null) {
                course = URLDecoder.decode(course, "UTF-8");
        %>
        <h1>Tutors for <%=course%></h1>
        <div class="tutor-list">
            <%
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
                     PreparedStatement stmt = con.prepareStatement("SELECT id, name, email, profilePic FROM tutors WHERE course = ?")) {
                    stmt.setString(1, course);
                    ResultSet rs = stmt.executeQuery();

                    while (rs.next()) {
                        int tutorId = rs.getInt("id");
                        String tutorName = rs.getString("name");
                        String tutorEmail = rs.getString("email");
                        String profilePic = rs.getString("profilePic");
            %>
            <a href="tutor-profile.jsp?tutorId=<%=tutorId%>" style="text-decoration: none; color: inherit;">
                <div class="tutor-item" style="display: flex; align-items: center; margin-bottom: 20px; padding: 10px; background-color: #f7f7f7; border-radius: 10px;">
                    <div>
                        <img src="<%= profilePic %>" alt="<%= tutorName %>" style="width: 60px; height: 60px; border-radius: 50%; margin-right: 20px;">
                    </div>
                    <div>
                        <h2 style="margin: 0;"><%= tutorName %></h2>
                        <p style="margin: 5px 0;">Email: <%= tutorEmail %></p>
                    </div>
                </div>
            </a>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </div>
        <%
            } else {
        %>
            <p>No course selected.</p>
        <%
            }
        %>
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
