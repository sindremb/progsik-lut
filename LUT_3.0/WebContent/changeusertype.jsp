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

String newtype = request.getParameter("newtype");
String uname = request.getParameter("uname");

InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2write");
Connection connection = ds.getConnection();


if (newtype != null && uname != null){
	if ( !(newtype.equals("")) && !(uname.equals(""))){
		int newtypeint = 0;
		if (newtype.equals("1")){
			newtypeint = 1; 
		}else if(newtype.equals("2")) {
			newtypeint = 2;
		}
		String query3 = "update users set type = ? where uname = ?";
		PreparedStatement settype = connection.prepareStatement(query3);
		settype.setInt(1,newtypeint);
		settype.setString(2, uname);
		
		try {
			settype.executeUpdate();
		}
		catch (Exception e){
			if (connection != null){
				connection.close();
			}
			pageContext.forward("lutadmin.jsp");
		}
		finally{
			if(connetion != null){
				connection.close();
			}
		}
	}
}

response.sendRedirect("usermanagament.jsp");
%>

</body>
</html>