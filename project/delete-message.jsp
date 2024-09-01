<%@ page import="java.sql.*" %>
<%
    String messageId = request.getParameter("messageId");

    if (messageId != null && !messageId.isEmpty()) {
        try {
            Class.forName("com.mysql.jdbc.Driver");

            try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
                 PreparedStatement stmt = con.prepareStatement("DELETE FROM contact_us WHERE id = ?")) {

                stmt.setInt(1, Integer.parseInt(messageId));
                int rowsDeleted = stmt.executeUpdate();

                if (rowsDeleted > 0) {
                    response.sendRedirect("admin-messages.jsp?success=true");
                } else {
                    response.sendRedirect("admin-messages.jsp?error=true");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-messages.jsp?error=true");
        }
    } else {
        response.sendRedirect("admin-messages.jsp?error=true");
    }
%>
