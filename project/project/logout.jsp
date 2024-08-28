<%
    // Invalidate the current session to log the user out
    session.invalidate();

    // Redirect the user to the login page or homepage
    response.sendRedirect("login.html");
%>