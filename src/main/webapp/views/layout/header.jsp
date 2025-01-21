<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<header class="bg-light p-2  header shadow-sm fixed-top">
    <div class="container d-flex justify-content-between align-items-center">
        <!-- Bouton Toggle Sidebar (commenté) -->
        <%--
        <button type="button" class="btn btn-outline-secondary" id="sidebarToggle" aria-label="Toggle Sidebar">
            <i class="bi bi-list"></i>
        </button>
        --%>

        <!-- Barre de recherche -->
        <form action="<c:url value='/'/>" method="GET" class="w-50">
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Rechercher..." aria-label="Rechercher" name="search" required>
                <button class="btn btn-primary" type="submit" aria-label="Rechercher">
                    <i class="bi bi-search"></i>
                </button>
            </div>
        </form>

        <!-- Navigation droite -->
        <div class="d-flex align-items-center">
            <!-- Notifications -->
            <div class="dropdown me-3">
                <button type="button" class="btn btn-outline-secondary notifications-icon"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <i class="bi bi-bell"></i>
                    <span class="badge bg-danger">${produitsAlerte.size()}</span>
                </button>

                <div class="dropdown-menu dropdown-menu-end">
                    <h6 class="dropdown-header">Alertes de stock</h6>
                    <c:forEach items="${produitsAlerte}" var="produit" end="4">
                        <a class="dropdown-item" href="<c:url value='/produits/${produit.id}'/>">
                            <i class="bi bi-exclamation-circle text-warning"></i>
                                ${produit.nom} - Stock: ${produit.quantiteStock}
                        </a>
                    </c:forEach>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item text-center" href="<c:url value='/produits/liste/?alerte=true'/>">Voir toutes les alertes</a>
                </div>
            </div>

            <!-- Menu Utilisateur -->
            <div class="dropdown">
                <button type="button" class="btn btn-outline-secondary user-menu"
                        data-bs-toggle="dropdown" aria-expanded="false">
                    <c:if test="${not empty sessionScope.utilisateur}">
                        <span>${sessionScope.utilisateur.nom}</span>
                        <img src="<c:url value='/resources/images/NavLogo.png' />"
                             alt="Avatar"
                             height="25"
                             width="25"
                             class="rounded-circle ms-2">
                    </c:if>
                </button>

                <div class="dropdown-menu dropdown-menu-end">
                    <a class="dropdown-item" href="<c:url value='/'/>"><i class="bi bi-person"></i> Mon profil</a>
                    <a class="dropdown-item" href="<c:url value='/'/>"><i class="bi bi-gear"></i> Paramètres</a>
                    <div class="dropdown-divider"></div>
                    <a class="dropdown-item" href="<c:url value='/auth/logout'/>"><i class="bi bi-box-arrow-right"></i> Déconnexion</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Notification Toast Container -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 1080">
        <div id="notificationToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="bi bi-info-circle me-2"></i>
                <strong class="me-auto">Notification</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body"></div>
        </div>
    </div>

</header>
