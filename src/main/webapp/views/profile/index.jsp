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
<div class="dashboard-container ">
  <!-- Sidebar -->
  <c:import url="../layout/sidebar.jsp"/>

  <div class="main-content">
    <!-- Header -->
    <c:import url="../layout/header.jsp"/>

<div class="container-fluid mt-4 mb-5">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
  <div class="row">
    <!-- Informations du profil -->
    <div class="col-md-6">
      <div class="card shadow">
        <div class="card-header">
          <h5 class="mb-0">Mon Profil</h5>
        </div>
        <div class="card-body">
          <form action="<c:url value='/profile/update'/>" method="post" class="needs-validation" novalidate>
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
              <input type="text" class="form-control" value="${utilisateur.numeroMatricule}" readonly>
            </div>

            <div class="mb-3">
              <label class="form-label">Date de naissance</label>
              <input type="date" class="form-control" name="dateNaissance"
                     value="${utilisateur.dateNaissance}" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Rôle</label>
              <input type="text" class="form-control" value="${utilisateur.role.libelle}" readonly>
            </div>

            <div class="text-end">
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-save"></i> Enregistrer les modifications
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Changement de mot de passe -->
    <div class="col-md-6">
      <div class="card shadow">
        <div class="card-header">
          <h5 class="mb-0">Changer le mot de passe</h5>
        </div>
        <div class="card-body">
          <form action="<c:url value='/profile/password'/>" method="post" class="needs-validation" novalidate>
            <div class="mb-3">
              <label class="form-label">Ancien mot de passe</label>
              <input type="password" class="form-control" name="oldPassword" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Nouveau mot de passe</label>
              <input type="password" class="form-control" name="newPassword" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Confirmer le mot de passe</label>
              <input type="password" class="form-control" name="confirmPassword" required>
            </div>

            <div class="text-end">
              <button type="submit" class="btn btn-primary">
                <i class="bi bi-key"></i> Changer le mot de passe
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</div>
    <!-- Footer -->
    <c:import url="../layout/footer.jsp"/>
  </div>

  <script>


    document.addEventListener('DOMContentLoaded', function() {
      // Validation des dates
      const formFiltre = document.querySelector('form');
      formFiltre.addEventListener('submit', function(e) {
        const dateDebut = document.getElementById('dateDebut').value;
        const dateFin = document.getElementById('dateFin').value;

        if (dateDebut && dateFin) {
          if (dateDebut > dateFin) {
            e.preventDefault();
            alert('La date de début doit être antérieure à la date de fin');
          }
        }
      });
    });
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
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>