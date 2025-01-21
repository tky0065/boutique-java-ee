<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<div class="container-fluid">
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
                <div class="col-md-6">
                    <div class="input-group">
                        <input type="text" class="form-control" name="search"
                               placeholder="Rechercher un produit..." value="${param.search}">
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
                    <c:forEach items="${produits}" var="produit">
                        <tr>
                            <td>${produit.nom}</td>
                            <td>${produit.description}</td>
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
                                    <a href="<c:url value='/produits/${produit.id}'/>"
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
    const modal = new bootstrap.Modal(document.getElementById('suppressionModal'));

    function confirmerSuppression(produitId) {
        produitASupprimer = produitId;
        modal.show();
    }

    document.getElementById('confirmDelete').addEventListener('click', function() {
        if (produitASupprimer) {
            fetch(`/produits/${produitASupprimer}`, { method: 'DELETE' })
                .then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Erreur lors de la suppression du produit');
                    }
                })
                .catch(error => {
                    console.error('Erreur:', error);
                    alert('Erreur lors de la suppression du produit');
                });
        }
        modal.hide();
    });
</script>