<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Connection"%>
<%@page import="javax.sql.DataSource"%>
<%@page import="javax.naming.InitialContext"%>

<% String uname="",pw=""; %>
<% 
	InitialContext ctx = new InitialContext();
	DataSource ds = (DataSource) ctx.lookup("jdbc/lut2");
	Connection connection = ds.getConnection();
	
	if (connection == null)
    {
        throw new SQLException("Error establishing connection!");
    }

	uname=request.getParameter("uname");
	pw=request.getParameter("pw");
	String query = "SELECT * FROM users WHERE uname = ? AND pw = ?";
	PreparedStatement statement = connection.prepareStatement(query);
	statement.setString(1, uname);
	statement.setString(2,pw);
    
	ResultSet rs = statement.executeQuery();
		if(rs.next())
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
		else
			{
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
	%>
	</body>


</html>
