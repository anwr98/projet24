<%@ page import="java.sql.*" %>

<%
    // Retrieve the tutor ID from the session or request parameter
    String tutorId = (String) session.getAttribute("tutorId");
    String notes = request.getParameter("notes");

    if (tutorId == null || notes == null) {
        out.println("Invalid input. Please try again.");
        return;
    }

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            String sql = "UPDATE tutors SET notes = ? WHERE id = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, notes);
                stmt.setString(2, tutorId);

                int rowsUpdated = stmt.executeUpdate();

                if (rowsUpdated > 0) {
                    // Redirect back to the dashboard or profile page
                    response.sendRedirect("tutor-dashboard.jsp");
                } else {
                    out.println("Failed to update notes.");
                }
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
