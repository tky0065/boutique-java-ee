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
  <link href="<c:url value='/resources/css/bootstrap.min.css'/>" rel="stylesheet">
  <!-- Bootstrap Icons -->
  <link href="<c:url value='/resources/css/bootstrap-icons.css'/>" rel="stylesheet">
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
<div class="container-fluid mt-4 mb-4">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
  <!-- En-tête -->
  <div class="d-flex justify-content-between align-items-center mb-4">
    <h1 class="h3 mb-0">Gestion des Utilisateurs</h1>
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#ajoutUtilisateurModal">
      <i class="bi bi-plus-lg"></i> Nouvel Utilisateur
    </button>
  </div>

  <!-- Liste des utilisateurs -->
  <div class="card shadow">
    <div class="card-body">
      <div class="table-responsive">
        <table class="table">
          <thead>
          <tr>
            <th>ID</th>
            <th>Nom complet</th>
            <th>Matricule</th>
            <th>Identifiant</th>
            <th>Role</th>
            <th>Date de naissance</th>
            <th>Sexe</th>
            <th>Actions</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="utilisateur" items="${utilisateurs}">
            <tr>
              <td>${utilisateur.id}</td>
              <td>${utilisateur.nom} ${utilisateur.prenom}</td>
              <td>${utilisateur.numeroMatricule}</td>
              <td>${utilisateur.identifiant}</td>
                <td>${utilisateur.role}</td>
              <td>
                ${utilisateur.dateNaissance}
              </td>
              <td>${utilisateur.sexe}</td>
              <td>
                <div class="btn-group">
                  <a href="<c:url value='/utilisateurs/edit/${utilisateur.id}'/>"
                     class="btn btn-sm btn-outline-primary">
                    <i class="bi bi-pencil"></i>
                  </a>
                  <form action="<c:url value='/utilisateurs/delete/${utilisateur.id}'/>"
                        method="post" style="display: inline;">
                    <button type="submit" class="btn btn-sm btn-outline-danger"
                            onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?');">
                      <i class="bi bi-trash"></i>
                    </button>
                  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Modal Ajout -->
  <div class="modal fade" id="ajoutUtilisateurModal" tabindex="-1">
    <div class="modal-dialog">
      <div class="modal-content">
        <form action="<c:url value='/utilisateurs/save'/>" method="post">
          <div class="modal-header">
            <h5 class="modal-title">Nouvel Utilisateur</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
          </div>
          <div class="modal-body">
            <div class="mb-3">
              <label class="form-label">Nom</label>
              <input type="text" class="form-control" name="nom" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Prénom</label>
              <input type="text" class="form-control" name="prenom" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Numéro Matricule</label>
              <input type="text" class="form-control" name="numeroMatricule" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Identifiant</label>
              <input type="text" class="form-control" name="identifiant" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Mot de passe</label>
              <input type="password" class="form-control" name="motDePasse" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Date de naissance</label>
              <input type="date" class="form-control" name="dateNaissance" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Sexe</label>
              <select class="form-select" name="sexe" required>
                <option value="HOMME">Homme</option>
                <option value="FEMME">Femme</option>
              </select>
            </div>

            <div class="mb-3">
              <label class="form-label mb-0">Rôle</label>
                <select class="form-select" name="role" required>
                    <option value="ADMIN">Administrateur</option>
                    <option value="VENDEUR">Vendeur</option>
                    <option value="GESTIONNAIRE_STOCK">Gestionnaire de stock</option>
                </select>
            </div>

          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
            <button type="submit" class="btn btn-primary">Enregistrer</button>
          </div>
        </form>
      </div>
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
<!-- Scripts -->
<script src="<c:url value='/resources/js/popper.min.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>