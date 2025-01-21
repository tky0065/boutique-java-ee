<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>

<%--<div class="row">--%>
<%--    <div class="col-md-4 mb-4">--%>
<%--        <div class="card">--%>
<%--            <div class="card-body">--%>
<%--                <h5 class="card-title">Produits</h5>--%>
<%--                <p class="card-text">Gérez votre inventaire de produits</p>--%>
<%--                <a href="<c:url value='/produits'/>" class="btn btn-primary">Accéder</a>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div class="col-md-4 mb-4">--%>
<%--        <div class="card">--%>
<%--            <div class="card-body">--%>
<%--                <h5 class="card-title">Ventes</h5>--%>
<%--                <p class="card-text">Enregistrez et consultez les ventes</p>--%>
<%--                <a href="<c:url value='/ventes'/>" class="btn btn-primary">Accéder</a>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--    <div class="col-md-4 mb-4">--%>
<%--        <div class="card">--%>
<%--            <div class="card-body">--%>
<%--                <h5 class="card-title">Livraisons</h5>--%>
<%--                <p class="card-text">Gérez les livraisons des fournisseurs</p>--%>
<%--                <a href="<c:url value='/livraisons'/>" class="btn btn-primary">Accéder</a>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</div>--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Inclusion de Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="<c:url value='/resources/js/dashboard.js'/>"></script>

<div class="container-fluid">
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
    <div class="row">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card border-left-primary shadow h-100">
                <div class="card-body">
                    <div class="row align-items-center">
                        <div class="col mr-2">
                            <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                Ventes du jour
                            </div>
                            <div class="h5 mb-0 font-weight-bold" id="ventesJourTotal">
                                <fmt:formatNumber value="${ventesJourTotal}" pattern="#,##0"/> FCFA
                            </div>
                        </div>
                        <div class="col-auto">
                            <i class="bi bi-cart fs-2 text-gray-300"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Autres cartes statistiques... -->
        <!-- ... -->
    </div>

    <!-- Graphiques -->
    <div class="row">
        <div class="col-xl-8 col-lg-7">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Évolution des ventes</h6>
                </div>
                <div class="card-body">
                    <canvas id="ventesChart"></canvas>
                </div>
            </div>
        </div>

        <div class="col-xl-4 col-lg-5">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Stock produits en alerte</h6>
                </div>
                <div class="card-body">
                    <canvas id="stockChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Tableaux détaillés -->
    <div class="row">
        <!-- Alertes de stock -->
        <div class="col-xl-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Produits en alerte de stock</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table" id="alertesTable">
                            <thead>
                            <tr>
                                <th>Produit</th>
                                <th>Stock actuel</th>
                                <th>Seuil d'alerte</th>
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
                                           class="btn btn-sm btn-primary">Commander</a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>

        <!-- Dernières ventes -->
        <div class="col-xl-6">
            <div class="card shadow mb-4">
                <div class="card-header py-3">
                    <h6 class="m-0 font-weight-bold text-primary">Dernières ventes</h6>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Heure</th>
                                <th>Montant</th>
                                <th>Vendeur</th>
                                <th>Action</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${ventesJour}" var="vente">
                                <tr>
                                    <td>
                                        <fmt:formatDate value="${vente.dateVente}" pattern="HH:mm"/>
                                    </td>
                                    <td>
                                        <fmt:formatNumber value="${vente.montantTotal}" pattern="#,##0"/> FCFA
                                    </td>
                                    <td>${vente.utilisateur.nom}</td>
                                    <td>
                                        <a href="<c:url value='/ventes/${vente.id}'/>"
                                           class="btn btn-sm btn-info">Détails</a>
                                        <a href="<c:url value='/tickets/${vente.id}'/>"
                                           class="btn btn-sm btn-secondary">Ticket</a>
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