<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Détails de la Livraison #${livraison.id}</h1>
        <div class="btn-group">
            <a href="<c:url value='/livraisons/imprimer/${livraison.id}'/>" class="btn btn-secondary">
                <i class="bi bi-printer"></i> Imprimer
            </a>
            <a href="<c:url value='/livraisons'/>" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Retour
            </a>
        </div>
    </div>

    <div class="row">
        <!-- Informations de la livraison -->
        <div class="col-md-4 mb-4">
            <div class="card shadow h-100">
                <div class="card-header">
                    <h5 class="mb-0">Informations générales</h5>
                </div>
                <div class="card-body">
                    <table class="table table-bordered">
                        <tr>
                            <th class="table-light" style="width: 40%">Numéro</th>
                            <td>${livraison.id}</td>
                        </tr>
                        <tr>
                            <th class="table-light">Date</th>
                            <td>
                                <fmt:formatDate value="${livraison.dateLivraison}"
                                                pattern="dd/MM/yyyy HH:mm"/>
                            </td>
                        </tr>
                        <tr>
                            <th class="table-light">Fournisseur</th>
                            <td>${livraison.nomFournisseur}</td>
                        </tr>
                        <tr>
                            <th class="table-light">Réceptionné par</th>
                            <td>${livraison.utilisateur.nom} ${livraison.utilisateur.prenom}</td>
                        </tr>
                        <tr>
                            <th class="table-light">Montant Total</th>
                            <td class="fw-bold">
                                <fmt:formatNumber value="${livraison.montantTotal}" pattern="#,##0"/> FCFA
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
        </div>

        <!-- Liste des produits livrés -->
        <div class="col-md-8 mb-4">
            <div class="card shadow h-100">
                <div class="card-header">
                    <h5 class="mb-0">Produits livrés</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                            <tr>
                                <th>Produit</th>
                                <th class="text-center">Quantité</th>
                                <th class="text-end">Prix unitaire</th>
                                <th class="text-end">Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${livraison.lignesLivraison}" var="ligne">
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
                                <td colspan="3" class="text-end fw-bold">Total</td>
                                <td class="text-end fw-bold">
                                    <fmt:formatNumber value="${livraison.montantTotal}" pattern="#,##0"/> FCFA
                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Aperçu du bon de livraison -->
    <div class="row">
        <div class="col-md-8 mx-auto">
            <div class="card shadow">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Bon de livraison</h5>
                    <button type="button" class="btn btn-primary btn-sm" onclick="imprimerBonLivraison()">
                        <i class="bi bi-printer"></i> Imprimer
                    </button>
                </div>
                <div class="card-body">
                    <div class="border p-3" id="bonLivraison">
                        <!-- En-tête -->
                        <div class="text-center mb-4">
                            <h4>BON DE LIVRAISON</h4>
                            <p class="mb-0">N° ${livraison.id}</p>
                            <p class="mb-0">
                                Date : <fmt:formatDate value="${livraison.dateLivraison}"
                                                       pattern="dd/MM/yyyy HH:mm"/>
                            </p>
                        </div>

                        <!-- Informations fournisseur -->
                        <div class="row mb-4">
                            <div class="col-6">
                                <strong>Fournisseur :</strong><br/>
                                ${livraison.nomFournisseur}
                            </div>
                            <div class="col-6 text-end">
                                <strong>Réceptionné par :</strong><br/>
                                ${livraison.utilisateur.nom} ${livraison.utilisateur.prenom}
                            </div>
                        </div>

                        <!-- Table des produits -->
                        <table class="table table-bordered">
                            <thead>
                            <tr>
                                <th>Désignation</th>
                                <th class="text-center">Quantité</th>
                                <th class="text-end">Prix unitaire</th>
                                <th class="text-end">Total</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${livraison.lignesLivraison}" var="ligne">
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
                                <td colspan="3" class="text-end fw-bold">Total</td>
                                <td class="text-end fw-bold">
                                    <fmt:formatNumber value="${livraison.montantTotal}" pattern="#,##0"/> FCFA
                                </td>
                            </tr>
                            </tfoot>
                        </table>

                        <!-- Signatures -->
                        <div class="row mt-5">
                            <div class="col-6">
                                <p>Signature du fournisseur</p>
                                <div style="height: 80px; border-bottom: 1px solid #dee2e6"></div>
                            </div>
                            <div class="col-6 text-end">
                                <p>Signature du réceptionnaire</p>
                                <div style="height: 80px; border-bottom: 1px solid #dee2e6"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function imprimerBonLivraison() {
        const contenu = document.getElementById('bonLivraison').innerHTML;
        const fenetre = window.open('', '', 'height=600,width=800');
        fenetre.document.write('<html><head><title>Bon de livraison #${livraison.id}</title>');
        fenetre.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">');
        fenetre.document.write('</head><body class="p-4">');
        fenetre.document.write(contenu);
        fenetre.document.write('</body></html>');
        fenetre.document.close();

        fenetre.onload = function() {
            fenetre.print();
            fenetre.close();
        };
    }
</script>