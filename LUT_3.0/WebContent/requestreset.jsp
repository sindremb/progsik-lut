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
<%@page import="java.sql.Date" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%
	boolean unameerror = false;
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
		// Input validation
		String uname = request.getParameter("uname");
		unameerror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find();
		if(!isRobot && !unameerror) {
			Connection connection = null;
			try {
				InitialContext ctx = new InitialContext();
		        DataSource ds = (DataSource) ctx.lookup("jdbc/lut2write");
		        connection = ds.getConnection();
		        connection.setAutoCommit(false);
		        if (connection == null)
		        {
		            throw new SQLException("Error establishing connection!");
		        }
		        PreparedStatement userstatement = connection.prepareStatement("SELECT * FROM users WHERE uname=?");
		        userstatement.setString(1,uname);
		        ResultSet users = userstatement.executeQuery();
		        if (users.next())
		        {
		        	String email = users.getString("email");
		        	// Remove old reset key for user (if existing)
			        PreparedStatement remove = connection.prepareStatement("DELETE FROM pwdreset WHERE uname=?;");
			        remove.setString(1, uname);
			        remove.executeUpdate();
		        	// Prepeare insert pwdreset statement
				    PreparedStatement resetrequest = connection.prepareStatement(
				    		"INSERT INTO pwdreset VALUES(?,?,?)");
			        // Set the value
			        resetrequest.setString(1, uname);
			        String key = UUID.randomUUID().toString();
			        resetrequest.setString(2, key);
			        Calendar cal = Calendar.getInstance();
			        cal.add(Calendar.MINUTE, 10);
			        resetrequest.setTimestamp(3,new java.sql.Timestamp(cal.getTime().getTime()));
			        // Insert the row
			        resetrequest.executeUpdate();
			        connection.commit();
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
				    message.setSubject("LUT3.0 - PWD reset");
				    String appRoot = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
				    message.setText("Hello, "+uname+"\n\nYou have received this email because you have requested to reset your password for your user at LUT3.0"+
				    "\n\nTo reset your password you can visit this link (link valid for one use and 10min after this email has been sent)\n\n"+appRoot+"/resetpwd.jsp?uname="+uname+"&key="+key);
				    Transport transport = s.getTransport("smtp");
				    transport.connect(host, from, pass);
				    transport.sendMessage(message, message.getAllRecipients());
				    transport.close();
					// Show confirmation page
		        	pageContext.forward("requestresetconfirmation.jsp");
		        } else { unameerror=true; }
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
        <h1>Request password reset</h1>
        Looking for <a href="login.jsp">login</a>?<br /><br />
        <form action='requestreset.jsp' method='post'>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Account information</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<tr>
	                    <td colspan='2'>Please enter your username to receive further instructions of how to reset your password.</td>
	                </tr>
	                <tr>
	                    <td>Username</td>
	                    <td>
	                    	<input type='text' name='uname' value='${param.uname}' /><% if(unameerror) { %>
	                    		<div class='errormessage'>Invalid/non-existing username given</div>
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
	        <input type="submit" value="Request new password" />
    	</form>
    </body>
</html>
