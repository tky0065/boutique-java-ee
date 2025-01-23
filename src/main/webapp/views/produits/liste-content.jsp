<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.enokdev.boutique.utils.StringUtils" %>

<!-- Bootstrap CSS et JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Gestion des Produits</h1>
        <a href="<c:url value='/produits/nouveau'/>" class="btn btn-primary">
            <i class="bi bi-plus-lg"></i> Nouveau Produit
        </a>
    </div>

    <!-- Recherche et filtres -->
    <div class="card shadow-sm mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <input type="hidden" name="page" value="0">
                <input type="hidden" name="size" value="${pageSize}">
                <div class="col-md-6">
                    <div class="input-group">
                        <input type="text" class="form-control" name="search"
                               placeholder="Rechercher un produit..." value="${search}">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="sortBy" class="form-select">
                        <option value="nom" ${param.sortBy == 'nom' ? 'selected' : ''}>Nom</option>
                        <option value="stock" ${param.sortBy == 'stock' ? 'selected' : ''}>Stock</option>
                        <option value="prix" ${param.sortBy == 'prix' ? 'selected' : ''}>Prix</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="order" class="form-select">
                        <option value="asc" ${param.order == 'asc' ? 'selected' : ''}>Croissant</option>
                        <option value="desc" ${param.order == 'desc' ? 'selected' : ''}>Décroissant</option>
                    </select>
                </div>
            </form>
        </div>
    </div>

    <!-- Liste des produits -->
    <div class="card shadow-sm">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>Nom</th>
                        <th>Description</th>
                        <th class="text-end">Prix</th>
                        <th class="text-center">Stock</th>
                        <th class="text-center">Seuil Alerte</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${produits.content}" var="produit">
                        <tr>
                            <td>${StringUtils.truncate(produit.nom,20)}</td>

                            <td>${StringUtils.truncate(produit.description, 20)}</td>

                            <td class="text-end">
                                <fmt:formatNumber value="${produit.prixUnitaire}" pattern="#,##0"/> FCFA
                            </td>
                            <td class="text-center">
                                    <span class="badge ${produit.quantiteStock <= produit.seuilAlerte ? 'bg-danger' : 'bg-success'}">
                                            ${produit.quantiteStock}
                                    </span>
                            </td>
                            <td class="text-center">${produit.seuilAlerte}</td>
                            <td>
                                <div class="btn-group">
                                    <a href="<c:url value='/produits/${produit.id}'/>"
                                       class="btn btn-sm btn-info" title="Détails">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="<c:url value='/produits/editer/${produit.id}'/>"
                                       class="btn btn-sm btn-warning" title="Modifier">
                                        <i class="bi bi-pencil"></i>
                                    </a>
                                    <button type="button" class="btn btn-sm btn-danger" title="Supprimer"
                                            onclick="confirmerSuppression(${produit.id})">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<!-- Pagination -->
<div class="card-footer">
    <div class="d-flex justify-content-between align-items-center">
        <div>
            Affichage de ${produits.numberOfElements} sur ${produits.totalElements} produits
        </div>

        <nav>
            <ul class="pagination mb-0">
                <!-- Première page -->
                <li class="page-item ${produits.first ? 'disabled' : ''}">
                    <a class="page-link" href="?page=0&size=${pageSize}&search=${search}">
                        <i class="bi bi-chevron-double-left"></i>
                    </a>
                </li>

                <!-- Page précédente -->
                <li class="page-item ${produits.first ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&size=${pageSize}&search=${search}">
                        <i class="bi bi-chevron-left"></i>
                    </a>
                </li>

                <!-- Pages -->
                <c:forEach begin="${Math.max(0, currentPage - 2)}"
                           end="${Math.min(produits.totalPages - 1, currentPage + 2)}"
                           var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&size=${pageSize}&search=${search}">
                                ${i + 1}
                        </a>
                    </li>
                </c:forEach>

                <!-- Page suivante -->
                <li class="page-item ${produits.last ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&size=${pageSize}&search=${search}">
                        <i class="bi bi-chevron-right"></i>
                    </a>
                </li>

                <!-- Dernière page -->
                <li class="page-item ${produits.last ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${produits.totalPages - 1}&size=${pageSize}&search=${search}">
                        <i class="bi bi-chevron-double-right"></i>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- Sélecteur de taille de page -->
        <div class="d-flex align-items-center">
            <label class="me-2">Afficher</label>
            <select class="form-select form-select-sm" style="width: auto;"
                    onchange="window.location.href='?page=0&size=' + this.value + '&search=${search}'">
                <option value="5" ${pageSize == 5 ? 'selected' : ''}>5</option>
                <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
            </select>
            <label class="ms-2">par page</label>
        </div>
    </div>
</div>


<!-- Modal de confirmation de suppression -->
<div class="modal fade" id="suppressionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Confirmation de suppression</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                Êtes-vous sûr de vouloir supprimer ce produit ?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                <button type="button" class="btn btn-danger" id="confirmDelete">Supprimer</button>
            </div>
        </div>
    </div>
</div>

<script>
    let produitASupprimer = null;

    function confirmerSuppression(produitId) {
        produitASupprimer = produitId;
        var suppressionModal = new bootstrap.Modal(document.getElementById('suppressionModal'));
        suppressionModal.show();
    }

    document.getElementById('confirmDelete').addEventListener('click', function() {
        if (produitASupprimer) {
            // Créer un formulaire dynamiquement
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '<c:url value="/produits/delete/"/>' + produitASupprimer;
            document.body.appendChild(form);
            form.submit();
        }
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
    // gérer la recherche avec pagination
    document.querySelector('form').addEventListener('submit', function(e) {
        e.preventDefault();

        const search = document.querySelector('input[name="search"]').value;
        window.location.href = '?page=0&size=${pageSize}&search=' + encodeURIComponent(search);
    });
</script>