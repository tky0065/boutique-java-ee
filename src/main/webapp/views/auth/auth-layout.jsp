<%--
  Created by IntelliJ IDEA.
  User: EnokDev
  Date: 20/01/2025
  Time: 14:34
  To change this template use File | Settings | File Templates.
--%>



<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestion Boutique -  ${pageTitle}</title>
<%--  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
    <link href="<c:url value='/resources/css/bootstrap.min.css'/>" rel="stylesheet">

</head>
<body>

<div class="container mt-4">
  <jsp:include page="${page}"/>

</div>

<!-- Scripts -->
<script src="<c:url value='/resources/js/popper.min.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>