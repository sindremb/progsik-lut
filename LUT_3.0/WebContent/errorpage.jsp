<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%
	// Possibly do some handling of different error codes and what message to displey (controlled by for example errorpage.jsp?code=404 )
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
        <h1>Ooops</h1>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Internal server error</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>Something went wrong when trying to process your request.<td>
	                </tr>
	            </tbody>
	        </table>
    </body>
</html>
