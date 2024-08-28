<%@ page import="java.sql.*, java.util.*" %>

<%
    String tutorId = (String) session.getAttribute("tutorId");

    if (tutorId == null) {
        response.sendRedirect("login.html");
        return;
    }

    String tutorName = "", tutorPhone = "", tutorNotes = "", tutorProfilePic = "";
    List<Map<String, String>> commentsAndRatings = new ArrayList<>();

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            String sql = "SELECT name, phone, notes, profilePic FROM tutors WHERE id = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, tutorId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    tutorName = rs.getString("name");
                    tutorPhone = rs.getString("phone");
                    tutorNotes = rs.getString("notes");
                    tutorProfilePic = rs.getString("profilePic");
                } else {
                    response.sendRedirect("login.html");
                    return;
                }
            }

            String commentSql = "SELECT comment, rating FROM comments WHERE tutor_id = ?";
            try (PreparedStatement commentStmt = con.prepareStatement(commentSql)) {
                commentStmt.setInt(1, Integer.parseInt(tutorId));
                ResultSet commentRs = commentStmt.executeQuery();

                while (commentRs.next()) {
                    Map<String, String> commentRating = new HashMap<>();
                    commentRating.put("comment", commentRs.getString("comment"));
                    commentRating.put("rating", String.valueOf(commentRs.getInt("rating")));
                    commentsAndRatings.add(commentRating);
                }
            }

        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard of <%= tutorName %></title>
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
                
                <li><a href="logout.jsp">logout</a></li>
            </ul>
        </nav>
    </header>

    <main class="tutor-profile-container">
        <div class="profile-card">
            <img src="<%= tutorProfilePic != null ? tutorProfilePic : "images/default.png" %>" alt="<%= tutorName %>">

            <h1><%= tutorName %></h1>
            <p><strong>Phone Number:</strong> <a href="tel:<%= tutorPhone %>"><%= tutorPhone %></a></p>
            <form action="update-profile.jsp" method="post" enctype="multipart/form-data">
                <label for="profilePic">Update Profile Picture:</label>
                <input type="file" name="profilePic" id="profilePic">
                <button type="submit">Update Picture</button>
            </form>
            
            <form action="update-notes.jsp" method="post">
                <label for="notes">Update Notes:</label>
                <textarea name="notes" id="notes" rows="4"><%= tutorNotes %></textarea>
                <button type="submit">Update Notes</button>
            </form>
        </div>

        <div class="comment-section">
            <h2>Comments:</h2>
            <% if (commentsAndRatings.isEmpty()) { %>
                <p>No comments found for this tutor.</p>
            <% } else { %>
                <ul>
                <% for (Map<String, String> commentRating : commentsAndRatings) { %>
                    <li class="comment-item">
                        <div class="comment-avatar">
                            <img src="images/default.png" alt="User Avatar">
                        </div>
                        <div class="comment-content">
                            <strong>Anonymous</strong>
                            <p><%= commentRating.get("comment") %></p>
                            <p>Rating: <%= commentRating.get("rating") %> / 5</p>
                        </div>
                    </li>
                <% } %>
                </ul>
            <% } %>
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
