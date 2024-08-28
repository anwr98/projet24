<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.SQLException" %>
<%
    String course = "";
    String path = request.getServletPath();
    if (path.contains("javascript")) {
        course = "javascript";
    } else if (path.contains("css")) {
        course = "css";
    } else if (path.contains("html")) {
        course = "html";
    } else if (path.contains("jquery")) {
        course = "jquery";
    }
    
    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;
    
    try { conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses", "root", "0503089535a");
        
        // Prepare SQL query to retrieve tutors for the selected course
        String sql = "SELECT * FROM tutors WHERE FIND_IN_SET(?, courses)";
        pst = conn.prepareStatement(sql);
        pst.setString(1, course);
        rs = pst.executeQuery();
%>

<div class="tutor-list">
    <% while (rs.next()) { %>
        <div class="tutor-item">
            <img src="images/<%= rs.getString("image") %>" alt="<%= rs.getString("name") %>">
            <p><%= rs.getString("name") %></p>
            <a href="profile-<%= rs.getString("id") %>.html">View Profile</a>
        </div>
    <% } %>
</div>

<%
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        // Close resources
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>