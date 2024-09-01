<%@ page import="java.sql.*, java.io.*, javax.servlet.*, javax.servlet.http.*, javax.servlet.annotation.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.util.regex.*" %>

<%
    String courseName = null;
    String imagePath = null;

    // Ensure the form is handled as a multipart request
    if (request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/")) {
        
        // Loop through all parts of the request
        for (Part part : request.getParts()) {
            String partName = part.getName();
            
            // Handle regular form fields
            if (partName.equals("name")) {
                Scanner scanner = new Scanner(part.getInputStream(), "UTF-8");
                courseName = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
                scanner.close();

            // Handle file uploads
            } else if (partName.equals("image")) {
                String contentDisposition = part.getHeader("content-disposition");
                String fileName = contentDisposition.substring(contentDisposition.lastIndexOf('=') + 2, contentDisposition.length() - 1).replace("\"", "");
                String uploadPath = getServletContext().getRealPath("/") + "images/" + fileName;
                File file = new File(uploadPath);

                try (InputStream fileContent = part.getInputStream();
                     FileOutputStream outputStream = new FileOutputStream(file)) {

                    int read;
                    final byte[] bytes = new byte[1024];
                    while ((read = fileContent.read(bytes)) != -1) {
                        outputStream.write(bytes, 0, read);
                    }

                    imagePath = "images/" + fileName;
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Insert course into the database
    if (courseName != null && !courseName.isEmpty() && imagePath != null && !imagePath.isEmpty()) {
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/coding_courses?enabledTLSProtocols=TLSv1.2", "root", "0503089535a");
             PreparedStatement stmt = con.prepareStatement("INSERT INTO courses (course_name, image_path) VALUES (?, ?)")) {

            stmt.setString(1, courseName);
            stmt.setString(2, imagePath);
            int result = stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Redirect to the admin dashboard
        response.sendRedirect("admin-dashboard.jsp");
        return;  // Ensure the rest of the code doesn't execute
    } else {
        out.println("Course name or image path is null or empty, nothing to insert.<br>"); // Debugging output
    }
%>



