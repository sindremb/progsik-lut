<% 
String loginuser = (String)session.getAttribute("uname");
int type = -1; 

Connection logincon = null;
try {
	InitialContext loginctx = new InitialContext();
	DataSource loginds = (DataSource) loginctx.lookup("jdbc/lut2read");
	logincon = loginds.getConnection();
	
	PreparedStatement loginstatement = logincon.prepareStatement("SELECT type FROM users WHERE uname=?");
	loginstatement.setString(1,loginuser);
	ResultSet loginrs = loginstatement.executeQuery();
	if(!loginrs.next()) {
		response.sendRedirect("login.jsp");
		return;
	}
	type = loginrs.getInt("type");
	if(type != 1) { // 1 for admin, 2 for regular user
		response.sendRedirect("login.jsp");
		return;
	}
	logincon.close();
} catch(Exception e) {
	response.sendRedirect("login.jsp");
	if(logincon != null) logincon.close();
	return;
}

%>


<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

<%! 
public static String sanitize(String s) {
  
    s = s.replaceAll("(?i)<script.*?>.*?</script.*?>","");   // case 1 <script> are removed
    s = s.replaceAll("[\\\"\\\'][\\s]*((?i)javascript):(.*)[\\\"\\\']",""); // case 2 javascript: call are removed
    s = s.replaceAll("(?i)<.*?\\s+on.*?>.*?</.*?>","");     // case 3 remove on* attributes like onLoad or onClick
    s = s.replaceAll("[<>{}\\[\\];\\&]",""); // case 4 remove malicous chars. May be overkill...
    s = s.replaceAll("eval\\((.*)\\)", ""); // case 5 removes eval () calls
    // s = s.replaceAll("j", ""); test
    return s;
}
%>

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
</table>


<%	
	String fullname = "";
	String shortname = "";
	if (request.getParameter("fullname") != null && request.getParameter("shortname") != null){
		fullname = request.getParameter("fullname");
		shortname = request.getParameter("shortname");
	}
	
	fullname = sanitize(fullname);
	shortname = sanitize(shortname);
	
	if (!(fullname.equals(""))&& !(shortname.equals(""))){
		
	    InitialContext ctx = new InitialContext();
	    DataSource ds = (DataSource) ctx.lookup("jdbc/lut2write");
	    Connection connection = ds.getConnection();
	    
	    if (connection == null)
	    {
	    	throw new SQLException("Error establishing connection!");
	    }
	    
	    
	    String query ="select * from country where full_name = ? AND short_name = ?";
	    PreparedStatement statement = connection.prepareStatement(query);
	    statement.setString(1, fullname);
	    statement.setString(2, shortname);
	    ResultSet rs = null;
	    try{
	    	rs = statement.executeQuery();
	    }catch(Exception e){
	    	
	    	if (connection != null){
	    		connection.close();
	    	}
	    	response.sendRedirect("lutadmin.jsp");
	    }
	    
	    
	   	if(!rs.next()){
	   		query = "insert into country values (?, ?)";
	    	statement = connection.prepareStatement(query);
	    	statement.setString(1, shortname);
	    	statement.setString(2, fullname);
	    	try{
	    		statement.executeUpdate();
	    	}
	    	catch(Exception e){
	    		
	    		response.sendRedirect("lutadmin.jsp");
	    	}
	    	finally{
	    		if (connection != null){
		    		connection.close();
		    	}
	    	}
	    	
	    	out.println("The following country was added  <br>");
	    	out.println("Full name is <br> " + fullname);
	    	out.println("Short name is <br>" + shortname);
		}
	   	
    }
	
%>
  	  <form action="lutadmin.jsp" method="post">
        	<input type="submit" value = "Back to admin page">
        </form>
		
		<form action="logout.jsp" method="post">
        	<input type="submit" value = "Log out">
        </form>
        
        
</body>
</html>