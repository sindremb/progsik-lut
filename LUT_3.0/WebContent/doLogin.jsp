<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.security.MessageDigest"%>



<%! 
public static String sanitize(String s) {
  
     s = s.replaceAll("(?i)<script.*?>.*?</script.*?>","");   // case 1 <script> are removed
     s = s.replaceAll("(?i)<.*?javascript:.*?>.*?</.*?>",""); // case 2 javascript: call are removed
     s = s.replaceAll("(?i)<.*?\\s+on.*?>.*?</.*?>","");     // case 3 remove on* attributes like onLoad or onClick
     s = s.replaceAll("[<>{}\\[\\];\\&]",""); // case 4 remove malicous chars. May be overkill...
     // s = s.replaceAll("j", ""); test
     return s;
}
%>

<% String uname="",pw=""; String number="";%>
<% 
	
	int loginattempts = 1;
	int maxattempts = 10;
	int timeout = 1000;
	
	number=request.getParameter("number");


	String sest=(String)session.getAttribute("key");
	int key=Integer.parseInt(sest);
	int user=Integer.parseInt(request.getParameter("number"));
	
		/*
		if(key==user)			
				{
				out.print("Verification success");
				}
		else	{
				out.print("You have entered wrong verification code!! <br> Please go back and enter proper value.");	
	*/


	InitialContext ctx = new InitialContext();
	DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
	Connection connection = ds.getConnection();
	
	if (connection == null)
    {
        throw new SQLException("Error establishing connection!");
    }

	uname=request.getParameter("uname");
	pw=request.getParameter("pw");
	
	number=request.getParameter("number");
	

	
	
	uname = sanitize(uname);
	pw = sanitize(pw);
	
	String query = "SELECT * FROM users WHERE uname = ?";
	PreparedStatement statement = connection.prepareStatement(query);
   	statement.setString(1, uname);
	ResultSet rs;
	rs=statement.executeQuery();

	String salt = "";
	String pwdbhash = "";
	
	if(rs.next()){
		salt = rs.getString("salt");
		pwdbhash = rs.getString("pw");
	}
	
	 //hashing
    MessageDigest digest = MessageDigest.getInstance("SHA-256");
	digest.reset();
	digest.update(salt.getBytes("UTF-8"));
	String pwhash = new String(digest.digest(pw.getBytes("UTF-8")), "UTF-8");

	//System.out.println("uname="+uname+" pw="+pw);
		if(pwdbhash.equals(pwhash) && key==user)
			{
				String type = rs.getString("type");
				if ("1".equals(type)) {
					session.setAttribute("uname",uname);
					session.setAttribute("type", "1");
					connection.close();
					response.sendRedirect("lutadmin.jsp");
				} else if ("2".equals(type)) {
					session.setAttribute("uname",uname);
					session.setAttribute("type", "2");
					connection.close();
					response.sendRedirect("index.jsp");
				}
			}
		else if (key!=user) {
			loginattempts++;
			timeout = timeout*2;
			if (loginattempts < maxattempts) {
				Thread.sleep(timeout);
			%>
			<html>
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			        <link rel="stylesheet" type="text/css" href="lutstyle.css">
			     	<title>Authentication failed</title>
				</head>
				
				<body>	
					<h1>Invalid verification code</h1>
					<h3>Please try again</h3>
					<jsp:include page="login.jsp"/> 
					
			<% 
			}
			else {
				response.sendRedirect("http://www.sometimesredsometimesblue.com/");
				
			}
		}
		else 
			{
			loginattempts++;
			timeout = timeout*2;
			if (loginattempts < maxattempts) {
				Thread.sleep(timeout);
				
			%>
				<html>
				<head>
					<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        			<link rel="stylesheet" type="text/css" href="lutstyle.css">
     				<title>Authentication failed</title>
				</head>
	
				<body>	
					<h1>Invalid username or password</h1>
					<h3>Please try again</h3>
					<jsp:include page="login.jsp"/>
					
   					 
			<% 
			}
			else {
			response.sendRedirect("http://www.sometimesredsometimesblue.com/");
			} 
	
	}
	%>
	</body>


</html>
