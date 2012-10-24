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