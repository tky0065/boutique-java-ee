
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique - Produits</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">

</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <c:import url="../layout/sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <c:import url="../layout/header.jsp"/>

        <!-- Main Content Area -->
        <div class="content-wrapper">
<div class="container mt-5">
    <div class="card shadow">
        <div class="card-body text-center">
            <i class="bi bi-shield-exclamation text-danger" style="font-size: 4rem;"></i>
            <h2 class="mt-3">Accès Refusé</h2>
            <p class="text-muted">
                Vous n'avez pas les permissions nécessaires pour accéder à cette ressource.
            </p>
            <a href="<c:url value='/dashboard'/>" class="btn btn-primary">
                <i class="bi bi-house"></i> Retour au tableau de bord
            </a>
        </div>
    </div>
</div>
<!-- Footer -->
<c:import url="../layout/footer.jsp"/>
</div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>