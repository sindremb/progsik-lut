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
}

%><%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

<% 

String school_id = request.getParameter("school_id");
String review = request.getParameter("review");
String name = request.getParameter("name");

InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
Connection connection = ds.getConnection();

if (connection == null)
{
	throw new SQLException("Error establishing connection!");
}

String query = "INSERT INTO user_reviews VALUES (?, ?, ?)";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, school_id);
statement.setString(2, name);
statement.setString(3, review);
statement.executeUpdate();
connection.close();

%>
		
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content="5;url=index.jsp"> 
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Review added!</title>
    </head>
    <body>
        <h1>Thanks ${param.name}!</h1>
        Your contribution is appreciated.<br>
        You will be redirected to the LUT2.0 main page in a few seconds.
    </tr>
</body>
</html>
