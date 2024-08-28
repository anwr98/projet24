<%@ page import="java.sql.*" %>

<%
    String tutorId = request.getParameter("tutorId");
    String comment = request.getParameter("comment");
    String ratingStr = request.getParameter("rating");
    int rating = 0;

    if (comment == null || comment.trim().isEmpty()) {
        out.println("Error: Comment cannot be empty.");
        return;
    }

    try {
        rating = Integer.parseInt(ratingStr); // Ensure the rating is an integer
    } catch (NumberFormatException e) {
        out.println("Error: Invalid rating.");
        return;
    }

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            String sql = "INSERT INTO comments (tutor_id, comment, rating) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(tutorId));
                stmt.setString(2, comment);
                stmt.setInt(3, rating);

                int rowsInserted = stmt.executeUpdate();
                if (rowsInserted > 0) {
                    response.sendRedirect("tutor-profile.jsp?tutorId=" + tutorId);
                } else {
                    out.println("Error: Unable to add comment and rating.");
                }
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        out.println("SQL Error: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: MySQL Driver not found.");
    }
%>



