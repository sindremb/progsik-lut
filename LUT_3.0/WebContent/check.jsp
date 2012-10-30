<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%! 
public static String sanitize(String s) {
  
    s = s.replaceAll("(?i)<script.*?>.*?</script.*?>","");   // case 1 <script> are removed
    s = s.replaceAll("[\\\"\\\'][\\s]*((?i)javascript):(.*)[\\\"\\\']",""); // case 2 javascript: call are removed
    s = s.replaceAll("(?i)<.*?\\s+on.*?>.*?</.*?>","");     // case 3 remove on* attributes like onLoad or onClick
    s = s.replaceAll("[<>{}\\[\\];\\&]",""); // case 4 remove malicous chars. May be overkill...
    s = s.replaceAll("eval\\((.*)\\)", ""); // case 5 removes eval () calls
    // s = s.replaceAll("j", ""); test
    return s;
}
%>

<% // not able to get here  with GET. avoid null pointer exception if users try to refresh check.jsp when failing to login
if ("Get".equalsIgnoreCase(request.getMethod())) {
	response.sendRedirect("login.jsp");
	return;
}

%>

<%
String answer = "";
answer = request.getParameter("answer");
sanitize(answer);
if (answer.equals("A watermelon")) {
	response.sendRedirect("login.jsp");
}

else {
	%>
	<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
		<html>
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<link rel="stylesheet" type="text/css" href="lutstyle.css">
		<title>Was this the correct answer? Nooooooo</title>
		</head>
		<body>
	
        <h3>Seriously is your answer <strong>"<%= answer %>"</strong> ?</h3>
        <br>
        <br>
        You have failed your last attempt. Now you will be redirected to a random page on the web!
        
        <script>  
					<!--  
					<%  
					String clock = request.getParameter( "clock" );  
						if( clock == null ) clock = "10000";  
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
					
					
			</body>
				
				<%
			
	}
	%>
	


</html>
			
