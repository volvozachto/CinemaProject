<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<sql:query var="rs" dataSource="jdbc/TestDB">
    SELECT films.name, DATE_FORMAT(screening_time, '%H:%i %e/%c/%Y') as screening_time FROM screenings JOIN films WHERE screenings.id_film = films.id
</sql:query>
<html>
<head>
    <%@ page language="java" contentType="text/html;charset=utf-8"%>

    <title>DB Test</title>
</head>
<style>
    a {
        text-decoration: lightsteelblue;
    }
</style>
<body>

<h2>Results</h2>
<h4>Films              Time</h4>

<c:forEach var="row" items="${rs.rows}">
    <p>${row.name} ${row.screening_time}<br/></p>
</c:forEach>

<h3><a href="${pageContext.request.contextPath}/">Back to the main page</a></h3>
</body>
</html>