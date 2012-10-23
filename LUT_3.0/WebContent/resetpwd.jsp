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
	// Get and validate required params (get and post)
	String uname = request.getParameter("uname");
	String key = request.getParameter("key");
	boolean unameerror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find();
	boolean keyerror = Pattern.compile("[^a-z0-9-]", Pattern.CASE_INSENSITIVE).matcher(key).find();
	if(unameerror || keyerror) {
		pageContext.forward("errorpage.jsp");
	}
	// Check if pwd reset request exists, has valid key and is not expired
	InitialContext ctx = new InitialContext();
    DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
    Connection connection = ds.getConnection();
    if (connection == null)
    {
        throw new SQLException("Error establishing connection!");
    }
    String sql = "SELECT * FROM pwdreset WHERE uname='"+uname+"';";
    PreparedStatement activate = connection.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
    activate.setString(1, uname);
    ResultSet rs = activate.executeQuery();
    if (!rs.next())
    {
    	pageContext.forward("errorpage.jsp");
    }
    String storedkey = rs.getString("key");
    java.util.Date valid = rs.getDate("valid");
    if (!storedkey.equals(key)) {
    	pageContext.forward("errorpage.jsp");
    }
	boolean pwderror = false;
	boolean pwdconfirmerror = false;
	// If post request - check if valid new pwd info is given -> update
	if("POST".equalsIgnoreCase(request.getMethod())) {
		String pwd = request.getParameter("pwd");
		String pwdconfirm = request.getParameter("pwdconfirm");
		pwderror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(pwd).find();
		pwdconfirmerror = !pwd.equals(pwdconfirm);
		if(!pwderror && ! pwdconfirmerror) {
			InitialContext ctx = new InitialContext();
	        DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
	        Connection connection = ds.getConnection();
	        if (connection == null)
	        {
	            throw new SQLException("Error establishing connection!");
	        }
	        String unamequery = "SELECT * FROM users WHERE uname='" + uname + "';";
	        PreparedStatement unamestatement = connection.prepareStatement(unamequery);
	        ResultSet unamers = unamestatement.executeQuery();
	        if (unamers.next())
	        {
	            unameunique = false;
	        }
	        String emailquery = "SELECT * FROM users WHERE email='" + email + "';";
	        PreparedStatement emailstatement = connection.prepareStatement(emailquery);
	        ResultSet emailrs = emailstatement.executeQuery();
	        if (emailrs.next())
	        {
	            emailunique = false;
	        }
	        if(unameunique && emailunique) {
	        	// Prepeare insert user statement
			    String sql = "INSERT INTO users (uname,email,firstname,lastname,type,active) VALUES(?,?,?,?,?,?)";
			    PreparedStatement createUser = connection.prepareStatement(sql);
		        // Set the value
		        createUser.setString(1, uname);
		        createUser.setString(2, email);
		        createUser.setString(3, fname);
		        createUser.setString(4, lname);
		        createUser.setInt(5, 2);
		        createUser.setInt(6, 0);
		        // Insert the row
		        createUser.executeUpdate();
		        // Create activate key for user
				String key = UUID.randomUUID().toString();
				String sql2 = "INSERT INTO activate (uname,key) VALUES(?,?)";
			    PreparedStatement activate = connection.prepareStatement(sql2);
		        // Set the value
		        activate.setString(1, uname);
		        activate.setString(2, key);
		        // Insert the row
		        activate.executeUpdate();
				// Show confirmation page
	        	pageContext.forward("pwdresetconfirmation.jsp");
	        }
		}
	}
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
        <h1>Reset password</h1>
	        <form action='pwdreset.jsp' method='post'>
	        <!-- implicit url info -->
	        <input type='hidden' name='uname' value='${param.uname}'>
	        <input type='hidden' name='tempkey' value='${param.key}'>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Set new password</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<tr>
	                    <td colspan='2'>Please enter (and confirm) the new password you would like.</td>
	                </tr>
	                <tr>
	                    <td>New Password</td>
	                    <td>
	                    	<input type='text' name='pwd' value='' /><% if(pwderror) { %>
	                    		<div class='errormessage'>Password can only consist of letters and numbers</div>
	                    	<% } %>
	                    </td>
	                </tr>
	                <tr>
	                    <td>Confirm New Password</td>
	                    <td>
	                    	<input type='text' name='pwdconfirm' value='' /><% if(pwdconfirmerror) { %>
	                    		<div class='errormessage'>Password and password confirmation must be equal</div>
	                    	<% } %>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <input type="submit" value="Request new password" />
    	</form>
    </body>
</html>
