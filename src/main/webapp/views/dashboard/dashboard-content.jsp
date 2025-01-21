<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container-fluid  align-items-center justify-content-between w-100 py-4  ">
    <!-- En-tête du Dashboard -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Tableau de Bord</h1>
        <div>
            <button class="btn btn-primary" onclick="refreshDashboard()">
                <i class="bi bi-arrow-clockwise"></i> Actualiser
            </button>
        </div>
    </div>

    <!-- Cartes des statistiques -->
    <div class="row gap-2 mb-4">
        <!-- Ventes du jour -->
        <div class="col-xl-3 col-md-6">
            <div class="card border-start stats-card border-primary border-4 shadow h-100">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <div class="text-uppercase mb-1 text-muted">Ventes du jour</div>

                            <div class="h4 mb-0" id="ventesJourTotal">
                                <fmt:formatNumber value="${ventesJourTotal}" pattern="#,##0"/> FCFA
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-cart fs-1 text-primary"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Livraisons du jour -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-start border-success border-4 shadow h-100">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <div class="text-uppercase mb-1 text-muted">Livraisons du jour</div>
                            <div class="h4 mb-0" id="livraisonsJourTotal">
                                <fmt:formatNumber value="${livraisonsJourTotal}" pattern="#,##0"/> FCFA
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-truck fs-1 text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Produits en alerte -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-start border-warning border-4 shadow h-100">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <div class="text-uppercase mb-1 text-muted">Produits en alerte</div>
                            <div class="h4 mb-0" id="nombreProduitsAlerte">
                                ${produitsAlerte.size()}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-exclamation-triangle fs-1 text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Total des produits -->
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-start border-info border-4 shadow h-100">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col">
                            <div class="text-uppercase mb-1 text-muted">Total des produits</div>
                            <div class="h4 mb-0">
                                ${totalProduits}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-box fs-1 text-info"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques et Tableaux -->
    <div class="row">
        <!-- Graphique des ventes -->
        <div class="col-xl-8">
            <div class="card shadow mb-4">
                <div class="card-header">
                    <h5 class="mb-0">Évolution des ventes</h5>
                </div>
                <div class="card-body">
                    <canvas id="ventesChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Produits en alerte -->
        <div class="col-xl-4">
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
                                    <td>
                                        <span class="badge bg-danger">${produit.quantiteStock}</span>
                                    </td>
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
    </div>

    <!-- Dernières opérations -->
    <div class="row">
        <!-- Dernières ventes -->
        <div class="col-xl-6">
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
                                    <td>
                                        <fmt:formatDate value="${vente.dateVente}" pattern="HH:mm"/>
                                    </td>
                                    <td>${vente.client}</td>
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
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
