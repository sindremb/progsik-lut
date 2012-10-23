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
	if("POST".equalsIgnoreCase(request.getMethod())) {
		String uname = request.getParameter("uname");
		unameerror = Pattern.compile("[^a-z0-9]", Pattern.CASE_INSENSITIVE).matcher(uname).find();
		if(!unameerror) {
			InitialContext ctx = new InitialContext();
	        DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
	        Connection connection = ds.getConnection();
	        if (connection == null)
	        {
	            throw new SQLException("Error establishing connection!");
	        }
	        String userquery = "SELECT * FROM users WHERE uname='" + uname + "';";
	        PreparedStatement userstatement = connection.prepareStatement(userquery);
	        ResultSet users = userstatement.executeQuery();
	        if (users.next())
	        {
	        	String email = users.getString("email");
	        	// Prepeare insert pwdreset statement
			    String sql = "INSERT INTO pwdreset (uname,key,valid) VALUES(?,?,?)";
			    PreparedStatement resetrequest = connection.prepareStatement(sql);
		        // Set the value
		        resetrequest.setString(1, uname);
		        String key = UUID.randomUUID().toString();
		        resetrequest.setString(2, key);
		        Calendar cal = Calendar.getInstance();
		        cal.add(Calendar.MINUTE, 10);
		        resetrequest.setDate(3,new java.sql.Date(cal.getTime().getTime()));
		        // Insert the row
		        resetrequest.executeUpdate();
		        // Create activate key for user
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
			    "\n\nTo reset your password you can visit this link (link valid for 10min after this email has been sent)\n\n"+appRoot+"/resetpwd.jsp?uname="+uname+"&key="+key);
			    Transport transport = s.getTransport("smtp");
			    transport.connect(host, from, pass);
			    transport.sendMessage(message, message.getAllRecipients());
			    transport.close();
				// Show confirmation page
	        	pageContext.forward("resetrequestconfirmation.jsp");
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
	        <input type="submit" value="Request new password" />
    	</form>
    </body>
</html>
