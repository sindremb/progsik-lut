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


String query = "select * from user_reviews where school_id = ?";
PreparedStatement statement = connection.prepareStatement(query);
statement.setString(1, school_id);
ResultSet rs = statement.executeQuery();
connection.close();
	
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

    </body>
</html>
