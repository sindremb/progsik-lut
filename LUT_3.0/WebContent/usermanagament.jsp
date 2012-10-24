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


<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%
out.print(session.getAttribute("uname"));

InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2read");
Connection connection = ds.getConnection();



if (connection == null)
{
	throw new SQLException("Error establishing connection!");
}


String query ="select uname, type, active from users";
PreparedStatement statement = connection.prepareStatement(query);
ResultSet rs = null;
try{
	rs = statement.executeQuery();
}
catch (Exception e){
	response.sendRedirect("lutadmin.jsp");
}
finally{
	if (connection != null){
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
        <title>Manage the users</title>
    </head>
    <body>
    	Here you can make a user admin or delete them!
    	<table>
    		<tr>
    			<td><strong>User</strong></td>
    			<td><strong>Type</strong></td>
    		</tr>
    		<%	
    			String username = "";
    			int type = 0;
    			String typestring = "";
    			int active = 0;
    			String activestring = "";
    			int newtype = 0;
    			String newtypestring = "";
				while(rs.next()){
					username = rs.getString("uname");
					type = rs.getInt("type");
					active = rs.getInt("active");
					if (type == 1){
						typestring = "Admin";
						newtype = 2;
						newtypestring = "Make regular user";
					}else if (type == 2){
						typestring = "User";
						newtype = 1;
						newtypestring = "Make admin";
					}
					if (active == 0){
						activestring = "User not validated!";
					}else if(active == 1 ){
						activestring = "Validated";
					}
					out.print("<tr>");
					out.print("<td>" + username + "</td>");
					out.print("<td>" + typestring + "</td>");
					out.print("<td>" + activestring + "</td>");
					out.print("<td><form action = 'changeusertype.jsp' method = post>");
					out.print("<input type = 'hidden' name = 'newtype' value = '" + newtype + "'/>");
					out.print("<input type = 'hidden' name = 'uname' value = '" + username + "'/>");
					out.print("<input type = 'submit' value = '" + newtypestring +  "' /></td></form>");
					out.print("<td><form action = 'deleteuser.jsp' method = post>");
					out.print("<input type = 'hidden' name = 'delete' value = 'true'/>");
					out.print("<input type = 'hidden' name = 'uname' value = '" + username + "'/>");
					out.print("<input type = 'submit' value = 'Delete user' /></td></form>");
					out.print("</tr>");
					
				}
    		%>
    	</table>
    	<% out.print("<a href = 'lutadmin.jsp'>Back to admin page</a>");%>
    
    </body>
    <form action="logout.jsp" method="post">
        	<input type="submit" value = "Log out">
        </form>
        
</html>
