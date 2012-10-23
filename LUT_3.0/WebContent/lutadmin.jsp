

<% 
String type = (String)session.getAttribute("type");

Boolean redirect = true;

if (type == null){
	redirect = true;
}else if (type.equals("1")){
	redirect = false;
}

if (redirect){
	response.sendRedirect("login.jsp");
}

%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUTAdmin</title>
    </head>
    <body>
        <h1>Welcome to the LUT administration pages!</h1>
        <table>
        	<thead>
        		<tr>
        			<td>Here you can do a lot fun things!</td>
        		</tr>
        	</thead>
        	<tbody>
        		<tr>
        			<td><a href = "add_country.jsp">Add a country</a></td>
        		</tr>
					<td><a href = "add_school.jsp">Add a school</a></td>
        	</tbody>
        </table>
    </body>
</html>
