<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid p-3">
    <div class="row mb-3">
        <div class="col-md-6">
            <p><strong>Référence:</strong> #${vente.id}</p>
            <p><strong>Date:</strong> ${vente.dateVenteFormatted}</p>
        </div>
        <div class="col-md-6">
            <p><strong>Client:</strong> ${vente.nomClient}</p>
            <p><strong>Vendeur:</strong> ${vente.utilisateurNomComplet}</p>
        </div>
    </div>

    <div class="table-responsive">
        <table class="table table-sm">
            <thead>
            <tr>
                <th>Produit</th>
                <th class="text-end">Prix unitaire</th>
                <th class="text-center">Quantité</th>
                <th class="text-end">Total</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${vente.lignesVente}" var="ligne">
                <tr>
                    <td>${ligne.produit.nom}</td>
                    <td class="text-end">
                        <fmt:formatNumber value="${ligne.prixUnitaire}" pattern="#,##0"/> FCFA
                    </td>
                    <td class="text-center">${ligne.quantite}</td>
                    <td class="text-end">
                        <fmt:formatNumber value="${ligne.montantTotal}" pattern="#,##0"/> FCFA
                    </td>
                </tr>
            </c:forEach>
            <tr>
                <td colspan="3" class="text-end"><strong>Total</strong></td>
                <td class="text-end">
                    <strong>
                        <fmt:formatNumber value="${vente.montantTotal}" pattern="#,##0"/> FCFA
                    </strong>
                </td>
            </tr>
            </tbody>
        </table>
    </div>
</div>