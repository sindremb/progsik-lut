<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<sql:query var="country" dataSource="jdbc/lut2">
    SELECT full_name FROM country
</sql:query>


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
        <form action='register.jsp'>
	        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Personal information</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>First Name</td><td><input type='text' name='fname' /></td>
	                </tr>
	                <tr>
	                    <td>Last Name</td><td><input type='text' name='lname' /></td>
	                </tr>
	                <tr>
	                    <td>Email</td><td><input type='text' name='email' /></td>
	                </tr>
	            </tbody>
	        </table>
			        <table border="0">
	            <thead>
	                <tr>
	                    <th colspan='2'>Login information</th>
	                </tr>
	            </thead>
	            <tbody>
	                <tr>
	                    <td>Username</td><td><input type='text' name='uname' /></td>
	                </tr>
	                <tr>
	                    <td>Passoword</td><td><input type='password' name='pwd' /></td>
	                </tr>
	                <tr>
	                    <td>Confirm password</td><td><input type='password' name='pwdconfirm' /></td>
	                </tr>
	            </tbody>
	        </table>
    	</form>
    </body>
</html>
