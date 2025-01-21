<%--
  Created by IntelliJ IDEA.
  User: EnokDev
  Date: 20/01/2025
  Time: 19:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="<c:url value='/dashboard'/>">Gestion Boutique</a>
        <%--        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">--%>
        <%--            <span class="navbar-toggler-icon"></span>--%>
        <%--        </button>--%>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/produits/liste'/>">Produits</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/ventes/liste'/>">Ventes</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/livraisons/liste'/>">Livraisons</a>
                </li>
            </ul>
            <ul class="navbar-nav ms-auto">
                <c:if test="${not empty sessionScope.utilisateur}">
                    <li class="nav-item">
                        <a class="nav-link" href="<c:url value='/auth/logout'/>">Déconnexion</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</nav>
