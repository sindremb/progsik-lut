<% 
String type = (String)session.getAttribute("type");

Boolean redirect = true;

if (type == null){
	redirect = true;
}else if (type.equals("1") || type.equals("2")){
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

<%
String country_full = request.getParameter("country");

InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2read");
Connection connection = ds.getConnection();

if (connection == null)
{
	throw new SQLException("Error establishing connection!");
}
String query = "Select * from country where full_name = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, country_full);
ResultSet rs = null;

try{
	rs = statement.executeQuery();
	if (!rs.next()){
		response.sendRedirect("index.jsp");
	}
}catch(Exception e){
	if (connection != null){
		connection.close();
	}
	response.sendRedirect("errorpage.jsp");
}



query = "select * from school, country where school.country = country.short_name AND country.full_name = ?"; 
statement = connection.prepareStatement(query);
statement.setString(1, country_full);
try{
	rs = statement.executeQuery();
	}
catch(Exception e){
	response.sendRedirect("errorpage.jsp");
	
}
finally{
	if(connection != null){
		connection.close();
	}
}

%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 3.0 - <%out.print(country_full); %></title>
    </head>
    <body>
        <h1>Approved schools in <%out.print(country_full); %></h1>
        <br><br>
        <table border="0">
        <% 

        String fullname = "";
        String shortname = "";
        String zip = "";
        String place = "";
        String country = "";
        String school_id = "";
        	
        while(rs.next()){
        	school_id = rs.getString("school_id");
			fullname = rs.getString("full_name");
			shortname = rs.getString("short_name");
			place = rs.getString("place");
			zip = rs.getString("zip");
			country = rs.getString("country");
			
        	out.print("<thead><tr>");
        	out.print("<th colspan = '2'>" + fullname + "</th>");
        	out.print("</tr></thead>");
        	out.print("<tbody><tr><td><strong>Nickname: </strong></td>");
        	out.print("<td><span style = 'font-size:smaller; font-style:italic;'>" + shortname + "</span></td>" );
        	out.print("</tr><tr><td><strong>Address: </strong></td>");
        	out.print("<td>" + place +"<br>");
        	out.print("<span style='font-size:smaller; font-style:italic;'>zip: "+ zip + "</span></td></tr>" );
        	out.print("<tr><td><form action='school_reviews.jsp'>");
        	out.print("<input type='hidden' name='school_id' value='" + school_id + "' />");
        	out.print("<input type='submit' name='Read reviews' value='Read reviews' />");
        	out.print("</form></td></tr></tbody>");
        }
        out.print("</table>");
        %>

        <form action="index.jsp" method="post">
        	<input type="submit" value = "Back to index">
        </form>
        <%
        if (type.equals("1")){
        	%>
        	<form action="lutadmin.jsp" method="post">
        	<input type="submit" value = "Go to admin page">
        </form>
        	 <%
        }
        %>
		<form action="logout.jsp" method="post">
        	<input type="submit" value = "Log out">
        </form>
        
        

    </body>
</html>
