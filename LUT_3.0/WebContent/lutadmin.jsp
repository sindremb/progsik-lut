

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
        		<tr>
					<td><a href = "add_school.jsp">Add a school</a></td>
				</tr>
				<tr>
					<td><a href = "usermanagament.jsp">Manage Users</a></td>
				</tr>
        	</tbody>
        </table>
        <form action="index.jsp" method="get">
        	<input type="submit" value = "Go to index">
        </form>
        <form action="logout.jsp" method="get">
        	<input type="submit" value = "Log out">
        </form>
        
    </body>
</html>
