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

%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

<%

String school_id = request.getParameter("school_id");
String fullname = request.getParameter("school_fullname");
String shortname = request.getParameter("school_shortname");

InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
Connection connection = ds.getConnection();

if (connection == null)
{
	throw new SQLException("Error establishing connection!");
}

String query = "select * from school where school_id = ? AND full_name = ? AND short_name = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, school_id);
statement.setString(2, fullname);
statement.setString(3, shortname);
ResultSet rs = null;
try{
	rs = statement.executeQuery();
	if (!rs.next()){
		response.sendRedirect("index.jsp");
	}
}catch (Exception e){
	if (connection != null){
		connection.close();
	}
	response.sendRedirect("errorpage.jsp");
}


query = "select * from user_reviews where school_id = ?";
statement = connection.prepareStatement(query);
statement.setString(1, school_id);

try{
	rs = statement.executeQuery();
}catch (Exception e){
	response.sendRedirect("errorpage.jsp");
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
        <title>Reviews for <%out.print(fullname); %></title>
    </head>
    <body>
        <h1>Reviews for <%out.print(shortname); %></h1>
		
		<%
		if(!(rs.next())){
			out.print("No reviews for" + fullname + " yet. Help us out by adding out!<br><br>");
		}else{
			String review = "";
			String userid  ="";
					
			while(rs.next()){
				review = rs.getString("review");
				userid = rs.getString("user_id");
				out.print(review + "<br>" + userid + "<br><br>");
			}
		}
		
		%>
		



        <table border="0">
            <thead>
                <tr>
                    <th colspan="2">Help improving LUT2.0 by adding a review of ${param.school_shortname}</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <form action="add_review.jsp"  method="post">
                            <input type="hidden" name="school_id" value='<%out.print(school_id); %>' />
                            <textarea name="review" rows=10 cols=60 wrap="physical" autofocus="on" > 
                            </textarea>
                            <br><br>
                            Your name: <input type="text" name="name" />
                            <br><br>
                            <input type="submit" value="Add review" />
                    </td>
                </tr>
            </tbody>
        </table>
		
        <form action="index.jsp" method="post">
        	<input type="submit" value = "Back to index">
        </form>
		<form action="logout.jsp" method="post">
        	<input type="submit" value = "Log out">
        </form>
        
    </body>
</html>
