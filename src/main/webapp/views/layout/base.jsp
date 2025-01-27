<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique - ${param.title}</title>

    <!-- Bootstrap CSS -->
    <link href="<c:url value='/resources/css/bootstrap.min.css'/>" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="<c:url value='/resources/css/bootstrap-icons.css'/>" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">
    <script src="<c:url value='/resources/js/chart.js'/>"></script>

</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <jsp:include page="sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <jsp:include page="header.jsp"/>

        <!-- Main Content Area -->
        <div class="content-wrapper">
            <jsp:include page="views/${content}.jsp"/>
        </div>

        <!-- Footer -->
        <jsp:include page="footer.jsp"/>
    </div>
</div>

<!-- Bouton retour en haut -->
<button id="scrollToTop" class="btn btn-primary rounded-circle position-fixed"
        style="bottom: 20px; right: 20px; display: none;"
        title="Retour en haut">
    <i class="bi bi-arrow-up"></i>
</button>

<!-- Conteneur pour les notifications -->
<div class="notifications-container position-fixed"
     style="top: 20px; right: 20px; z-index: 1050;"></div>
<!-- Scripts -->
<script src="<c:url value='/resources/js/popper.min.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>