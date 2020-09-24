<%--
  Created by IntelliJ IDEA.
  User: fogmr
  Date: 23.09.2020
  Time: 13:53
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MovieLand</title>
    <style>
        a {
            text-decoration: #009900;
        }
    </style>
</head>

<body>
<h1>Hello, It is main page!</h1>
<h3><a href="${pageContext.request.contextPath}/another">To another page!</a></h3>
<h3><a href="${pageContext.request.contextPath}/jsp/test.jsp">To JDBC test page!</a></h3>
</body>
</html>
