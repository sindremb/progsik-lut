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
		        // Send email
				String host = "smtp.gmail.com";
			    String from = "bestlut3";
			    String pass = "nY67txzq";
			    Properties props = System.getProperties();
			    props.put("mail.smtp.starttls.enable", "true"); // added this line
			    props.put("mail.smtp.host", host);
			    props.put("mail.smtp.user", from);
			    props.put("mail.smtp.password", pass);
			    props.put("mail.smtp.port", "587");
			    props.put("mail.smtp.auth", "true");

			    String[] to = {email}; // added this line

			    Session s = Session.getDefaultInstance(props, null);
			    MimeMessage message = new MimeMessage(s);
			    message.setFrom(new InternetAddress(from));

			    InternetAddress[] toAddress = new InternetAddress[to.length];

			    // To get the array of addresses
			    for( int i=0; i < to.length; i++ ) { // changed from a while loop
			        toAddress[i] = new InternetAddress(to[i]);
			    }
			    System.out.println(Message.RecipientType.TO);

			    for( int i=0; i < toAddress.length; i++) { // changed from a while loop
			        message.addRecipient(Message.RecipientType.TO, toAddress[i]);
			    }
			    message.setSubject("Success!");
			    message.setText("You have received this email because you have registered a user with this email at the best LUT3.0");
			    Transport transport = s.getTransport("smtp");
			    transport.connect(host, from, pass);
			    transport.sendMessage(message, message.getAllRecipients());
			    transport.close();
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
        Already have a user? <a href="login.jsp">Log in here</a><br /><br />
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
