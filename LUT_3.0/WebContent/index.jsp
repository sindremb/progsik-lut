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
InitialContext ctx = new InitialContext();
DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
Connection connection = ds.getConnection();

if (connection == null)
{
	throw new SQLException("Error establishing connection!");
}


String query = "select full_name from country"; 
PreparedStatement statement = connection.prepareStatement(query);
ResultSet rs = statement.executeQuery();
connection.close();

%>

<%@ page import="java.sql.*" %>
<%! String uname=""; %>

<%
uname=(String)session.getAttribute("uname");
%> 

<%
session.setMaxInactiveInterval(900 * 1); //automatic logout after 900 seconds :P
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
        <h1>Welcome: <strong><%= uname %></strong></h1>
        <table border="0">
            <thead>
                <tr>
                    <th>LUT 3.0 provides information about approved international schools</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>To view information about schools in a country, please select a country below:</td>
                </tr>
                <tr>
                    <td><form action="schools.jsp">
                            <strong>Select a country:</strong>
                            <select name="country">
                                <%
                                String full_name = "";
                                while (rs.next()){
                                	full_name = rs.getString("full_name");
                                	out.print("<option value = '" + full_name + "'>" + full_name + "</option>");
                                }
                                %>
                            </select>
                            <input type="submit" value="submit" />
                        </form></td>
                </tr>
            </tbody>
        </table>
         <br>
        <br>
        <br>
        <br>
        <br>
        <form action="logout.jsp" method="post">
        	<input type="submit" value = "Log out">
        </form>
        

    </body>
</html>
