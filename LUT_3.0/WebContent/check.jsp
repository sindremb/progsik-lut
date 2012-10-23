<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Was this the correct answer? Nooooooo</title>
</head>
<body>


<%
String answer = "";
answer = request.getParameter("answer");

if (answer.equals("A watermelon")) {
	response.sendRedirect("login.jsp");
}

else {
	%>
	<html>
	<head>
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<link rel="stylesheet" type="text/css" href="lutstyle.css">
			 <title>Seriously?</title>
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
					
					
			</body>
				
				<%
			
	}
	%>
	</body>


</html>
			
