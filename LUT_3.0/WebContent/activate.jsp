<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%
	String uname = request.getParameter("user");
	String email = request.getParameter("key");
	unameerror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find();
	emailerror = Pattern.compile("[^a-z0-9._&@^a-z0-9.]", Pattern.CASE_INSENSITIVE).matcher(email).find();
	
%>
		
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 3.0 - Help Students Conquer the World</title>
    </head>
    <body>
        <h1>Activation successful</h1>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Activate new user confirmation</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>You have successfully activated your new user for LUT3.0. 
	                    Now that your account is active, you can <a href="login.jsp">login here</a></td>
	                    <td>
	                </tr>
	            </tbody>
	        </table>
    </body>
</html>
