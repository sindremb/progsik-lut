
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- 
<sql:query var="users" dataSource="jdbc/lut2">
    SELECT * FROM users
    WHERE  uname = ? <sql:param value="${param.username}" /> 
    AND pw = ${param.password}
</sql:query>

<c:set var="userDetails" value="${users.rows[0]}"/>
--%>

<html>
	<head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Login</title>
    </head>
    
    <body>
    	<h1>Welcome to Lut</h1>
    	If you do not have a user, you can <a href="register.jsp">register here.</a><br /><br />
    	If you have forgotten you password, you can <a href="requestreset.jsp">request a password reset.</a><br /><br />
    		<form method="post" action='doLogin.jsp'>
    			<table border="0">
					<thead>
				    	<tr>
				    		<td>Log in here with your username and password</td>
				    	</tr>
				  	</thead>
				  	<tbody>
				  		<tr>
	                    	<td>Username</td><td><input type='text' name='uname' size='25' /></td>
	                	</tr>
	                	<tr>
	                    	<td>Password</td><td><input type='password' name='pw' size='25' /></td>
	                	</tr>
	                	<tr> 
	                		<td align="center" colspan="2">
	                			<img src="mcap.jsp"><br><br>
								<input type="button" value="Refresh Image" onClick="window.location.href=window.location.href">
							</td>
						</tr>
						<tr>
	                		<td align="center" colspan='2'> Please enter the answer for above calculation.<br /><br />
	                		<input name="number" type="text"><br /><br />
							</td>
						</tr>
				  	</tbody>
				</table>
				<p><input type="submit" value="Login" name="login"></p>
				
    		</form>	
    	
    	</body>


</html>

