<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>

<%--<!DOCTYPE html>--%>
<%--<html lang="fr">--%>

<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <meta name="viewport" content="width=device-width, initial-scale=1.0">--%>
<%--    <title>Gestion Boutique - Accueil</title>--%>
<%--    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">--%>
<%--</head>--%>

<%--<body>--%>
<%--<nav class="navbar navbar-expand-lg navbar-dark bg-dark">--%>
<%--    <div class="container">--%>
<%--        <a class="navbar-brand" href="<c:url value='/index.jsp'/>">Gestion Boutique</a>--%>
<%--        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">--%>
<%--            <span class="navbar-toggler-icon"></span>--%>
<%--        </button>--%>
<%--        <div class="collapse navbar-collapse" id="navbarNav">--%>
<%--            <ul class="navbar-nav">--%>
<%--                <li class="nav-item"><a class="nav-link" href="<c:url value='/views/auth/login.jsp'/>">Connexion</a></li>--%>
<%--                <li class="nav-item"><a class="nav-link" href="<c:url value='/views/auth/register.jsp'/>">Inscription</a></li>--%>
<%--                <li class="nav-item"><a class="nav-link" href="<c:url value='/views/auth/contact.jsp'/>">Contact</a></li>--%>
<%--                <li class="nav-item"><a class="nav-link" href="<c:url value='/views/produits/list.jsp'/>">Produits</a></li>--%>
<%--            </ul>--%>
<%--        </div>--%>
<%--    </div>--%>
<%--</nav>--%>

<%--<div class="container mt-5 text-center">--%>
<%--    <h1>Bienvenue sur Gestion Boutique!</h1>--%>
<%--    <p>Votre plateforme pour gérer vos produits facilement.</p>--%>
<%--    <p>Utilisez le menu ci-dessus pour accéder aux différentes sections.</p>--%>

<%--    <!-- Ajoutez éventuellement une image ou un lien vers une fonctionnalité -->--%>
<%--    <img src="<c:url value='/resources/images/shop.png'/>" alt="Bienvenue" class="img-fluid mt-4"/>--%>

<%--    <!-- Boutons d'action -->--%>
<%--    <div class="mt-4">--%>
<%--        <a href="<c:url value='/views/auth/login.jsp'/>" class="btn btn-primary">Se connecter</a>--%>
<%--        <a href="<c:url value='/views/auth/register.jsp'/>" class="btn btn-secondary">Créer un compte</a>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>--%>
<%--</body>--%>

<%--</html>--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${empty sessionScope.utilisateur}">
    <c:redirect url="/auth/login"/>
</c:if>

<jsp:forward page="/dashboard"/>
