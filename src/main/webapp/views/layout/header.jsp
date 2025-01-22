<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="bg-light py-2 px-3 header shadow-sm fixed-top">
    <div class="container-fluid d-flex justify-content-between align-items-center">
        <!-- Barre de recherche -->
        <form action="<c:url value='/produits/liste'/>" method="GET" class="w-50">
            <div class="input-group">
                <input type="text" class="form-control rounded-start" placeholder="Rechercher..." aria-label="Rechercher" name="search" required>
                <button class="btn btn-primary rounded-end" type="submit" aria-label="Rechercher">
                    <i class="bi bi-search"></i>
                </button>
            </div>
        </form>

        <!-- Navigation droite -->
        <div class="d-flex align-items-center gap-3">
            <!-- Notifications -->
            <c:if test="${not empty produitsAlerte}">
                <div class="dropdown">
                    <button type="button" class="btn btn-outline-secondary position-relative notifications-icon"
                            data-bs-toggle="dropdown" aria-expanded="false">
                        <i class="bi bi-bell"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                ${produitsAlerte.size()}
                        </span>
                    </button>

                    <div class="dropdown-menu dropdown-menu-end shadow-sm">
                        <h6 class="dropdown-header">Alertes de stock</h6>
                        <c:forEach items="${produitsAlerte}" var="produit" end="4">
                            <a class="dropdown-item d-flex justify-content-between align-items-center" href="<c:url value=''/>">
                                <span><i class="bi bi-exclamation-circle text-warning me-2"></i>${produit.nom}</span>
                                <span class="text-muted">Stock: ${produit.quantiteStock}</span>
                            </a>
                        </c:forEach>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item text-center text-primary" href="<c:url value='/alertes/alertes'/>">Voir toutes les alertes</a>
                    </div>
                </div>
            </c:if>

            <!-- Menu Utilisateur -->
            <div class="dropdown">
                <button type="button" class="btn btn-outline-secondary d-flex align-items-center user-menu"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <c:choose>
                        <c:when test="${not empty sessionScope.utilisateur}">
                            <span class="me-2">${sessionScope.utilisateur.nom}</span>
                            <img src="<c:url value='/resources/images/NavLogo.png' />"
                                 alt="Avatar"
                                 height="30"
                                 width="30"
                                 class="rounded-circle">
                        </c:when>
                        <c:otherwise>
                            <span class="me-2">Invité</span>
                            <img src="<c:url value='/resources/images/NavLogo.png' />"
                                 alt="Avatar"
                                 height="30"
                                 width="30"
                                 class="rounded-circle">
                        </c:otherwise>
                    </c:choose>
                </button>

                <div class="dropdown-menu dropdown-menu-end shadow-sm">
                    <c:if test="${not empty sessionScope.utilisateur}">
                        <a class="dropdown-item" href="<c:url value='/'/>"><i class="bi bi-person me-2"></i> Mon profil</a>
                        <a class="dropdown-item" href="<c:url value='/'/>"><i class="bi bi-gear me-2"></i> Paramètres</a>
                        <div class="dropdown-divider"></div>
                        <a class="dropdown-item text-danger" href="<c:url value='/auth/logout'/>"><i class="bi bi-box-arrow-right me-2"></i> Déconnexion</a>
                    </c:if>
                    <c:if test="${empty sessionScope.utilisateur}">
                        <a class="dropdown-item text-primary" href="<c:url value='/auth/login'/>"><i class="bi bi-box-arrow-in-right me-2"></i> Connexion</a>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Notification Toast Container -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1080;">
        <div id="notificationToast" class="toast fade" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header bg-primary text-white">
                <i class="bi bi-info-circle me-2"></i>
                <strong class="me-auto">Notification</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body bg-light">
                <!-- Dynamic content -->
                <c:if test="${not empty sessionScope.notificationMessage}">
                    ${sessionScope.notificationMessage}
                </c:if>
            </div>
        </div>
    </div>
</header>
