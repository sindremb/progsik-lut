<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
<title>Add a school</title>
</head>
<body>

<h1>Add a school!</h1>

<form method = post action = "add_school.jsp">
	<table>
		<thead>
			<tr>
				<td>Insert details here</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Full name of school: <input type = "text" name = "fullname"></td>
			</tr>
			<tr>
				<td>Short name of school: <input type = "text" name = "shortname"></td>
			</tr>
			<tr>
			<tr>
				<td>Place: <input type = "text" name = "place"></td>
			</tr>
			<tr>
				<td>Zip: <input type = "text" name = "zip"></td>
			</tr>
			
				<td> <input type = "submit" value ="Legg til!"></td>
			</tr>
		</tbody>
</form>
</body>
</html>