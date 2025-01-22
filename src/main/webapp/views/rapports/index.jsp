
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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

<div class="container-fluid mt-3">
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Rapports et Statistiques</h1>
        <div class="btn-group ">
            <button type="button" class="btn btn-primary " onclick="genererRapport()">
                <i class="bi bi-file-earmark-pdf"></i> Générer Rapport
            </button>
            <button type="button" class="btn btn-success" onclick="exporterExcel()">
                <i class="bi bi-file-earmark-excel"></i> Exporter Excel
            </button>
        </div>
    </div>

    <!-- Filtres de période -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <form id="filterForm" class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Période</label>
                    <select class="form-select" id="periodeSelect" name="periode" onchange="updatePeriode()">
                        <option value="jour">Aujourd'hui</option>
                        <option value="semaine">Cette semaine</option>
                        <option value="mois">Ce mois</option>
                        <option value="personnalise">Personnalisé</option>
                    </select>
                </div>
                <div class="col-md-3 periode-personnalisee d-none">
                    <label class="form-label">Date début</label>
                    <input type="date" class="form-control" id="dateDebut" name="dateDebut">
                </div>
                <div class="col-md-3 periode-personnalisee d-none">
                    <label class="form-label">Date fin</label>
                    <input type="date" class="form-control" id="dateFin" name="dateFin">
                </div>
                <div class="col-md-2">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search"></i> Filtrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Statistiques générales -->
    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Chiffre d'affaires
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                <fmt:formatNumber value="${stats.chiffreAffaires}" pattern="#,##0"/> FCFA
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-cash h1 text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-success shadow h-100 py-2">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                Nombre de ventes
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                ${stats.nombreVentes}
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-cart h1 text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-info shadow h-100 py-2">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                Valeur du stock
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                <fmt:formatNumber value="${stats.valeurStock}" pattern="#,##0"/> FCFA
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-box h1 text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-warning shadow h-100 py-2">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                Bénéfice estimé
                            </div>
                            <div class="h5 mb-0 font-weight-bold">
                                <fmt:formatNumber value="${stats.benefice}" pattern="#,##0"/> FCFA
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-graph-up h1 text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Graphiques -->
    <div class="row">
        <!-- Évolution des ventes -->
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3 d-flex justify-content-between align-items-center">
                    <h6 class="m-0 font-weight-bold text-primary">Évolution des ventes</h6>
                    <select class="form-select form-select-sm" style="width: auto;"
                            onchange="updateVentesChart(this.value)">
                        <option value="jour">Par jour</option>
                        <option value="semaine">Par semaine</option>
                        <option value="mois">Par mois</option>
                    </select>
                </div>
                <div class="card-body">
                    <canvas id="ventesChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Top produits -->
        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Top 5 des produits vendus</h6>
                </div>
                <div class="card-body">
                    <canvas id="topProduitsChart"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Initialisation des graphiques
    let ventesChart;
    let topProduitsChart;

    document.addEventListener('DOMContentLoaded', function() {
        initCharts();
        setupEventListeners();
        updatePeriode()
        chargerDonnees();


    });
    function updatePeriode() {
        const periodeSelect = document.getElementById('periodeSelect');
        const personnalise = periodeSelect.value === 'personnalise';
        document.querySelectorAll('.periode-personnalisee').forEach(el => {
            el.classList.toggle('d-none', !personnalise);
        });

        if (!personnalise) {
            const today = new Date();
            document.getElementById('dateDebut').value = today.toISOString().split('T')[0];
            document.getElementById('dateFin').value = today.toISOString().split('T')[0];
        }
    }



    function initCharts() {
        // Graphique des ventes
        const ventesCtx = document.getElementById('ventesChart').getContext('2d');
        ventesChart = new Chart(ventesCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Montant des ventes',
                    data: [],
                    borderColor: 'rgb(75, 192, 192)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + ' FCFA';
                            }
                        }
                    }
                }
            }
        });

        const topProduitsCtx = document.getElementById('topProduitsChart').getContext('2d');
        topProduitsChart = new Chart(topProduitsCtx, {
            type: 'doughnut',
            data: {
                labels: [],
                datasets: [{
                    data: [],
                    backgroundColor: [
                        '#4e73df',
                        '#1cc88a',
                        '#36b9cc',
                        '#f6c23e',
                        '#e74a3b'
                    ],
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            boxWidth: 12
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed;
                                return `${label}: ${value} unités`;
                            }
                        }
                    }
                }
            }
        });
    }

    function setupEventListeners() {
        document.getElementById('periodeSelect').addEventListener('change', function() {
            const personnalise = this.value === 'personnalise';
            document.querySelectorAll('.periode-personnalisee').forEach(el => {
                el.classList.toggle('d-none', !personnalise);
            });
        });

        document.getElementById('filterForm').addEventListener('submit', function(e) {
            e.preventDefault();
            chargerDonnees();

        });
    }

    function updateCharts(data) {
        // Mise à jour du graphique des ventes
        if (data.ventes) {
            ventesChart.data.labels = data.ventes.labels;
            ventesChart.data.datasets[0].data = data.ventes.donnees;
            ventesChart.update();
        }

        // Mise à jour du graphique des top produits
        if (data.topProduits) {
            console.log('Top Produits data:', data.topProduits); // Pour déboguer
            topProduitsChart.data.labels = data.topProduits.labels;
            topProduitsChart.data.datasets[0].data = data.topProduits.donnees;
            topProduitsChart.update();
        }
    }

    function initCharts() {
        // Graphique des ventes
        const ventesCtx = document.getElementById('ventesChart').getContext('2d');
        ventesChart = new Chart(ventesCtx, {
            type: 'line',
            data: {
                labels: [],
                datasets: [{
                    label: 'Montant des ventes',
                    data: [],
                    borderColor: 'rgb(75, 192, 192)',
                    tension: 0.1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return value.toLocaleString() + ' FCFA';
                            }
                        }
                    }
                }
            }
        });


        // Graphique des top produits
        const topProduitsCtx = document.getElementById('topProduitsChart').getContext('2d');
        topProduitsChart = new Chart(topProduitsCtx, {
            type: 'doughnut',
            data: {
                labels: [],
                datasets: [{
                    data: [],
                    backgroundColor: [
                        '#4e73df',
                        '#1cc88a',
                        '#36b9cc',
                        '#f6c23e',
                        '#e74a3b'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom'
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let label = context.label || '';
                                let value = context.parsed || 0;
                                return `${label}: ${value} unités vendues`;
                            }
                        }
                    }
                }
            }
        });
    }

    // Ajoutez une fonction pour charger les données initiales
    document.addEventListener('DOMContentLoaded', function() {
        initCharts();
        setupEventListeners();
        // Charger les données initiales
        chargerDonnees();
    });


    function genererRapport() {
        const params = new URLSearchParams(new FormData(document.getElementById('filterForm')));
        window.location.href = '<c:url value="/rapports/pdf"/>' + '?' + params.toString();
    }

    function exporterExcel() {
        const params = new URLSearchParams(new FormData(document.getElementById('filterForm')));
        window.location.href = '<c:url value="/rapports/excel"/>' + '?' + params.toString();
    }

    function updateVentesChart(periode) {
        fetch('<c:url value="/rapports/ventes"/>' + '?periode=' + periode)
            .then(response => response.json())
            .then(data => {
                ventesChart.data.labels = data.labels;
                ventesChart.data.datasets[0].data = data.donnees;
                ventesChart.update();
            });
    }

    function chargerDonnees() {
        const params = new URLSearchParams();
        const periodeSelect = document.getElementById('periodeSelect');
        params.append('periode', periodeSelect.value);

        if (periodeSelect.value === 'personnalise') {
            params.append('dateDebut', document.getElementById('dateDebut').value);
            params.append('dateFin', document.getElementById('dateFin').value);
        }

        fetch('<c:url value="/rapports/data"/>' + '?' + params.toString())
            .then(response => response.json())
            .then(data => {
                // Mettre à jour les statistiques
                updateStats(data.stats);
                // Mettre à jour les graphiques
                updateCharts(data);
            });
    }

    function updateStats(stats) {
        document.querySelector('[data-stat="chiffreAffaires"]').textContent =
            new Intl.NumberFormat('fr-FR').format(stats.chiffreAffaires) + ' FCFA';
        document.querySelector('[data-stat="nombreVentes"]').textContent =
            stats.nombreVentes;
        document.querySelector('[data-stat="valeurStock"]').textContent =
            new Intl.NumberFormat('fr-FR').format(stats.valeurStock) + ' FCFA';
        document.querySelector('[data-stat="benefice"]').textContent =
            new Intl.NumberFormat('fr-FR').format(stats.benefice) + ' FCFA';
    }
</script>
<!-- Footer -->
<div class=" "><c:import url="../layout/footer.jsp"/></div>
</div>
</div>
</body>
</html>

