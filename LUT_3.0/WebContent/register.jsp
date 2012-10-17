<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern" %>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.io.*,java.util.*,javax.mail.*"%>
<%@page import="javax.mail.internet.*,javax.activation.*"%>
<%@page import="javax.servlet.http.*,javax.servlet.*" %>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%
	boolean unameerror = false;
	boolean fnameerror = false;
	boolean lnameerror = false;
	boolean emailerror = false;
	boolean pwderror = false;
	boolean pwdconfirmerror = false;
	boolean unameunique = true;
	boolean emailunique = true;
	if("POST".equalsIgnoreCase(request.getMethod())) {
		String uname = request.getParameter("uname");
		String email = request.getParameter("email");
		String pwd = request.getParameter("pwd");
		String pwdconfirm = request.getParameter("pwdconfirm");
		String fname = request.getParameter("fname");
		String lname = request.getParameter("lname");
		unameerror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find();
		emailerror = Pattern.compile("[^a-z0-9._&@^a-z0-9.]", Pattern.CASE_INSENSITIVE).matcher(email).find();
		pwderror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(pwd).find();
		pwdconfirmerror = !pwd.equals(pwdconfirm);
		fnameerror = Pattern.compile("[^a-z0-9øæå]", Pattern.CASE_INSENSITIVE).matcher(fname).find();
		lnameerror = Pattern.compile("[^a-z0-9øæå]", Pattern.CASE_INSENSITIVE).matcher(lname).find();
		if(!unameerror && !emailerror && !pwderror && ! pwdconfirmerror && !fnameerror && !lnameerror) {
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
	        	// Create user
	        	String createquery = "INSERT INTO users VALUES(uname='" +uname+ "',email='" + email + "', firstname='"+ fname
	        		+ "', lname='" + lname + "', pw='" + pwd +"', type=2, active=0);";
		        PreparedStatement createstatement = connection.prepareStatement(emailquery);
		        createstatement.executeQuery();
		        // Send email
	       		String result;
		   		// Recipient's email ID needs to be mentioned.
		   		String to = email;
			
				// Sender's email ID needs to be mentioned
				String from = "jalla@haxor.com";
				
				// Assuming you are sending email from localhost
				String host = "localhost";
				
				// Get system properties object
				Properties properties = System.getProperties();
				
				// Setup mail server
				properties.setProperty("mail.smtp.host", host);
				
				// Get the default Session object.
				Session mailSession = Session.getDefaultInstance(properties);
				
				try{
				   // Create a default MimeMessage object.
				   MimeMessage message = new MimeMessage(mailSession);
				   // Set From: header field of the header.
				   message.setFrom(new InternetAddress(from));
				   // Set To: header field of the header.
				   message.addRecipient(Message.RecipientType.TO,
				                            new InternetAddress(to));
				   // Set Subject: header field
				   message.setSubject("This is the Subject Line!");
				   // Now set the actual message
				   message.setText("This is actual message");
				   // Send message
				   Transport.send(message);
				   result = "Sent message successfully....";
				}catch (MessagingException mex) {
				   mex.printStackTrace();
				   result = "Error: unable to send message....";
		    	}
				// Show confirmation page
	        	pageContext.forward("registerconfirmation.jsp");
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
        <h1>Register new user</h1>
        <form action='register.jsp' method='post'>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Personal information</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>First Name</td>
	                    <td>
	                    	<input type='text' name='fname' value='${param.fname}' /><% if(fnameerror) { %>
	                    		<div class='errormessage'>First name can only consist of letters [a-z+æøå]</div>
	                    	<% } %>
	                    </td>
	                </tr>
	                <tr>
	                    <td>Last Name</td>
	                    <td>
	                    	<input type='text' name='lname' value='${param.lname}' /><% if(lnameerror) { %>
	                    		<div class='errormessage'>Username can only consist of letters [a-z+øæå]</div>
	                    	<% } %>
	                    </td>
	                </tr>
	                <tr>
	                    <td>Email</td>
	                    <td>
	                    	<input type='text' name='email' value='${param.email}' /><% if(emailerror) { %>
	                    		<div class='errormessage'>Not a legal email address (must be of the form account@domain.domainext)</div>
	                    	<% } if(!emailunique) { %>
	                    		<div class='errormessage'>A user with the given email address already exists</div>
	                    	<% } %>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <br /><br />
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Login information</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>Username</td><td>
	                    	<input type='text' name='uname' value='${param.uname}' />
	                    	<% if(unameerror) { %>
	                    		<div class='errormessage'>Username can only consist of letters [a-z] and digits and have a length between 5 and 15</div>
	                    	<% } if(!unameunique) { %>
                    			<div class='errormessage'>A user with the given username already exists</div>
                    		<% } %>
	                    </td>
	                </tr>
	                <tr>
	                    <td>Password</td>
	                    <td>
	                    	<input type='password' name='pwd' /><% if(pwderror) { %>
	                    		<div class='errormessage'>Password can only consist of letters and numbers</div>
	                    	<% } %>
	                    </td>
	                    
	                </tr>
	                <tr>
	                    <td>Confirm password</td>
	                    <td>
	                    	<input type='password' name='pwdconfirm' /><% if(pwdconfirmerror) { %>
	                    		<div class='errormessage'>Password and password confirmation must be equal</div>
	                    	<% } %>
	                    </td>
	                </tr>
	            </tbody>
	        </table>
	        <input type="submit" value="Register" />
    	</form>
    </body>
</html>
