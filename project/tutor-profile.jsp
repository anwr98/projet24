<%@ page import="java.sql.*, java.util.*" %>

<%
    // Get the tutor ID from the query parameter
    String tutorId = request.getParameter("tutorId");

    if (tutorId == null) {
        response.sendRedirect("html-tutors.jsp"); // Redirect to the tutors list if no tutor ID is provided
        return;
    }

    // Variables to hold tutor details
    String tutorName = "", tutorPhone = "", tutorNotes = "", tutorProfilePic = "";
    double averageRating = 0;
    int totalRatings = 0;

    // Initialize the comments list
    List<Map<String, String>> commentsAndRatings = new ArrayList<>();

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            // Fetch tutor details
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
                    response.sendRedirect("html-tutors.jsp"); // Redirect if tutor not found
                    return;
                }
            }

            // Fetch comments and ratings for the tutor
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

            // Fetch average rating and total ratings count
            String ratingSql = "SELECT AVG(rating) AS avgRating, COUNT(rating) AS totalRatings FROM comments WHERE tutor_id = ?";
            try (PreparedStatement ratingStmt = con.prepareStatement(ratingSql)) {
                ratingStmt.setInt(1, Integer.parseInt(tutorId));
                ResultSet ratingRs = ratingStmt.executeQuery();

                if (ratingRs.next()) {
                    averageRating = ratingRs.getDouble("avgRating");
                    totalRatings = ratingRs.getInt("totalRatings");
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
    <title>Profile of <%= tutorName %></title>
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
                <li><a href="login.html">Login</a></li>
            </ul>
        </nav>
    </header>

    <main class="tutor-profile-container">
        <div class="profile-card">
            <img src="<%= tutorProfilePic != null ? tutorProfilePic : "images/default.png" %>" alt="<%= tutorName %>" class="profile-picture-large">

            <h1><%= tutorName %></h1>
            <p><strong>Phone Number:</strong> <a href="tel:<%= tutorPhone %>"><%= tutorPhone %></a></p>
            <p><strong>About Me:</strong> <%= tutorNotes != null ? tutorNotes : "No notes available." %></p>
            <div class="rating-summary">
                <strong>Average Rating:</strong>
                <p><%= averageRating %> / 5 based on <%= totalRatings %> ratings.</p>
            </div>
        </div>

        <!-- Comments Section -->
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

        <!-- Comment Form -->
        <div class="comment-form">
            <form id="commentForm" action="add-note.jsp" method="post">
                <input type="hidden" name="tutorId" value="<%= tutorId %>">
                
                <label for="rating">Rate this tutor:</label>
                <select name="rating" id="rating" required>
                    <option value="1">1</option>
                    <option value="2">2</option>
                    <option value="3">3</option>
                    <option value="4">4</option>
                    <option value="5">5</option>
                </select>
                
                <label for="comment">Add a Comment:</label>
                <textarea name="comment" id="comment" rows="4" required></textarea>
                
                <button type="submit">Post Comment and Rating</button>
            </form>
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
