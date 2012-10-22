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
<title>Add a country</title>
</head>

<h1>Add a country!</h1>

<body>
 <% String name = "ravi";
            session.setAttribute("user", name);
    %>

<form method = post action = "add_country.jsp">
	<table>
		<thead>
			<tr>
				<td>Insert details here</td>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>Full name of country: <input type = "text" name = "fullname"></td>
			</tr>
			<tr>
				<td>Short name of country: <input type = "text" name = "shortname"></td>
			</tr>
			<tr>
				<td> <input type = "submit" value ="Legg til!"></td>
			</tr>
		</tbody>
</form>


<%	
	String fullname = "";
	String shortname = "";
	if (request.getParameter("fullname") != null && request.getParameter("shortname") != null){
		fullname = request.getParameter("fullname");
		shortname = request.getParameter("shortname");
	}
	if (!(fullname.equals(""))&& !(shortname.equals(""))){
		
	    InitialContext ctx = new InitialContext();
	    DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
	    Connection connection = ds.getConnection();
	    
	    if (connection == null)
	    {
	    	throw new SQLException("Error establishing connection!");
	    }
	    
	    
	    String query ="select * from country where full_name = '" + fullname + "' AND short_name = '" + shortname +"'";
	    PreparedStatement statement = connection.prepareStatement(query);
	    ResultSet rs = statement.executeQuery();
	    
	   	if(!rs.next()){
	   		query = "insert into country values ('" + shortname + "', '" + fullname +"')";
	    	statement = connection.prepareStatement(query);
	    	statement.executeUpdate();
	    	
	    	out.println("The following country was added  <br>");
	    	out.println("Full name is <br> " + fullname);
	    	out.println("Short name is <br>" + shortname);
		}
	   	
    }
	out.print("<a href = 'lutadmin.jsp'>Back to admin page</a>");
%>
    
</body>
</html>