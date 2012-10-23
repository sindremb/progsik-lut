<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%
	String uname = request.getParameter("uname");
	String key = request.getParameter("key");
	boolean unameerror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find();
	boolean keyerror = Pattern.compile("[^a-z0-9-]", Pattern.CASE_INSENSITIVE).matcher(key).find();
	if(unameerror || keyerror) {
		pageContext.forward("errorpage.jsp");
	}
	InitialContext ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
    Connection connection = ds.getConnection();
    connection.setAutoCommit(false);
    if (connection == null)
    {
        throw new SQLException("Error establishing connection!");
    }
    String sql = "SELECT * FROM activate WHERE uname='"+uname+"';";
    PreparedStatement activate = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    ResultSet rs = activate.executeQuery(sql);
    if (!rs.next())
    {
    	pageContext.forward("errorpage.jsp");
    }
    String storedkey = rs.getString("key");
    if (!storedkey.equals(key)) {
    	pageContext.forward("errorpage.jsp");
    }
    //rs.deleteRow();
    String sql2 = "UPDATE users SET active=1 WHERE uname=?;";
    PreparedStatement update = connection.prepareStatement(sql2);
    update.setString(1, uname);
    //update.executeUpdate();
    connection.commit();
%>
		
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT 3.0 - Help Students Conquer the World</title>
    </head>
    <body>
        <h1>Activation successful</h1>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Activate new user confirmation</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>You have successfully activated your new user for LUT3.0. 
	                    Now that your account is active, you can <a href="login.jsp">log in here</a></td>
	                    <td>
	                </tr>
	            </tbody>
	        </table>
    </body>
</html>
