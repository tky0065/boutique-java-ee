
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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

        <!-- Main Content Area -->
        <div class="content-wrapper">
            <div class="container-fluid mb-4">
                <!-- Messages flash -->
                <c:import url="../fragments/messages.jsp"/>
                <!-- En-tête -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1 class="h3 mb-0">
                        ${produit.id == null ? 'Nouveau Produit' : 'Modifier Produit'}
                    </h1>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card shadow">
                            <div class="card-body">
                                <form action="<c:url value="/produits/editer/${produit.id}"/>"
                                      method="post" class="needs-validation" novalidate>

                                    <!-- Nom du produit -->
                                    <div class="mb-3">
                                        <label for="nom" class="form-label">Nom du produit</label>
                                        <input type="text" class="form-control" id="nom" name="nom"
                                               value="${produit.nom}" required>
                                        <div class="invalid-feedback">
                                            Le nom du produit est requis
                                        </div>
                                    </div>

                                    <!-- Description -->
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description"
                                                  rows="3">${produit.description}</textarea>
                                    </div>

                                    <!-- Prix unitaire -->
                                    <div class="mb-3">
                                        <label for="prixUnitaire" class="form-label">Prix unitaire (FCFA)</label>
                                        <input type="number" class="form-control" id="prixUnitaire"
                                               name="prixUnitaire"
                                               value="${produit.prixUnitaire}" required>
                                        <div class="invalid-feedback">
                                            Le prix unitaire doit être supérieur à 0
                                        </div>
                                    </div>

                                    <div class="row">
                                        <!-- Quantité en stock -->
                                        <div class="col-md-6 mb-3">
                                            <label for="quantiteStock" class="form-label">Quantité en stock</label>
                                            <input type="number" class="form-control" id="quantiteStock"
                                                   name="quantiteStock" min="0"
                                                   value="${produit.quantiteStock}" required>
                                            <div class="invalid-feedback">
                                                La quantité en stock doit être supérieure ou égale à 0
                                            </div>
                                        </div>

                                        <!-- Seuil d'alerte -->
                                        <div class="col-md-6 mb-3">
                                            <label for="seuilAlerte" class="form-label">Seuil d'alerte</label>
                                            <input type="number" class="form-control" id="seuilAlerte"
                                                   name="seuilAlerte" min="0"
                                                   value="${produit.seuilAlerte}" required>
                                            <div class="invalid-feedback">
                                                Le seuil d'alerte doit être supérieur ou égal à 0
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Boutons d'action -->
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="<c:url value='/produits/liste'/>" class="btn btn-secondary">
                                            <i class="bi bi-x-circle"></i> Annuler
                                        </a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="bi bi-check-lg"></i> Enregistrer
                                        </button>
                                    </div>
                                </form>
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


<!-- Scripts -->
<script>
    // Auto-dismiss alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
    // Validation des formulaires Bootstrap
    (function () {
        'use strict'

        const forms = document.querySelectorAll('.needs-validation')

        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }

                    form.classList.add('was-validated')
                }, false)
            })
    })()


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
<!-- Scripts -->
<script src="<c:url value='/resources/js/popper.min.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>