<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
<!-- Custom CSS -->
<link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">

<style>
    .sidebar {
        width: 250px;
        background-color: #343a40;
        color: #fff;
        height: 100vh;
        display: flex;
        flex-direction: column;
        padding: 0;
    }

    .sidebar-header {
        padding: 0.5rem;
        text-align: center;
        font-size: 1rem;
        background-color: #212529;
    }

    .sidebar-brand {
        color: #fff;
        text-decoration: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .sidebar-brand:hover {
        color: #ffc107;
    }

    .sidebar-nav {
        flex-grow: 1;
        padding: 0;
        background-color: #343a40;
        margin-bottom: 0;
    }
    .sidebar-nav:hover {
        color: #ffc107;
    }

    .nav {
        list-style: none;
    }

    .nav-item {
        margin: 0;
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 0.5rem 1rem;
        color: #adb5bd;
        text-decoration: none;
        font-size: 1rem;
        gap: 0.5rem;
        transition: all 0.3s;
    }

    .nav-link:hover {
        background-color: #495057;
        color: #fff;
    }

    .nav-link.active {
        background-color: #ffc107;
        color: #212529;
        font-weight: bold;
    }

    /*.sidebar-divider {*/
    /*    border: 0;*/
    /*    height: 1px;*/
    /*    align-items: center;*/
    /*    justify-content: center;*/
    /*    width: 50%;*/
    /*    background: #495057;*/
    /*    margin: 0;*/
    /*}*/

    /* Section spécifique pour "Mon Profil" et "Paramètres" */
    .sidebar-footer {
        margin-top: 0;
        margin-bottom: 0;
    }

    .nav-footer-link {
        display: flex;
        align-items: center;
        padding: 0.5rem 1rem;
        color: #adb5bd;
        text-decoration: none;
        font-size: 1rem;
        gap: 0.5rem;
        transition: all 0.3s;
    }

    .nav-footer-link:hover {
        background-color: #495057;
        color: #fff;
    }
</style>

<div class="sidebar  mb-3">
    <div class="sidebar-header">
        <a href="<c:url value='/dashboard'/>" class="sidebar-brand fs-5">
            <i class="bi bi-shop"></i> Gestion Boutique
        </a>
    </div>

    <div class="sidebar-nav">
        <ul class="nav flex-column mb-0 g-0">
            <%-- Menu accessible à tous --%>
            <li class="nav-item">
                <a href="<c:url value='/dashboard'/>"
                   class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}">
                    <i class="bi bi-speedometer2"></i> Tableau de bord
                </a>
            </li>
            <%-- Menu Ventes (VENDEUR, ADMIN) --%>
            <c:if test="${sessionScope.userRole == 'VENDEUR' || sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a href="<c:url value='/ventes'/>"
                       class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/ventes') ? 'active' : ''}">
                        <i class="bi bi-cart"></i> Ventes
                    </a>
                </li>
            </c:if>
            <%-- Menu Produits (GESTIONNAIRE_STOCK, ADMIN) --%>
            <c:if test="${sessionScope.userRole == 'GESTIONNAIRE_STOCK' || sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a href="<c:url value='/produits/liste'/>"
                       class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/produits') ? 'active' : ''}">
                        <i class="bi bi-box"></i> Produits
                    </a>
                </li>
            </c:if>
            <%-- Menu Livraisons (GESTIONNAIRE_STOCK, ADMIN) --%>
            <c:if test="${sessionScope.userRole == 'GESTIONNAIRE_STOCK' || sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a href="<c:url value='/livraisons'/>"
                       class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/livraisons') ? 'active' : ''}">
                        <i class="bi bi-truck"></i> Livraisons
                    </a>
                </li>
            </c:if>
            <%-- Menu Historique (tous) --%>
            <li class="nav-item">
                <a href="<c:url value='/historique'/>"
                   class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/historique') ? 'active' : ''}">
                    <i class="bi bi-clock-history"></i> Historique
                </a>
            </li>
            <%-- Menu Rapports (ADMIN) --%>
            <c:if test="${sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a href="<c:url value='/rapports'/>"
                       class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/rapports') ? 'active' : ''}">
                        <i class="bi bi-file-earmark-text"></i> Rapports
                    </a>
                </li>
            </c:if>
            <%-- Menu Livraisons (GESTIONNAIRE_STOCK, ADMIN) --%>
            <c:if test="${sessionScope.userRole == 'GESTIONNAIRE_STOCK' || sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a href="<c:url value='/alertes'/>"
                       class="nav-link py-2 px-2 ${pageContext.request.requestURI.contains('/alertes') ? 'active' : ''}">
                        <i class="bi bi-exclamation-triangle"></i> Alertes
                    </a>
                </li>
            </c:if>
            <%-- Menu Utilisateurs (ADMIN) --%>
            <c:if test="${sessionScope.userRole == 'ADMIN'}">
                <li class="nav-item">
                    <a href="<c:url value='/utilisateurs'/>"
                       class="nav-link py-2 px-2  ${pageContext.request.requestURI.contains('/utilisateurs') ? 'active' : ''}">
                        <i class="bi bi-person"></i> Utilisateurs
                    </a>
                </li>
                <div class="border-1 border-bottom border-secondary align-items-center mx-3 "></div>

                <li class="nav-item">
                    <a href="<c:url value='/profile'/>"
                       class=" nav-link py-1 px-2  ${pageContext.request.requestURI.contains('/profile') ? 'active' : ''}">
                        <i class="bi bi-person-circle"></i> Mon Profil
                    </a>
                </li>
                <%-- Profil et Déconnexion (tous) --%>
                <li class="nav-item mb-5">
                    <a href="<c:url value='/auth/logout'/>"
                       class=" nav-link  py-1 px-2 text-danger text-center ">
                        <i class="bi bi-box-arrow-right text-danger text-center  "></i> Déconnexion
                    </a>
                </li>
            </c:if>
        </ul>

    </div>


</div>
