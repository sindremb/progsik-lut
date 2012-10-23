
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
	                	<tr> <td align="center" colspan="2"><img src="mcap.jsp"><br><br>
						<input type="button" value="Refresh Image" onClick="window.location.href=window.location.href"></td></tr>
	                	<td align="center"> Please enter the answer for above calculation.</td><tr>
						<td align="center"><input name="number" type="text"></td></tr><tr>
						<td align="center"></td></tr>
						
				  	</tbody>
				</table>
				<p><input type="submit" value="login" name="login"></p>
				
    		</form>	
    	
    	</body>


</html>

<%-- 

<sql:query var="users" dataSource="jdbc/lut2">
    SELECT * FROM admin_users
    WHERE  uname = ? <sql:param value="${param.username}" /> 
    AND pw = ${param.password}
</sql:query>

    
    
<c:set var="userDetails" value="${users.rows[0]}"/>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>LUT Admin pages</title>
    </head>
    <body>
        <c:choose>
            <c:when test="${ empty userDetails }">
                Login failed
            </c:when>
            <c:otherwise>
                <h1>Login succeeded</h1> 
                Welcome ${ userDetails.uname}.<br> 
                Unfortunately, there is no admin functionality here. <br>
                You need to figure out how to tamper with the application some other way.
            </c:otherwise>
        </c:choose>
        </body>
    </html>
--%>