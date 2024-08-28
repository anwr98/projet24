<%@ page import="java.sql.*" %>

<%
    // Retrieve the tutor ID and rating from the form
    String tutorId = request.getParameter("tutorId");
    String rating = request.getParameter("rating");

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            // Insert the rating into the ratings table
            String sql = "INSERT INTO ratings (tutor_id, rating) VALUES (?, ?)";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setInt(1, Integer.parseInt(tutorId)); // Cast tutorId to integer
                stmt.setInt(2, Integer.parseInt(rating));  // Cast rating to integer

                stmt.executeUpdate();
            }
        }

        // Redirect back to the tutor's profile page after rating submission
        response.sendRedirect("tutor-profile.jsp?tutorId=" + tutorId);

    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("An error occurred while submitting the rating.");
    }
%>
