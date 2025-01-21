<%--
  Created by IntelliJ IDEA.
  User: EnokDev
  Date: 20/01/2025
  Time: 12:35
  To change this template use File | Settings | File Templates.
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Gestion Boutique -  ${pageTitle}</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <link rel="stylesheet" href="<c:url value='/resources/css/auth.css'/>">

</head>
<body>

<div class="container mt-4">

<div class="row justify-content-center">
  <div class="col-md-8">
    <div class="card">
      <div class="card-header">
        <h4 class="mb-0 text-info text-center">Création de compte</h4>

      </div>
      <div class="card-body">
        <c:if test="${not empty error}">
          <div class="alert alert-danger">${error}</div>
        </c:if>
        <form action="<c:url value='/auth/register'/>" method="post">
          <div class="row">
            <div class="col-md-6 mb-3">
              <label for="nom" class="form-label">Nom</label>
              <input type="text" class="form-control" id="nom" name="nom" required>
            </div>
            <div class="col-md-6 mb-3">
              <label for="prenom" class="form-label">Prénom</label>
              <input type="text" class="form-control" id="prenom" name="prenom" required>
            </div>
          </div>

          <div class="mb-3">
            <label for="numeroMatricule" class="form-label">Numéro Matricule</label>
            <input type="text" class="form-control" id="numeroMatricule" name="numeroMatricule" required>
          </div>

          <div class="mb-3">
            <label for="sexe" class="form-label">Sexe</label>
            <select class="form-select" id="sexe" name="sexe" required>
              <option value="">Sélectionner...</option>
              <option value="HOMME">Homme</option>
              <option value="FEMME">Femme</option>
            </select>
          </div>

          <div class="mb-3">
            <label for="dateNaissance" class="form-label">Date de naissance</label>
            <input type="date" class="form-control" id="dateNaissance" name="dateNaissance" required>
          </div>

          <div class="mb-3">
            <label for="identifiant" class="form-label">Identifiant</label>
            <input type="text" class="form-control" id="identifiant" name="identifiant" required>
          </div>

          <div class="mb-3">
            <label for="motDePasse" class="form-label">Mot de passe</label>
            <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
          </div>

          <div class="d-grid gap-2">
            <button type="submit" class="btn btn-primary">S'inscrire</button>
            <a href="<c:url value='/auth/login'/>" class="btn btn-secondary">Retour à la connexion</a>
          </div>
        </form>
      </div>
    </div>
  </div>
</div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>