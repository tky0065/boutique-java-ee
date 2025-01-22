<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid">
    <!-- En-tête -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 mb-0">Liste des Livraisons</h1>
        <a href="<c:url value='/livraisons/nouvelle'/>" class="btn btn-primary">
            <i class="bi bi-plus-lg"></i> Nouvelle Livraison
        </a>
    </div>

    <!-- Filtres -->
    <div class="card shadow mb-4">
        <div class="card-body">
            <form method="get" class="row g-3">
                <div class="col-md-3">
                    <label for="dateDebut" class="form-label">Date début</label>
                    <input type="date" class="form-control" id="dateDebut" name="dateDebut"
                           value="${dateDebut}">
                </div>
                <div class="col-md-3">
                    <label for="dateFin" class="form-label">Date fin</label>
                    <input type="date" class="form-control" id="dateFin" name="dateFin"
                           value="${dateFin}">
                </div>
                <div class="col-md-4">
                    <label for="fournisseur" class="form-label">Fournisseur</label>
                    <input type="text" class="form-control" id="fournisseur" name="fournisseur"
                           value="${fournisseur}" placeholder="Nom du fournisseur">
                </div>
                <div class="col-md-2">
                    <label class="form-label d-block">&nbsp;</label>
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="bi bi-search"></i> Filtrer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Liste des livraisons -->
    <div class="card shadow">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>N° Livraison</th>
                        <th>Date</th>
                        <th>Fournisseur</th>
                        <th class="text-end">Montant Total</th>
                        <th>Réceptionné par</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${livraisons}" var="livraison">
                        <tr>
                            <td>${livraison.id}</td>
                            <td>
                                    ${livraison.dateLivraisonFormatted}
                            </td>
                            <td>${livraison.nomFournisseur}</td>
                            <td class="text-end">
                                <fmt:formatNumber value="${livraison.montantTotal}" pattern="#,##0"/> FCFA
                            </td>
                            <td>${livraison.utilisateurNomComplet} </td>
                            <td>
                                <div class="btn-group">
                                    <a href="<c:url value='/livraisons/${livraison.id}'/>"
                                       class="btn btn-sm btn-info" title="Détails">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    <a href="<c:url value='/livraisons/imprimer/${livraison.id}'/>"
                                       class="btn btn-sm btn-secondary" title="Imprimer">
                                        <i class="bi bi-printer"></i>
                                    </a>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Validation des dates
        const formFiltre = document.querySelector('form');
        formFiltre.addEventListener('submit', function(e) {
            const dateDebut = document.getElementById('dateDebut').value;
            const dateFin = document.getElementById('dateFin').value;

            if (dateDebut && dateFin) {
                if (dateDebut > dateFin) {
                    e.preventDefault();
                    alert('La date de début doit être antérieure à la date de fin');
                }
            }
        });
    });
</script>