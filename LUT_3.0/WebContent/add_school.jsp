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
	return;
}

%>
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
			<tr>
				<td><select name = "country">
				<%
				InitialContext ctx = new InitialContext();
			    DataSource ds = (DataSource) ctx.lookup("jdbc/lut2write");
			    Connection connection = ds.getConnection();
			    
			    if (connection == null)
			    {
			    	throw new SQLException("Error establishing connection!");
			    }
			    
			    
			    String query ="select * from country";
			    PreparedStatement statement = connection.prepareStatement(query);
			    ResultSet rs = null;
			    try{
			    	rs = statement.executeQuery();
			    }
			    catch (Exception e){
			    	if (connection != null){
			    		connection.close();
			    	}
			    	response.sendRedirect("lutadmin.jsp");
			    }
			    String short_name = "";
			    String full_name = "";
			    
			   	while(rs.next()){
			   		short_name = rs.getString("short_name");
			   		full_name = rs.getString("full_name");
			    	out.print("<option value = '" + short_name +"' >" + full_name + "</option>" );
				} 
			   	finally{
			   		if (connection != null){
				   	connection.close();
			   		}
			   	}
				%>
				</select></td>
			<tr>
			
				<td> <input type = "submit" value ="Legg til!"></td>
			</tr>
		</tbody>
</form>

<%	
		
	String fullname = "";
	String shortname = "";
	String place = "";
	String zip  = "";
	String country = "";
	if (request.getParameter("fullname") != null && request.getParameter("shortname") != null && request.getParameter("place") != null && request.getParameter("zip") != null && request.getParameter("country") != null){
		fullname = request.getParameter("fullname");
		shortname = request.getParameter("shortname");
		place = request.getParameter("place");
		zip = request.getParameter("zip");
		country = request.getParameter("country");
	}
	
if (!(fullname.equals(""))&& !(shortname.equals("")) && !(place.equals("")) && !(zip.equals("")) && !(country.equals(""))){
		
	    ctx = new InitialContext();
	    ds = (DataSource) ctx.lookup("jdbc/lut2");
	    connection = ds.getConnection();
	    
	    if (connection == null)
	    {
	    	throw new SQLException("Error establishing connection!");
	    }
	    
	    
	    query ="select * from school where full_name = ? AND short_name = ? AND place = ? AND zip = ? AND country = ?";
	    statement = connection.prepareStatement(query);
	    statement.setString(1, fullname);
	    statement.setString(2, shortname);
	    statement.setString(3, place);
	    statement.setString(4, zip);
	    statement.setString(5, country);
	    
	    try{
		    rs = statement.executeQuery();
	    }
	    catch(Exception e){
	    	response.Redirect("lutadmin.jsp");
	    }
	    
	   	if(!rs.next()){
	   		query = "insert into school(full_name, short_name, place, zip, country) values (?, ?, ?, ?, ?)";
	    	statement = connection.prepareStatement(query);
	    	statement.setString(1, fullname);
		    statement.setString(2, shortname);
		    statement.setString(3, place);
		    statement.setString(4, zip);
		    statement.setString(5, country);
	    	statement.executeUpdate();
	    	
	    	out.println("The following school was added");
	    	out.println("<br>Full name is " + fullname);
	    	out.println("<br>Short name is " + shortname);
	    	out.println("<br>Place is " + place);
	    	out.println("<br>Zip is " + zip);
	    	out.println("<br>Country is " + country);
		}
	   	
	   	connection.close();
	   	
    }
	out.print("<a href = 'lutadmin.jsp'>Back to admin page</a>");	
%>

 

</body>
</html>

