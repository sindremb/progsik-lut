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
	String query = "SELECT * FROM users WHERE uname='"+uname+"' AND pw='"+pw+"' ";
	PreparedStatement statement = connection.prepareStatement(query);
    
	ResultSet rs;

	//System.out.println("uname="+uname+" pw="+pw);
	rs=statement.executeQuery(query);
		if(rs.next())
			{
				String type = rs.getString("type");
				if ("0".equals(type)) {
					session.setAttribute("uname",uname);
					connection.close();
					response.sendRedirect("lutadmin.jsp");
				} else if ("2".equals(type)) {
					session.setAttribute("uname",uname);
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
