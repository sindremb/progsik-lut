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

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>lol</title>
</head>
<body>

<%

String delete = request.getParameter("delete");
String uname = request.getParameter("uname");

InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2write");
Connection connection = ds.getConnection();



if (delete != null && uname != null){
	if (!(delete.equals("")) && delete.equals("true") && !(uname.equals(""))){
		String query = "delete from users where uname = ?";
		PreparedStatement deletestatement = connection.prepareStatement(query);
		deletestatement.setString(1, uname);
		
		try {
			deletestatement.executeUpdate();
		}
		catch (Exception e){
			if (connection != null){
				connection.close();
			}
			pageContext.forward("lutadmin.jsp");
		}
		finally{
			if (connection != null){
				connection.close();
			}
		}
	}
}
response.sendRedirect("usermanagament.jsp");
%>
</body>
</html>