<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid mt-4 mb-4">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Liste des Ventes</h1>
        <a href="<c:url value='/ventes/nouvelle'/>" class="btn btn-primary">
            <i class="bi bi-plus-lg"></i> Nouvelle Vente
        </a>
    </div>

    <!-- Filtres -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-4">
                    <label for="dateDebut" class="form-label">Date début</label>
                    <input type="date" class="form-control" id="dateDebut" name="dateDebut"
                           value="${param.dateDebut}">
                </div>
                <div class="col-md-4">
                    <label for="dateFin" class="form-label">Date fin</label>
                    <input type="date" class="form-control" id="dateFin" name="dateFin"
                           value="${param.dateFin}">
                </div>
                <div class="col-md-4">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-search"></i> Filtrer
                    </button>
                    <a href="<c:url value='/ventes'/>" class="btn btn-secondary">
                        <i class="bi bi-x-circle"></i> Réinitialiser
                    </a>
                </div>
            </form>
        </div>
    </div>

    <!-- Liste des ventes -->
    <div class="card shadow">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>N° Vente</th>
                        <th>Date</th>
                        <th>Client</th>
                        <th>Montant</th>
                        <th>Vendeur</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${ventes}" var="vente">
                        <tr>
                            <td>${vente.id}</td>
                            <td>
                              ${vente.dateVenteFormatted}
                            </td>
                            <td>${vente.nomClient}</td>
                            <td>
                                <fmt:formatNumber value="${vente.montantTotal}" pattern="#,##0"/> FCFA
                            </td>
                            <td>${vente.utilisateurNomComplet}</td>
                            <td>
                                <div class="btn-group">
                                    <a href="<c:url value='/ventes/${vente.id}'/>"
                                       class="btn btn-sm btn-info" title="Détails">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="<c:url value='/tickets/${vente.id}'/>"
                                       class="btn btn-sm btn-secondary" title="Ticket">
                                        <i class="bi bi-receipt"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
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
</script>