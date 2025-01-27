<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique - Produits</title>

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
    <c:import url="../layout/sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <c:import url="../layout/header.jsp"/>
<div class="container-fluid mt-3 mb-5">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Historique des Opérations</h1>
    </div>

    <!-- Filtres -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <form id="filterForm" class="row g-3">
                <div class="col-md-3">
                    <label class="form-label">Type</label>
                    <select class="form-select" name="type">
                        <option value="all">Tous</option>
                        <option value="ventes">Ventes</option>
                        <option value="livraisons">Livraisons</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Date début</label>
                    <input type="date" class="form-control" name="dateDebut">
                </div>
                <div class="col-md-3">
                    <label class="form-label">Date fin</label>
                    <input type="date" class="form-control" name="dateFin">
                </div>
                <div class="col-md-3">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Filtrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Tableau des opérations -->
    <div class="card shadow">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Référence</th>
                        <th>Client/Fournisseur</th>
                        <th>Montant</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="operation" items="${operations}">
                        <tr>
                            <td>${operation.dateFormatted}</td>
                            <td>
                                    <span class="badge ${operation.type == 'VENTE' ? 'bg-success' : 'bg-primary'}">
                                            ${operation.type}
                                    </span>
                            </td>
                            <td>${operation.reference}</td>
                            <td>${operation.nomPartenaire}</td>
                            <td class="text-end">
                                <fmt:formatNumber value="${operation.montant}" pattern="#,##0"/> FCFA
                            </td>
                            <td>
                                <div class="btn-group">

                                    <a href="<c:url value='/ventes/${operation.id}'/>"
                                       class="btn btn-sm btn-outline-primary" title="Détails">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <c:if test="${operation.type == 'VENTE'}">
                                        <a  href="<c:url value='/tickets/${operation.id}'/>"
                                           class="btn btn-sm btn-outline-success" title="Ticket">
                                            <i class="bi bi-receipt"></i>
                                        </a>
                                    </c:if>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Modal détails -->
    <div class="modal fade" id="detailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Détails de l'opération</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body" id="detailsContent">
                    <!-- Contenu chargé dynamiquement -->
                </div>
            </div>
        </div>
        <c:import url="../layout/footer.jsp"/>
    </div>
</div>
        <!-- Footer -->
        <c:import url="../layout/footer.jsp"/>
</div>

<script>
    // Auto-dismiss alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function () {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function (alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });

    document.addEventListener('DOMContentLoaded', function() {
        // Validation des dates
        const formFiltre = document.querySelector('form');
        formFiltre.addEventListener('submit', function(e) {
            const dateDebut = document.getElementById('dateDebut').value;
            const dateFin = document.getElementById('dateFin').value;

            if (dateDebut && dateFin) {
                if (dateDebut > dateFin) {
                    e.preventDefault();
                    alert('La date de début doit être antérieure à la date de fin');
                }
            }
        });
    });
</script>
        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="<c:url value='/resources/js/dashboard.css'/>"></script>
</body>
</html>