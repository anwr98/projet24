<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Messages</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <div id="logo-container">
            <img src="images/logo.png" alt="Courses Online" id="logo" onclick="location.href='admin-dashboard.jsp';">
        </div>
        <nav>
            <ul>
                <li><a href="admin-dashboard.jsp">Dashboard</a></li>
                <li><a href="admin-add-course.jsp">Add Course</a></li>
                <li><a href="logout.jsp">Logout</a></li>
            </ul>
        </nav>
    </header>

    <main>
        <h1>Contact Us Messages</h1>
        <div class="messages-list">
            <%
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
                     Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT id, name, email, phone, course, note FROM contact_us")) {

                    while (rs.next()) {
                        int messageId = rs.getInt("id");
                        String name = rs.getString("name");
                        String email = rs.getString("email");
                        String phone = rs.getString("phone");
                        String course = rs.getString("course");
                        String note = rs.getString("note");
            %>
            <div class="card">
                <h3><%= name %></h3>
                <p><strong>Email:</strong> <%= email %></p>
                <p><strong>Phone:</strong> <%= phone %></p>
                <p><strong>Course:</strong> <%= course %></p>
                <p><strong>Message:</strong> <%= note %></p>
                <form action="delete-message.jsp" method="post" style="display:inline;">
                    <input type="hidden" name="messageId" value="<%=messageId%>">
                    <button type="submit" onclick="return confirm('Are you sure you want to delete this message?');">Delete</button>
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
