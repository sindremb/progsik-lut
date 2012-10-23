<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Date"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.util.*" %>
<%@page import="java.security.MessageDigest"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%
	//Brute force protection
	Thread.sleep(2000);
	boolean isRobot = false;
	// Get and validate required params (both get and post)
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
    connection.setAutoCommit(false);
    if (connection == null)
    {
        throw new SQLException("Error establishing connection!");
    }
    PreparedStatement resetrequest = connection.prepareStatement("SELECT * FROM pwdreset WHERE uname=?");
    resetrequest.setString(1, uname);
    ResultSet rs = resetrequest.executeQuery();
    if (!rs.next())
    {
    	pageContext.forward("errorpage.jsp");
    }
    // Check for expiration
    Calendar cal = Calendar.getInstance();
    java.sql.Timestamp current = new java.sql.Timestamp(cal.getTime().getTime());
    java.sql.Timestamp valid = rs.getTimestamp("valid");
    // Check for valid reset key
	String storedkey = rs.getString("key");
    if (current.compareTo(valid) > 0 || !storedkey.equals(key)) {
    	pageContext.forward("errorpage.jsp");
    }
	boolean pwderror = false;
	boolean pwdconfirmerror = false;
	// If post request - check if valid new pwd info is given -> update
	if("POST".equalsIgnoreCase(request.getMethod())) {
		// Bot protection
		try {
			int captchakey=Integer.parseInt((String)session.getAttribute("key"));
			int enterednumber=Integer.parseInt(request.getParameter("number"));
			isRobot = captchakey != enterednumber;
		} catch(NumberFormatException e) {
			isRobot = true;
		}
		// input validation
		String pwd = request.getParameter("pwd");
		String pwdconfirm = request.getParameter("pwdconfirm");
		pwderror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(pwd).find();
		pwdconfirmerror = !pwd.equals(pwdconfirm);
		if(!isRobot && !pwderror && ! pwdconfirmerror) {
		    //hashing
	        MessageDigest digest = MessageDigest.getInstance("SHA-256");
			digest.reset();
			String salt = UUID.randomUUID().toString();
			digest.update(salt.getBytes("UTF-8"));
			String pwhash = new String(digest.digest(pwd.getBytes("UTF-8")), "UTF-8");
	        // Set the value
	        PreparedStatement resetpwd = connection.prepareStatement(
		    		"UPDATE users SET salt = ? , pw = ? WHERE uname = ?");
	        resetpwd.setString(1, salt);
	        resetpwd.setString(2, pwhash);
	        resetpwd.setString(3, uname);
	        // Insert the row
	        resetpwd.executeUpdate();
	        connection.commit();
			// Show confirmation page
        	pageContext.forward("resetpwdconfirmation.jsp");
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
	        <form action='resetpwd.jsp' method='post'>
	        <!-- implicit url info -->
	        <input type='hidden' name='uname' value='${param.uname}'>
	        <input type='hidden' name='key' value='${param.key}'>
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
	                    	<input type='password' name='pwd' value='' /><% if(pwderror) { %>
	                    		<div class='errormessage'>Password can only consist of letters and numbers</div>
	                    	<% } %>
	                    </td>
	                </tr>
	                <tr>
	                    <td>Confirm New Password</td>
	                    <td>
	                    	<input type='password' name='pwdconfirm' value='' /><% if(pwdconfirmerror) { %>
	                    		<div class='errormessage'>Password and password confirmation must be equal</div>
	                    	<% } %>
	                    </td>
	                </tr>
	            </tbody>
	        </table><br />
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Are you a robot?</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                	<td colspan='2'>To avoid robots taking over the world, robots are not allowed into LUT3.0. <br /><br /> 
	                		Please undertake the following test to convince us you are not a robot</td>
	                </tr>
	                <tr> 
	                	<td align="center" colspan="2">
	                		<img src="mcap.jsp"><br><br>
							<input type="button" value="Refresh Image" onClick="window.location.href=window.location.href"></td></tr>
	                	<td align="center"> Please enter the answer for above calculation.</td><tr>
					</tr>
					<tr>
						<td align="center"><input name="number" type="text"><% if(isRobot) { %>
	                    		<div class='errormessage'>You are a robot, please turn into a human!</div>
	                    	<% } %></td>
					</tr>
	            </tbody>
	        </table>
	        <input type="submit" value="Request new password" />
    	</form>
    </body>
</html>
