
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique -  ${pageTitle}</title>
   <link href="<c:url value='/resources/css/bootstrap.min.css'/>" rel="stylesheet">

    <link rel="stylesheet" href="<c:url value='/resources/css/auth.css'/>">
</head>
<body class="gradient-advanced">

<div class="container mt-4">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
<div class="row justify-content-center">
    <div class="col-md-6 col-lg-4">
        <div class="card shadow">
            <div class="card-header">
                <h4 class="mb-0">Connexion</h4>
            </div>
            <div class="card-body">
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success">${success}</div>
                </c:if>
                <form action="<c:url value='/auth/login'/>" method="post">
                    <div class="mb-3">
                        <label for="identifiant" class="form-label">Identifiant</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" class="form-control" id="identifiant" name="identifiant" required>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="motDePasse" class="form-label">Mot de passe</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="bi bi-lock"></i>
                            </span>
                            <input type="password" class="form-control" id="motDePasse" name="motDePasse" required>
                        </div>
                    </div>
                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary">Se connecter</button>
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-light">Créer un compte</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</div>
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
</script>
<!-- Scripts -->
<script src="<c:url value='/resources/js/popper.min.js'/>"></script>
<script src="<c:url value='/resources/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>
