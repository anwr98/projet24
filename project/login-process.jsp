<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet, java.sql.SQLException" %>

<%
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");

    boolean isValidUser = false;
    String tutorName = "";
    String tutorId = "";
    String role = "";

    if (phone == null || password == null) {
        out.println("Error: Phone number and password are required.");
        return;
    }

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a")) {

            String sql = "SELECT id, name, role FROM tutors WHERE phone = ? AND password = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, phone);
                stmt.setString(2, password);

                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        isValidUser = true;
                        tutorId = rs.getString("id");
                        tutorName = rs.getString("name");
                        role = rs.getString("role");
                    }
                }
            }
        }

        if (isValidUser) {
            session.setAttribute("tutorName", tutorName);
            session.setAttribute("tutorId", tutorId);
            session.setAttribute("role", role);

            if ("admin".equals(role)) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.sendRedirect("tutor-dashboard.jsp");
            }
        } else {
            out.println("Invalid phone number or password. Please try again.");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("SQL Error: " + e.getMessage());
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
        out.println("Error: MySQL Driver not found.");
    }
%>
