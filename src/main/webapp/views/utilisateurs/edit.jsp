<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique - Ventes</title>

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

<div class="container-fluid mt-4 mb-4 w-75 ">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
    <div class="card">
        <div class="card-header">
            <h3 class="card-title">Modifier Utilisateur</h3>
        </div>
        <div class="card-body">
            <form action="<c:url value='/utilisateurs/update'/>" method="post">
                <input type="hidden" name="id" value="${utilisateur.id}">

                <div class="mb-3">
                    <label class="form-label">Nom</label>
                    <input type="text" class="form-control" name="nom" value="${utilisateur.nom}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Prénom</label>
                    <input type="text" class="form-control" name="prenom" value="${utilisateur.prenom}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Numéro Matricule</label>
                    <input type="text" class="form-control" name="numeroMatricule" value="${utilisateur.numeroMatricule}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Identifiant</label>
                    <input type="text" class="form-control" name="identifiant" value="${utilisateur.identifiant}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label ">Role</label>
                    <select class="form-select" name="role" required>
                        <option value="ADMIN" ${utilisateur.role == 'ADMIN' ? 'selected' : ''}>Administrateur</option>
                        <option value="VENDEUR" ${utilisateur.role == 'VENDEUR' ? 'selected' : ''}>Vendeur</option>
                        <option value="GESTIONNAIRE_STOCK" ${utilisateur.role == 'GESTIONNAIRE_STOCK' ? 'selected' : ''}>Gestionnaire de stock</option>
                    </select>
                </div>

                <div class="mb-3">
                    <label class="form-label">Mot de passe</label>
                    <input type="password" class="form-control" name="motDePasse">
                    <small class="text-muted">Laissez vide pour conserver l'ancien mot de passe</small>
                </div>

                <div class="mb-3">
                    <label class="form-label">Date de naissance</label>
                    <input type="date" class="form-control" name="dateNaissance"
                           ${utilisateur.dateNaissance}
                </div>

                <div class="mb-3">
                    <label class="form-label">Sexe</label>
                    <select class="form-select" name="sexe" required>
                        <option value="HOMME" ${utilisateur.sexe == 'HOMME' ? 'selected' : ''}>Homme</option>
                        <option value="FEMME" ${utilisateur.sexe == 'FEMME' ? 'selected' : ''}>Femme</option>
                    </select>
                </div>

                <div class="text-end">
                    <a href="<c:url value='/utilisateurs'/>" class="btn btn-secondary">Annuler</a>
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                </div>
            </form>
        </div>
    </div>
</div>
        <!-- Footer -->
        <c:import url="../layout/footer.jsp"/>
    </div>
</div>

<!-- Scripts -->
<script>
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

</body>
</html>