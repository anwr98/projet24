<%@ page import="java.util.Enumeration" %>
<%
    Enumeration<String> params = request.getParameterNames();
    while (params.hasMoreElements()) {
        String paramName = params.nextElement();
        out.println(paramName + " = " + request.getParameter(paramName) + "<br>");
    }
%>
