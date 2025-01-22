<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique - Ventes</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">
</head>
<body>
<div class="dashboard-container mt-4 mb-5">
    <!-- Sidebar -->
    <c:import url="../layout/sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <c:import url="../layout/header.jsp"/>

<div class="container-fluid">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Alertes Stock</h1>
        <div class="btn-group">
            <button type="button" class="btn btn-warning" onclick="markAllAsRead()">
                <i class="bi bi-check-all"></i> Marquer tout comme lu
            </button>
        </div>
    </div>

    <!-- Liste des alertes -->
    <div class="card shadow">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Stock Actuel</th>
                        <th>Seuil d'Alerte</th>
                        <th>Statut</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="alerte" items="${alertes}">
                        <tr>
                            <td>${alerte.nom}</td>
                            <td class="text-center">
                                    <span class="badge bg-${alerte.quantiteStock == 0 ? 'danger' : 'warning'}">
                                            ${alerte.quantiteStock}
                                    </span>
                            </td>
                            <td class="text-center">${alerte.seuilAlerte}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${alerte.quantiteStock == 0}">
                                        <span class="badge bg-danger">Rupture de stock</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-warning">Stock faible</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="<c:url value='/livraisons/nouvelle?produit=${alerte.produitId}'/>"
                                   class="btn btn-sm btn-success">
                                    <i class="bi bi-plus-circle"></i> Commander
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<!-- Footer -->
<c:import url="../layout/footer.jsp"/>
</div>
</div>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-dismiss alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>
</body>