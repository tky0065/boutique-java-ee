<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="container-fluid mb-4">
    <c:import url="../fragments/messages.jsp"/>
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Détails du Produit</h1>
        <div class="btn-group">
            <a href="<c:url value='/produits/${produit.id}'/>" class="btn btn-warning">
                <i class="bi bi-pencil"></i> Modifier
            </a>
            <a href="<c:url value='/produits/liste'/>" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Retour
            </a>
        </div>
    </div>

    <div class="row">
        <!-- Informations du produit -->
        <div class="col-md-6 mb-4">
            <div class="card shadow h-100">
                <div class="card-header">
                    <h5 class="mb-0">Informations générales</h5>
                </div>
                <div class="card-body">
                    <table class="table">
                        <tr>
                            <th style="width: 30%">Nom :</th>
                            <td>${produit.nom}</td>
                        </tr>
                        <tr>
                            <th>Description :</th>
                            <td>${produit.description}</td>
                        </tr>
                        <tr>
                            <th>Prix unitaire :</th>
                            <td>
                                <fmt:formatNumber value="${produit.prixUnitaire}" pattern="#,##0"/> FCFA
                            </td>
                        </tr>
                        <tr>
                            <th>Quantité en stock :</th>
                            <td>
                                <span class="badge ${produit.quantiteStock <= produit.seuilAlerte ? 'bg-danger' : 'bg-success'} fs-6">
                                    ${produit.quantiteStock}
                                </span>
                            </td>
                        </tr>
                        <tr>
                            <th>Seuil d'alerte :</th>
                            <td>${produit.seuilAlerte}</td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <!-- Historique des mouvements -->
        <div class="col-md-6 mb-4">
            <div class="card shadow h-100">
                <div class="card-header">
                    <ul class="nav nav-tabs card-header-tabs" role="tablist">
                        <li class="nav-item">
                            <a class="nav-link active" data-bs-toggle="tab" href="#ventes" role="tab">
                                Ventes
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" data-bs-toggle="tab" href="#livraisons" role="tab">
                                Livraisons
                            </a>
                        </li>
                    </ul>
                </div>
                <div class="card-body">
                    <div class="tab-content">
                        <!-- Historique des ventes -->
                        <div class="tab-pane fade show active" id="ventes">
                            <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                <table class="table table-sm">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Quantité</th>
                                        <th>Prix</th>
                                        <th>Total</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${ventesRecentes}" var="vente">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${vente.dateVente}"
                                                                pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>${vente.quantite}</td>
                                            <td>
                                                <fmt:formatNumber value="${vente.prixUnitaire}"
                                                                  pattern="#,##0"/> FCFA
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${vente.montantTotal}"
                                                                  pattern="#,##0"/> FCFA
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <!-- Historique des livraisons -->
                        <div class="tab-pane fade" id="livraisons">
                            <div class="table-responsive" style="max-height: 400px; overflow-y: auto;">
                                <table class="table table-sm">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Fournisseur</th>
                                        <th>Quantité</th>
                                        <th>Prix</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach items="${livraisonsRecentes}" var="livraison">
                                        <tr>
                                            <td>
                                                <fmt:formatDate value="${livraison.dateLivraison}"
                                                                pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                            <td>${livraison.nomFournisseur}</td>
                                            <td>${livraison.quantite}</td>
                                            <td>
                                                <fmt:formatNumber value="${livraison.prixUnitaire}"
                                                                  pattern="#,##0"/> FCFA
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphique d'évolution du stock -->
    <div class="row">
        <div class="col-12">
            <div class="card shadow">
                <div class="card-header">
                    <h5 class="mb-0">Évolution du stock</h5>
                </div>
                <div class="card-body">
                    <canvas id="stockChart" height="300"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Initialiser le graphique d'évolution du stock
        const ctx = document.getElementById('stockChart').getContext('2d');
        new Chart(ctx, {
            type: 'line',
            data: {
                labels: ${stockDates},
                datasets: [{
                    label: 'Niveau de stock',
                    data: ${stockNiveaux},
                    borderColor: 'rgb(75, 192, 192)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
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