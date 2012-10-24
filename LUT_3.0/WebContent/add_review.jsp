<%!
public static String sanitize(String s) {
	  
    s = s.replaceAll("(?i)<script.*?>.*?</script.*?>","");   // case 1 <script> are removed
    s = s.replaceAll("(?i)<.*?javascript:.*?>.*?</.*?>",""); // case 2 javascript: call are removed
    s = s.replaceAll("(?i)<.*?\\s+on.*?>.*?</.*?>","");     // case 3 remove on* attributes like onLoad or onClick
    s = s.replaceAll("[<>{}\\[\\];\\&]",""); // case 4 remove malicous chars. May be overkill...
    // s = s.replaceAll("j", ""); test
    return s;
}
%>

<% 
String type = (String)session.getAttribute("type");
String uname = (String)session.getAttribute("uname");

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

%><%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

 <%
String school_id = sanitize(request.getParameter("school_id"));
String review = sanitize(request.getParameter("review"));


InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
Connection connection = ds.getConnection();

if (connection == null)
{
	throw new SQLException("Error establishing connection!");
}
String query = "select * from school where school_id = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, school_id);

try{
	ResultSet rs2 = statement.executeQuery();
	if(!rs2.next()) response.sendRedirect("index.jsp");
}
catch(Exception e){
	if(connection != null){
		connection.close();
	}
	pageContext.forward("errorpage.jsp");
}
boolean duplicate = false;
try {
	connection = ds.getConnection();
} catch (Exception e) {
	pageContext.forward("errorpage.jsp");
	statement = connection.prepareStatement("SELECT * FROM user_reviews WHERE school_id = ? AND user_id = ?");
	statement.setString(1, school_id);
	statement.setString(2, uname);
	ResultSet existing = statement.executeQuery();
	if(existing.next()) duplicate = true;
} finally {
	if(connection != null) connection.close();
}
if(!duplicate && review != null && review.length() != 0 && review.trim().length() != 0) {
	ctx = new InitialContext();
	ds = (DataSource) ctx.lookup("jdbc/lut2"); // write access
	connection = ds.getConnection();
	query = "INSERT INTO user_reviews VALUES (?, ?, ?)";
	statement = connection.prepareStatement(query);
	statement.setString(1, school_id);
	statement.setString(2, uname);
	statement.setString(3, review);
	try {
		statement.executeUpdate();
	}
	catch(Exception e){
		pageContext.forward("errorpage.jsp");
	}
	finally{
		if (connection != null){
			connection.close();
		}
	}
} else {
	response.sendRedirect("school_reviews.jsp?school_id="+school_id);
	return;
}
%>
		
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="refresh" content="5;url=school_reviews.jsp?school_id=<%out.print(school_id); %>">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Review added!</title>
    </head>
    <body>
        <h1>Thanks <%out.print(uname); %>!</h1>
        Your contribution is appreciated.<br>
        You will be redirected to the LUT3.0 main page in a few seconds.
    </tr>
</body>
</html>
