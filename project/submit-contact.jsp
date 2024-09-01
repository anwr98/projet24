<%@ page import="java.sql.*" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String course = request.getParameter("course");
    String note = request.getParameter("note");

    try {
        Class.forName("com.mysql.jdbc.Driver");

        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
             PreparedStatement stmt = con.prepareStatement("INSERT INTO contact_us (name, email, phone, course, note) VALUES (?, ?, ?, ?, ?)")) {

            stmt.setString(1, name);
            stmt.setString(2, email);
            stmt.setString(3, phone);
            stmt.setString(4, course);
            stmt.setString(5, note);
        
            int rowsInserted = stmt.executeUpdate();

            if (rowsInserted > 0) {
                response.sendRedirect("index.jsp?success=true");
            } else {
                response.sendRedirect("index.jsp?error=true");
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp?error=true");
    }
%>
