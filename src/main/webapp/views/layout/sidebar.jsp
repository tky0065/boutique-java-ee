<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">
    <div class="sidebar-header">
        <a href="<c:url value='/dashboard'/>" class="sidebar-brand">
            <i class="bi bi-shop"></i> Gestion Boutique
        </a>
    </div>

    <div class="sidebar-nav">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a href="<c:url value='/dashboard'/>" class="nav-link ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}">
                    <i class="bi bi-speedometer2"></i> Tableau de bord
                </a>
            </li>

            <li class="nav-item">
                <a href="<c:url value='/ventes'/>" class="nav-link ${pageContext.request.requestURI.contains('/ventes') ? 'active' : ''}">
                    <i class="bi bi-cart"></i> Ventes
                </a>
            </li>

            <li class="nav-item">
                <a href="<c:url value='/produits/liste'/>" class="nav-link ${pageContext.request.requestURI.contains('/produits') ? 'active' : ''}">
                    <i class="bi bi-box"></i> Produits
                </a>
            </li>

            <li class="nav-item">
                <a href="<c:url value='/livraisons'/>" class="nav-link ${pageContext.request.requestURI.contains('/livraisons') ? 'active' : ''}">
                    <i class="bi bi-truck"></i> Livraisons
                </a>
            </li>

            <li class="nav-item">
                <a href="<c:url value='/'/>" class="nav-link ${pageContext.request.requestURI.contains('/rapports') ? 'active' : ''}">
                    <i class="bi bi-file-earmark-text"></i> Rapports
                </a>
            </li>
        </ul>

        <hr class="sidebar-divider">

        <ul class="nav flex-column">
            <li class="nav-item">
                <a href="<c:url value='/'/>" class="nav-link ${pageContext.request.requestURI.contains('/parametres') ? 'active' : ''}">
                    <i class="bi bi-gear"></i> Paramètres
                </a>
            </li>
        </ul>
    </div>
</div>