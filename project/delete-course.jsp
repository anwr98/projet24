<%@ page import="java.sql.*" %>
<%
    int courseId = Integer.parseInt(request.getParameter("courseId"));

    try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
         PreparedStatement stmt = con.prepareStatement("DELETE FROM courses WHERE id = ?")) {

        stmt.setInt(1, courseId);
        int result = stmt.executeUpdate();

        if (result > 0) {
            out.println("Course deleted successfully.");
        } else {
            out.println("Failed to delete the course.");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }

    response.sendRedirect("admin-dashboard.jsp");
%>
