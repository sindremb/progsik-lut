<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.security.MessageDigest"%>


<% // not able to login with GET. avoid null pointer exception if users try to refresh doLogin.jsp when failing to login
if ("Get".equalsIgnoreCase(request.getMethod())) {
	response.sendRedirect("login.jsp");
	return;
}

%>

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
	int timeout = 1000; //= 1 sec, will be doubled after each failed login attempt
	
	number=request.getParameter("number");

	boolean isRobot = false;
	
	String sest=(String)session.getAttribute("key");
	
	
	try {
	int key=Integer.parseInt(sest);
	int user=Integer.parseInt(request.getParameter("number"));
		if (key != user) {
			isRobot = true;
		}
	} catch (NumberFormatException e) {
		isRobot = true;
	}

		
	
		
		/*
		if(key==user)			
				{
				out.print("Verification success");
				}
		else	{
				out.print("You have entered wrong verification code!! <br> Please go back and enter proper value.");	
	*/


	InitialContext ctx = new InitialContext();
	DataSource ds = (DataSource) ctx.lookup("jdbc/lut2read");
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
	
	
	if (isRobot) {
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
				
		<% } else {
			%>
			<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		        <link rel="stylesheet" type="text/css" href="lutstyle.css">
		     	<title>You must be a robot</title>
			</head>
			
			<body>
				<h1>You have failed login to many times</h1>
				<h3>If u fail to answer the question below before the timer runs out you will be redirected to a random page on the web</h3>
				<script>  
				<!--  
				<%  
				String clock = request.getParameter( "clock" );  
					if( clock == null ) clock = "10";  
				%>  
				var timeout = <%=clock%>;  
				function timer()  {  
					if( --timeout > 0 )  {  
						document.forma.clock.value = timeout;  
						window.setTimeout( "timer()", 1000 );  
					}  
					else  {  
						document.forma.clock.value = "Time over";
						window.location.href = "http://www.sometimesredsometimesblue.com/";
						///disable submit-button etc  
					}  
				}  
				//-->  
				</script>  
				<body>  
				<form action="<%=request.getRequestURL()%>" name="forma">  
				Seconds remaining: <input type="text" name="clock" value="<%=clock%>" style="border:0px solid white">  
				</form>  
				<script>  
				<!--  
				timer();  
				//-->  
				</script>  
				Question: There was a green house. Inside the green house there was a white house. Inside the white house there was a red house. Inside the red house there were lots of babies. What is it?<br>  
				<form method="post" action='check.jsp'>
				Answer: <input type="text" name="answer">	 
				<input type="submit" name="ok" value="OK">   
				</form>
			
			</body>
			
			<%
		}
	} else {
		String query = "SELECT * FROM users WHERE uname = ?";
		PreparedStatement statement = connection.prepareStatement(query);
	   	statement.setString(1, uname);
		ResultSet rs;
		//System.out.println("uname="+uname+" pw="+pw);
		rs=statement.executeQuery();
		if(rs.next() && !isRobot){
			String storedhash = rs.getString("pw");
			String salt = rs.getString("salt");
			String type = rs.getString("type");
			boolean active = rs.getInt("active") == 1;
			//hashing
	        MessageDigest digest = MessageDigest.getInstance("SHA-256");
			digest.reset();
			digest.update(salt.getBytes("UTF-8"));
			String pwhash = new String(digest.digest(pw.getBytes("UTF-8")), "UTF-8");
			if(storedhash.equals(pwhash) && active) {
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
		}
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
			%>
			<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		        <link rel="stylesheet" type="text/css" href="lutstyle.css">
		     	<title>You must be a robot</title>
			</head>
			
			<body>
				<h1>You have failed login to many times</h1>
				<h3>If u fail to answer the question below before the timer runs out you will be redirected to a random page on the web</h3>
				<script>  
				<!--  
				<%  
				String clock = request.getParameter( "clock" );  
					if( clock == null ) clock = "10";  
				%>  
				var timeout = <%=clock%>;  
				function timer()  {  
					if( --timeout > 0 )  {  
						document.forma.clock.value = timeout;  
						window.setTimeout( "timer()", 1000 );  
					}  
					else  {  
						document.forma.clock.value = "Time over";
						window.location.href = "http://www.sometimesredsometimesblue.com/"; 
						///disable submit-button etc  
					}  
				}  
				//-->  
				</script>  
				<body>  
				<form action="<%=request.getRequestURL()%>" name="forma">  
				Seconds remaining: <input type="text" name="clock" value="<%=clock%>" style="border:0px solid white">  
				</form>  
				<script>  
				<!--  
				timer();  
				//-->  
				</script>  
				Question: There was a green house. Inside the green house there was a white house. Inside the white house there was a red house. Inside the red house there were lots of babies. What is it?<br>  
				<form method="post" action='check.jsp'>
				Answer: <input type="text" name="answer">	 
				<input type="submit" name="ok" value="OK">   
				</form>
			
			</body>
			
			<%
		}
	}
	%>
	</body>


</html>
