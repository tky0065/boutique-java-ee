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
    <link href="<c:url value='/resources/css/bootstrap.min.css'/>" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="<c:url value='/resources/css/bootstrap-icons.css'/>" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">
    <%--     Chart js--%>
    <script src="<c:url value='/resources/js/chart.js'/>"></script>
</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <c:import url="../layout/sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <c:import url="../layout/header.jsp"/>

        <div class="container-fluid mt-4 mb-4">
            <!-- Messages flash -->
            <c:import url="../fragments/messages.jsp"/>
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
                    <form id="filterForm" action="${pageContext.request.contextPath}/rapports" method="get" class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label">Période</label>
                            <select class="form-select" id="periodeSelect" name="periode">
                                <option value="jour" ${periode == 'jour' ? 'selected' : ''}>Aujourd'hui</option>
                                <option value="semaine" ${periode == 'semaine' ? 'selected' : ''}>Cette semaine</option>
                                <option value="mois" ${periode == 'mois' ? 'selected' : ''}>Ce mois</option>
                                <option value="personnalise" ${periode == 'personnalise' ? 'selected' : ''}>
                                    Personnalisé
                                </option>
                            </select>
                        </div>
                        <div class="col-md-3 periode-personnalisee ${periode != 'personnalise' ? 'd-none' : ''}">
                            <label class="form-label">Date début</label>
                            <input type="date" class="form-control" id="dateDebut" name="dateDebut"
                                   value="${dateDebut}">
                        </div>
                        <div class="col-md-3 periode-personnalisee ${periode != 'personnalise' ? 'd-none' : ''}">
                            <label class="form-label">Date fin</label>
                            <input type="date" class="form-control" id="dateFin" name="dateFin" value="${dateFin}">
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
                                    <div class="h5 mb-0 font-weight-bold" data-stat="chiffreAffaires">
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
                                    <div class="h5 mb-0 font-weight-bold" data-stat="nombreVentes">
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
                                    <div class="h5 mb-0 font-weight-bold" data-stat="valeurStock">
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
                                    <div class="h5 mb-0 font-weight-bold" data-stat="benefice">
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
                        <div class="card-header py-3">
                            <h6 class="m-0 font-weight-bold text-primary">Évolution des ventes</h6>
                        </div>
                        <div class="card-body">
                            <div style="height: 400px;">
                                <canvas id="ventesChart"></canvas>
                            </div>
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
                            <div style="height: 400px;">
                                <canvas id="topProduitsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div
                <!-- Footer -->
        <c:import url="../layout/footer.jsp"/>


    </div>
</div>
<c:set var="ventesDataJson" value="${ventesDataJson}" scope="request"/>
<c:set var="topProduitsDataJson" value="${topProduitsDataJson}" scope="request"/>
<c:set var="statsJson" value="${statsJson}" scope="request"/>
<script>
    // Variables globales pour les graphiques
    let ventesChart;
    let topProduitsChart;

    // Données des graphiques reçues du serveur (avec une vérification)
    const ventesData = ${not empty ventesDataJson ? ventesDataJson : '{labels:[],donnees:[]}'};
    const topProduitsData = ${not empty topProduitsDataJson ? topProduitsDataJson : '{labels:[],donnees:[]}'};
    const initialStats = ${not empty statsJson ? statsJson : '{}'};
    // Fonction d'initialisation des graphiques
    function initCharts() {
        // Graphique des ventes
        const ventesCtx = document.getElementById('ventesChart').getContext('2d');
        ventesChart = new Chart(ventesCtx, {
            type: 'line',
            data: {
                labels: ventesData.labels,
                datasets: [{
                    label: 'Montant des ventes',
                    data: ventesData.donnees,
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    tension: 0.1,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: {
                        position: 'top'
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                return context.parsed.y.toLocaleString('fr-FR') + ' FCFA';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function (value) {
                                return value.toLocaleString('fr-FR') + ' FCFA';
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
                labels: topProduitsData.labels,
                datasets: [{
                    data: topProduitsData.donnees,
                    backgroundColor: [
                        '#4e73df',
                        '#1cc88a',
                        '#36b9cc',
                        '#f6c23e',
                        '#e74a3b'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            boxWidth: 12
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
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

    // Gestion de la période personnalisée
    function updatePeriode() {
        const periodeSelect = document.getElementById('periodeSelect');
        const personnalise = periodeSelect.value === 'personnalise';
        document.querySelectorAll('.periode-personnalisee').forEach(el => {
            el.classList.toggle('d-none', !personnalise);
        });

        if (!personnalise) {
            const today = new Date();
            const formattedDate = today.toISOString().split('T')[0];
            document.getElementById('dateDebut').value = formattedDate;
            document.getElementById('dateFin').value = formattedDate;
        }
    }

    // Configuration des écouteurs d'événements
    function setupEventListeners() {
        const periodeSelect = document.getElementById('periodeSelect');
        const filterForm = document.getElementById('filterForm');

        periodeSelect.addEventListener('change', updatePeriode);

        // Gestionnaire pour les boutons d'export
        document.getElementById('btnPDF').addEventListener('click', genererRapport);
        document.getElementById('btnExcel').addEventListener('click', exporterExcel);
    }

    // Fonction pour générer le rapport PDF
    function genererRapport() {
        const form = document.getElementById('filterForm');
        const originalAction = form.action;
        form.action = '${pageContext.request.contextPath}/rapports/pdf';
        form.submit();
        form.action = originalAction; // Restaurer l'action originale
    }

    // Fonction pour exporter en Excel
    function exporterExcel() {
        const form = document.getElementById('filterForm');
        const originalAction = form.action;
        form.action = '${pageContext.request.contextPath}/rapports/excel';
        form.submit();
        form.action = originalAction; // Restaurer l'action originale
    }

    // Mise à jour des statistiques dans l'interface
    function updateStats(stats) {
        const formatter = new Intl.NumberFormat('fr-FR');

        document.querySelector('[data-stat="chiffreAffaires"]').textContent =
            `${formatter.format(stats.chiffreAffaires)} FCFA`;
        document.querySelector('[data-stat="nombreVentes"]').textContent =
            stats.nombreVentes;
        document.querySelector('[data-stat="valeurStock"]').textContent =
            `${formatter.format(stats.valeurStock)} FCFA`;
        document.querySelector('[data-stat="benefice"]').textContent =
            `${formatter.format(stats.benefice)} FCFA`;
    }

    // Auto-dismiss des alertes
    function setupAlerts() {
        setTimeout(function () {
            document.querySelectorAll('.alert').forEach(function (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    }

    // Initialisation au chargement de la page
    document.addEventListener('DOMContentLoaded', function () {
        initCharts();
        setupEventListeners();
        updatePeriode();
        setupAlerts();

        // Mise à jour initiale des stats si disponibles
        if (typeof initialStats !== 'undefined') {
            updateStats(initialStats);
        }
    });
</script>
</body>
</html>

