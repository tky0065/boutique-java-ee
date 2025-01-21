<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Détails de la Vente #${vente.id}</h1>
        <div class="btn-group">
            <a href="<c:url value='/tickets/${vente.id}'/>" class="btn btn-secondary">
                <i class="bi bi-receipt"></i> Imprimer Ticket
            </a>
            <a href="<c:url value='/ventes'/>" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Retour
            </a>
        </div>
    </div>

    <div class="row">
        <!-- Informations générales -->
        <div class="col-md-4 mb-4">
            <div class="card shadow h-100">
                <div class="card-header">
                    <h5 class="mb-0">Informations générales</h5>
                </div>
                <div class="card-body">
                    <table class="table table-sm">
                        <tr>
                            <th>Date :</th>
                            <td>
                               ${vente.dateVenteFormatted}
                            </td>
                        </tr>
                        <tr>
                            <th>Client :</th>
                            <td>${vente.nomClient}</td>
                        </tr>
                        <tr>
                            <th>Vendeur :</th>
                            <td>${vente.utilisateurNomComplet} </td>
                        </tr>
                        <tr>
                            <th>Total :</th>
                            <td class="fw-bold fs-5">
                                <fmt:formatNumber value="${vente.montantTotal}" pattern="#,##0"/> FCFA
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <!-- Liste des produits -->
        <div class="col-md-8 mb-4">
            <div class="card shadow h-100">
                <div class="card-header">
                    <h5 class="mb-0">Produits vendus</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Produit</th>
                                <th class="text-center">Quantité</th>
                                <th class="text-end">Prix unitaire</th>
                                <th class="text-end">Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${vente.lignesVente}" var="ligne">
                                <tr>
                                    <td>${ligne.produit.nom}</td>
                                    <td class="text-center">${ligne.quantite}</td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${ligne.prixUnitaire}" pattern="#,##0"/> FCFA
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber value="${ligne.montantTotal}" pattern="#,##0"/> FCFA
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="3" class="text-end fw-bold">Total :</td>
                                <td class="text-end fw-bold">
                                    <fmt:formatNumber value="${vente.montantTotal}" pattern="#,##0"/> FCFA
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Aperçu du ticket -->
    <!-- Aperçu du ticket -->
    <div class="row w-100 my-4">
        <div class="col-md-8 col-lg-6 mx-auto">
            <div class="card shadow-lg border-0">
                <!-- En-tête du ticket -->
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0 text-center">Aperçu du Ticket</h5>
                </div>
                <!-- Contenu du ticket -->
                <div class="card-body p-4">
                    <iframe
                            src="<c:url value='/tickets/${vente.id}/preview'/>"
                            style="width: 100%; height: 400px; border: 1px solid #ddd; border-radius: 8px;"
                            class="shadow-sm">
                    </iframe>
                </div>
                <!-- Bouton d'impression -->
                <div class="card-footer bg-light text-center">
                    <button
                            type="button"
                            class="btn btn-primary px-4 py-2 shadow-sm"
                            onclick="window.frames[0].print()">
                        <i class="bi bi-printer me-2"></i> Imprimer
                    </button>
                </div>
            </div>
        </div>
    </div>

</div>