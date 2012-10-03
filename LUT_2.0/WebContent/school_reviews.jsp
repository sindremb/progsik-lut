<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<sql:query var="reviews" dataSource="jdbc/lut2">
    SELECT * FROM user_reviews, school
    WHERE user_reviews.school_id = school.school_id
    AND school.full_name = ? <sql:param value="${param.school_fullname}"/>
</sql:query>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="lutstyle.css">
        <title>Reviews for ${param.school_fullname}</title>
    </head>
    <body>
        <h1>Reviews for ${param.school_shortname}</h1>

        <!-- looping through all available reviews - if there are any -->
        <c:set var="review" value="${reviews.rows[0]}"/>
        <c:choose>
            <c:when test="${ empty review }">
                No reviews for ${param.school_fullname} yet. Help us out by adding one! 
                <br><br>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews.rowsByIndex}">
                    <c:out value="${review[2]}" /><br>
                    <i>${review[1]}</i>
                    <br><br>
                </c:forEach>
            </c:otherwise>
        </c:choose>



        <table border="0">
            <thead>
                <tr>
                    <th colspan="2">Help improving LUT2.0 by adding a review of ${param.school_shortname}</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>
                        <form action="add_review.jsp"  method="post">
                            <input type="hidden" name="school_id" value="${param.school_id}" />
                            <textarea name="review" rows=10 cols=60 wrap="physical" autofocus="on" > 
                            </textarea>
                            <br><br>
                            Your name: <input type="text" name="name" />
                            <br><br>
                            <input type="submit" value="Add review" />
                    </td>
                </tr>
            </tbody>
        </table>

    </body>
</html>
