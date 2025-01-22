<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid py-4 mb-4 mt-4">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
    <!-- En-tête du Dashboard -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Tableau de Bord</h1>
        <button class="btn btn-primary" onclick="refreshDashboard()">
            <i class="bi bi-arrow-clockwise"></i> Actualiser
        </button>
    </div>

    <!-- Cartes des statistiques (sur une même ligne) -->
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4 mb-4">
        <!-- Ventes du jour -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-start border-primary border-4 shadow h-100">
                <div class="card-body text-center">
                    <div class="icon-box bg-light-primary rounded-circle mx-auto mb-3">
                        <i class="bi bi-cart fs-2 text-primary"></i>
                    </div>
                    <div class="text-uppercase small text-muted">Ventes du jour</div>
                    <div class="display-6 fw-bold text-primary" id="ventesJourTotal">
                        <fmt:formatNumber value="${ventesJourTotal}" pattern="#,##0"/> FCFA
                    </div>
                </div>
            </div>
        </div>

        <!-- Livraisons du jour -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-start border-success border-4 shadow h-100">
                <div class="card-body text-center">
                    <div class="icon-box bg-light-success rounded-circle mx-auto mb-3">
                        <i class="bi bi-truck fs-2 text-success"></i>
                    </div>
                    <div class="text-uppercase small text-muted">Livraisons du jour</div>
                    <div class="display-6 fw-bold text-success" id="livraisonsJourTotal">
                        <fmt:formatNumber value="${livraisonsJourTotal}" pattern="#,##0"/> FCFA
                    </div>
                </div>
            </div>
        </div>

        <!-- Produits en alerte -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-start border-warning border-4 shadow h-100">
                <div class="card-body text-center">
                    <div class="icon-box bg-light-warning rounded-circle mx-auto mb-3">
                        <i class="bi bi-exclamation-triangle fs-2 text-warning"></i>
                    </div>
                    <div class="text-uppercase small text-muted">Produits en alerte</div>
                    <div class="display-6 fw-bold text-warning" id="nombreProduitsAlerte">
                        ${produitsAlerte.size()}
                    </div>
                </div>
            </div>
        </div>

        <!-- Total des produits -->
        <div class="col-md-6 col-lg-3">
            <div class="card border-start border-info border-4 shadow h-100">
                <div class="card-body text-center">
                    <div class="icon-box bg-light-info rounded-circle mx-auto mb-3">
                        <i class="bi bi-box fs-2 text-info"></i>
                    </div>
                    <div class="text-uppercase small text-muted">Total des produits</div>
                    <div class="display-6 fw-bold text-info">
                        ${totalProduits}
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Dernières opérations -->
    <div class="row gy-4">
        <!-- Dernières ventes -->
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Dernières ventes</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead>
                            <tr>
                                <th>Heure</th>
                                <th>Client</th>
                                <th>Montant</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${ventesJour}" var="vente">
                                <tr>
                                    <td>${vente.dateVenteFormatted}</td>
                                    <td>${vente.nomClient}</td>
                                    <td>
                                        <fmt:formatNumber value="${vente.montantTotal}" pattern="#,##0"/> FCFA
                                    </td>
                                    <td>
                                        <a href="<c:url value='/ventes/${vente.id}'/>"
                                           class="btn btn-sm btn-info">
                                            <i class="bi bi-eye"></i>
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
    </div>

    <!-- Graphiques et Produits en alerte -->
    <div class="row gy-4">

        <!-- Produits en alerte -->
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Produits en alerte de stock</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-sm">
                            <thead>
                            <tr>
                                <th>Produit</th>
                                <th>Stock</th>
                                <th>Seuil</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${produitsAlerte}" var="produit">
                                <tr>
                                    <td>${produit.nom}</td>
                                    <td><span class="badge bg-danger">${produit.quantiteStock}</span></td>
                                    <td>${produit.seuilAlerte}</td>
                                    <td>
                                        <a href="<c:url value='/livraisons/nouvelle?produitId=${produit.id}'/>"
                                           class="btn btn-sm btn-primary">
                                            <i class="bi bi-plus-circle"></i>
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
        <!-- Graphique des ventes -->
        <div class="col-12">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Évolution des ventes</h5>
                </div>
                <div class="card-body">
                    <canvas id="ventesChart"></canvas>
                </div>
            </div>
        </div>

    </div>
</div>





<!-- Scripts pour les graphiques -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Initialisation des graphiques
    document.addEventListener('DOMContentLoaded', function() {
        initVentesChart();
        setupRefreshTimer();
    });

    // Graphique des ventes
    function initVentesChart() {
        fetch('/dashboard/chart-data?type=ventes')
            .then(response => response.json())
            .then(data => {
                const ctx = document.getElementById('ventesChart').getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: data.labels,
                        datasets: [{
                            label: 'Ventes quotidiennes',
                            data: data.data,
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
    }

    // Rafraîchissement automatique
    function setupRefreshTimer() {
        setInterval(refreshDashboard, 300000); // 5 minutes
    }

    function refreshDashboard() {
        fetch('/dashboard/refresh-stats')
            .then(response => response.json())
            .then(data => {
                document.getElementById('ventesJourTotal').textContent =
                    new Intl.NumberFormat('fr-FR').format(data.ventesJourTotal) + ' FCFA';
                document.getElementById('livraisonsJourTotal').textContent =
                    new Intl.NumberFormat('fr-FR').format(data.livraisonsJourTotal) + ' FCFA';
                document.getElementById('nombreProduitsAlerte').textContent =
                    data.nombreProduitsAlerte;
            });
    }
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
