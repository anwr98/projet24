<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Online Coding Courses</title>
    <link rel="stylesheet" href="styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>

    <!-- Header -->
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

    <!-- Hero Section -->
    <section id="hero">
        <div class="hero-content">
            <a href="#courses" class="cta-button">Explore Courses</a>
        </div>
    </section>

   <section id="about">
    <h2>About Us</h2>
    <p>At Online Course, we are dedicated to providing top-quality online coding courses that empower individuals to learn and excel in the field of programming. Whether you're a beginner looking to start your journey in coding or an experienced developer aiming to enhance your skills, our platform offers a diverse range of courses tailored to meet your needs. Our expert tutors are passionate about teaching and committed to helping you achieve your goals. Join our community of learners today and take the first step towards mastering the world of coding.</p>
</section>

<!-- Our Courses Section -->
<section id="courses">
    <h2>Our Courses</h2>
    <div class="course-list">
        <%
            // Establish database connection
            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
                 Statement stmt = con.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT course_name, image_path FROM courses")) {

                // Iterate through the result set to display each course
                while (rs.next()) {
                    String courseName = rs.getString("course_name");
                    String imagePath = rs.getString("image_path");
        %>
        <div class="course-item">
            <a href="<%=courseName.toLowerCase()%>-tutors.jsp">
                <img src="<%=imagePath%>" alt="<%=courseName%>">
                <p><%=courseName%></p>
            </a>
        </div>
        <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        %>
    </div>
</section>

<!-- Contact Us Section -->
<section id="contact">
    <h2>Contact Us</h2>
    <form action="contact-process.jsp" method="post">
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required>

        <label for="phone">Phone Number:</label>
        <input type="tel" id="phone" name="phone" required>

        <label for="course">Select a Course:</label>
        <select id="course" name="course" required>
            <%
                try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
                     Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT course_name FROM courses")) {
                    while (rs.next()) {
                        String courseName = rs.getString("course_name");
            %>
            <option value="<%=courseName.toLowerCase()%>"><%=courseName%></option>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
        </select>

        <label for="note">Note:</label>
        <textarea id="note" name="note" rows="4" required></textarea>

        <button type="submit">Submit</button>
    </form>
</section>

    <!-- Footer -->
    <footer>
        <div class="footer-content">
            <p>Follow us:</p>
            <a href="https://facebook.com" target="_blank"><i class="fab fa-facebook"></i></a>
            <a href="https://twitter.com" target="_blank"><i class="fab fa-twitter"></i></a>
            <a href="https://instagram.com" target="_blank"><i class="fab fa-instagram"></i></a>
        </div>
    </footer>

    <script src="script.js"></script>
</body>
</html>
