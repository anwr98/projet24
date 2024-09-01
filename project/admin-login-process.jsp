<%@ page import="java.sql.*" %>

<%
    String email = request.getParameter("email");
    String password = request.getParameter("password");

    try {
        Class.forName("com.mysql.jdbc.Driver");
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {
            String sql = "SELECT id, name, role FROM tutors WHERE email = ? AND password = ? AND role = 'admin'";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, email);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    session.setAttribute("adminId", rs.getString("id"));
                    session.setAttribute("adminName", rs.getString("name"));
                    response.sendRedirect("admin-dashboard.jsp");
                } else {
                    out.println("<p>Invalid login. Please try again.</p>");
                }
            }
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    }
%>
