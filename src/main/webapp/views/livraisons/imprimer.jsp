<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">

    <!-- Bootstrap CSS -->
    <link href="<c:url value='/resources/css/bootstrap.min.css'/>" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="<c:url value='/resources/css/bootstrap-icons.css'/>" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">
    <%--     Chart js--%>
    <script src="<c:url value='/resources/js/chart.js'/>"></script>
    <title>Bon de Livraison N°${livraison.id}</title>
    <style>
        @media print {
            .no-print {
                display: none;
            }
            body {
                padding: 20px;
            }
        }
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        .info-bloc {
            margin-bottom: 20px;
        }
        .table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        .table th, .table td {
            border: 1px solid #ddd;
            padding: 8px;
        }
        .table th {
            background-color: #f8f9fa;
        }
        .total {
            text-align: right;
            margin-top: 20px;
        }
        .btn-print {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="dashboard-container">
    <!-- Sidebar -->
    <c:import url="../layout/sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <c:import url="../layout/header.jsp"/>

        <!-- Main Content Area -->
        <div class="content-wrapper">
            <div class="container-fluid mt-4 mb-4">
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
                                            Date : ${livraison.dateLivraisonFormatted}
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
                                            ${livraison.utilisateurNomComplet}
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

        <!-- Footer -->
        <c:import url="../layout/footer.jsp"/>
    </div>
</div>
<script>
    console.log('Hello from imprimer.jsp');
    function imprimerBonLivraison() {
        const contenu = document.getElementById('bonLivraison').innerHTML;
        const fenetre = window.open('', '', 'height=600,width=800');
        fenetre.document.write('<html><head><title>Bon de livraison #${livraison.id}</title>');
        fenetre.document.write('<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">');
        fenetre.document.write('</head><body class="p-4">');
        fenetre.document.write(contenu);
        fenetre.document.write('</body></html>');
        fenetre.document.close();

        fenetre.onload = function () {
            fenetre.print();
            fenetre.close();
        };
    }
</script>
        <!-- Scripts -->
        <script src="<c:url value='/resources/js/popper.min.js'/>"></script>
        <script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>

</body>
</html>