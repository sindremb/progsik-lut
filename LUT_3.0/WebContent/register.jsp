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
<%@page import="java.util.UUID" %>
<%@page import="java.security.MessageDigest"%>
<%@page import="sun.misc.BASE64Encoder"%>
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
	boolean isRobot = false;
	if("POST".equalsIgnoreCase(request.getMethod())) {
		// Bot protection
		try {
			Thread.sleep(2000);
		} catch (Exception e) {}
		try {
			int captchakey=Integer.parseInt((String)session.getAttribute("key"));
			int enterednumber=Integer.parseInt(request.getParameter("number"));
			isRobot = captchakey != enterednumber;
		} catch(NumberFormatException e) {
			isRobot = true;
		}
		// Inputcollection and validation
		String uname = request.getParameter("uname");
		String email = request.getParameter("email");
		String pwd = request.getParameter("pwd");
		String pwdconfirm = request.getParameter("pwdconfirm");
		String fname = request.getParameter("fname");
		String lname = request.getParameter("lname");
		unameerror = Pattern.compile("[^.{4,16}a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find() || uname.length() < 3 || uname.length() > 15;
		emailerror = Pattern.compile("[^a-z0-9._&@^a-z0-9.]", Pattern.CASE_INSENSITIVE).matcher(email).find() || email.length() < 5 || email.length() > 255;
		pwderror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(pwd).find() || pwd.length() < 3 || pwd.length() > 255;
		pwdconfirmerror = !pwd.equals(pwdconfirm);
		fnameerror = Pattern.compile("[^a-z0-9 Ã¸Ã¦Ã¥]", Pattern.CASE_INSENSITIVE).matcher(fname).find() || fname.length() < 2 || fname.length() > 255;
		lnameerror = Pattern.compile("[^a-z0-9 Ã¸Ã¦Ã¥]", Pattern.CASE_INSENSITIVE).matcher(lname).find() || lname.length() < 2 || lname.length() > 255;
		if(!isRobot && !unameerror && !emailerror && !pwderror && ! pwdconfirmerror && !fnameerror && !lnameerror) {
			Connection connection = null;
			try {
				InitialContext ctx = new InitialContext();
		        DataSource ds = (DataSource) ctx.lookup("jdbc/lut2read");
		        connection = ds.getConnection();
		        connection.setAutoCommit(false);
		        if (connection == null)
		        {
		            throw new SQLException("Error establishing connection!");
		        }
		        PreparedStatement unamestatement = connection.prepareStatement(
		        		"SELECT * FROM users WHERE uname = ?");
		        unamestatement.setString(1,uname);
		        ResultSet unamers = unamestatement.executeQuery();
		        if (unamers.next())
		        {
		            unameunique = false;
		        }
		        PreparedStatement emailstatement = connection.prepareStatement(
		        		"SELECT * FROM users WHERE email = ?");
		        emailstatement.setString(1,email);
		        ResultSet emailrs = emailstatement.executeQuery();
		        if (emailrs.next())
		        {
		            emailunique = false;
		        }
		        if(unameunique && emailunique) {
		        	connection.close();
		        	ds = (DataSource) ctx.lookup("jdbc/lut2write");
		        	connection = ds.getConnection();
		        	connection.setAutoCommit(false);
		        	// Prepeare insert user statement
				    PreparedStatement createUser = connection.prepareStatement(
				    		"INSERT INTO users (uname,email,firstname,lastname,type,active,salt,pw) VALUES(?,?,?,?,?,?,?,?)");
				  	//hashing
			        MessageDigest digest = MessageDigest.getInstance("SHA-256");
					digest.reset();
					String salt = UUID.randomUUID().toString();
					digest.update(salt.getBytes("UTF-8"));
					String pwhash = new String(digest.digest(pwd.getBytes("UTF-8")), "UTF-8");
					BASE64Encoder encoder = new BASE64Encoder();
					String pwhashencoded = encoder.encodeBuffer(pwhash.getBytes());
			        
			        // Set the value
			        createUser.setString(1, uname);
			        createUser.setString(2, email);
			        createUser.setString(3, fname);
			        createUser.setString(4, lname);
			        createUser.setInt(5, 2);
			        createUser.setInt(6, 0);
			        createUser.setString(7, salt);
			        createUser.setString(8, pwhashencoded);
			        // Insert the row
			        createUser.executeUpdate();
			        // Create activate key for user
					String key = UUID.randomUUID().toString();
				    PreparedStatement activate = connection.prepareStatement("INSERT INTO activate VALUES(?,?)");
				    // Set the value
			        activate.setString(1, uname);
			        activate.setString(2, key); 
			        // Insert the row
			        activate.executeUpdate();
					connection.commit();
					if(connection != null) connection.close();
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
				    message.setSubject("Welcome to LUT3.0!");
				    String appRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
				    message.setText("Hello, "+uname+"\n\nYou have received this email because you have registered a user with this email at the best LUT3.0"+
				    "\n\nTo activate your account you can visit this link\n\n"+appRoot+"/activate.jsp?uname="+uname+"&key="+key);
				    Transport transport = s.getTransport("smtp");
				    transport.connect(host, from, pass);
				    transport.sendMessage(message, message.getAllRecipients());
				    transport.close();
					// Show confirmation page
		        	pageContext.forward("registerconfirmation.jsp");
		        }
			} catch (Exception e) {
	        	pageContext.forward("errorpage.jsp");
	        } finally {
	        	if(connection != null) connection.close();
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
	                    		<div class='errormessage'>First name can only consist of letters [a-z+Ã¦Ã¸Ã¥]</div>
	                    	<% } %>
	                    </td>
	                </tr>
	                <tr>
	                    <td>Last Name</td>
	                    <td>
	                    	<input type='text' name='lname' value='${param.lname}' /><% if(lnameerror) { %>
	                    		<div class='errormessage'>Username can only consist of letters [a-z+Ã¸Ã¦Ã¥]</div>
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
	        <br />
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
	                    		<div class='errormessage'>Username can only consist of letters [a-z] and digits and have a length of at least 3 characters</div>
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
	        <br />
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
							<input type="button" value="Refresh Image" onClick="window.location.href=window.location.href"><br /><br />
	                		Please enter the answer for above calculation.
	                	</td>
					</tr>
					<tr>
						<td align="center"><input name="number" type="text"><% if(isRobot) { %>
	                    		<div class='errormessage'>You are a robot, please turn into a human!</div>
	                    	<% } %></td>
					</tr>
	            </tbody>
	        </table>
	        <input type="submit" value="Register" />
    	</form>
    </body>
</html>
