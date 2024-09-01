<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <div id="logo-container">
            <img src="images/logo.png" alt="Courses Online" id="logo" onclick="location.href='index.jsp';">
        </div>
        <nav>
            <ul>
                <li><a href="admin-add-course.jsp">Add Course</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <h1>Manage Courses</h1>
        <div class="course-list">
            <%
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
                     Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT id, course_name, image_path FROM courses")) {

                    while (rs.next()) {
                        int courseId = rs.getInt("id");
                        String courseName = rs.getString("course_name");
                        String imagePath = rs.getString("image_path");
            %>
            <div class="course-item">
                <img src="<%=imagePath%>" alt="<%=courseName%>">
                <p><%=courseName%></p>
                <form action="delete-course.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="courseId" value="<%=courseId%>">
                    <button type="submit" onclick="return confirm('Are you sure you want to delete this course?');">Delete</button>
                </form>
            </div>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
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
