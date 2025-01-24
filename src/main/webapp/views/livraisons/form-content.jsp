<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid mt-4 mb-4">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>
    <div class="card shadow">
        <div class="card-header">
            <h3 class="card-title mb-0">Nouvelle Livraison</h3>
        </div>
        <div class="card-body">
            <form id="livraisonForm"  action="<c:url value='${isEdition ? "/livraisons/editer/".concat(livraison.id) : "/livraisons/nouvelle"}'/>" method="post">
                <!-- Information fournisseur -->
                <div class="mb-4">
                    <label for="nomFournisseur" class="form-label">Fournisseur</label>
                    <input type="text" class="form-control" id="nomFournisseur"
                           name="nomFournisseur" required
                           placeholder="Nom du fournisseur"
                           value="${livraison.nomFournisseur}">
                </div>
                <!-- Si c'est une édition, ajoutons l'ID -->
                <c:if test="${isEdition}">
                    <input type="hidden" name="id" value="${livraison.id}">
                </c:if>
                <!-- Tableau des produits -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Produits livrés</h5>
                        <button type="button" class="btn btn-primary btn-sm" id="ajouterProduit">
                            <i class="bi bi-plus-lg"></i> Ajouter un produit
                        </button>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table" id="produitsTable">
                                <thead>
                                <tr>
                                    <th>Produit</th>
                                    <th>Prix unitaire</th>
                                    <th>Quantité</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody></tbody>
                                <tfoot>
                                <tr>
                                    <td colspan="3" class="text-end">
                                        <strong>Total Livraison</strong>
                                    </td>
                                    <td><span id="totalGeneral">0 FCFA</span></td>
                                    <td></td>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="text-end">
                    <a href="<c:url value='/livraisons'/>" class="btn btn-secondary">
                        <i class="bi bi-x-circle"></i> Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg"></i> Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Template pour les lignes de produits -->
<template id="ligneProduitTemplate">
    <tr>
        <td>
            <select class="form-select produit-select" name="lignesLivraison[{index}].produitId" required>
                <option value="">Sélectionner un produit</option>
                <c:forEach items="${produits}" var="produit">
                    <option value="${produit.id}"
                            data-prix="${produit.prixUnitaire}">
                            ${produit.nom}
                    </option>
                </c:forEach>
            </select>
        </td>
        <td>
            <input type="number" class="form-control prix-unitaire"
                   name="lignesLivraison[{index}].prixUnitaire"
                   step="100" min="0" required>
        </td>
        <td>
            <input type="number" class="form-control quantite"
                   name="lignesLivraison[{index}].quantite"
                   min="1" required>
        </td>
        <td>
            <span class="ligne-total">0 FCFA</span>
        </td>
        <td>
            <button type="button" class="btn btn-danger btn-sm btn-supprimer">
                <i class="bi bi-trash"></i>
            </button>
        </td>
    </tr>
</template>

<script>


    // Déclaration des variables globales
    let indexProduit = 0;

    // Fonction d'initialisation des lignes existantes
    function initExistingLines() {
        const tbody = document.querySelector('#produitsTable tbody');
        tbody.innerHTML = ''; // Vider le tbody

        <c:if test="${not empty livraison.lignesLivraison}">
        console.log("Initializing existing lines");
        <c:forEach items="${livraison.lignesLivraison}" var="ligne" varStatus="status">
        addNewLine({
            produitId: '${ligne.produitId}',
            prixUnitaire: '${ligne.prixUnitaire}',
            quantite: '${ligne.quantite}',
            index: ${status.index}
        });
        </c:forEach>
        indexProduit = ${livraison.lignesLivraison.size()};
        </c:if>
    }

    // Fonction pour ajouter une nouvelle ligne
    function addNewLine(data = null) {
        const template = document.getElementById('ligneProduitTemplate');
        const tbody = document.querySelector('#produitsTable tbody');
        const clone = template.content.cloneNode(true);
        const row = clone.querySelector('tr');

        // Remplacer tous les {index}
        row.innerHTML = row.innerHTML.replaceAll('{index}', data ? data.index : indexProduit);

        tbody.appendChild(clone);
        const newRow = tbody.lastElementChild;

        if (data) {
            // Sélectionner le produit
            const select = newRow.querySelector('.produit-select');
            select.value = data.produitId;

            // Définir le prix unitaire
            const prixInput = newRow.querySelector('.prix-unitaire');
            prixInput.value = data.prixUnitaire;

            // Définir la quantité
            const quantiteInput = newRow.querySelector('.quantite');
            quantiteInput.value = data.quantite;
        }

        attachEventHandlers(newRow);
        updateLigneTotal(newRow);

        if (!data) {
            indexProduit++;
        }

        return newRow;
    }
    // Mettre à jour le total général
    function updateTotal() {
        let total = 0;
        document.querySelectorAll('.ligne-total').forEach(el => {
            total += parseMoneyFCFA(el.textContent);
        });
        document.getElementById('totalGeneral').textContent = formatMoneyFCFA(total);
    }
    // Gestionnaire d'événement pour le bouton Ajouter
    document.getElementById('ajouterProduit').addEventListener('click', function() {
        addNewLine();
        updateTotal();
    });

    // Attacher les événements aux éléments d'une ligne
    function attachEventHandlers(row) {
        const select = row.querySelector('.produit-select');
        const prixInput = row.querySelector('.prix-unitaire');
        const quantiteInput = row.querySelector('.quantite');
        const btnSupprimer = row.querySelector('.btn-supprimer');

        select.addEventListener('change', function() {
            const option = this.selectedOptions[0];
            if (option && option.dataset.prix) {
                prixInput.value = option.dataset.prix;
                updateLigneTotal(row);
            }
        });

        [prixInput, quantiteInput].forEach(input => {
            input.addEventListener('input', () => updateLigneTotal(row));
        });

        btnSupprimer.addEventListener('click', function() {
            row.remove();
            updateTotal();
        });
    }

    // Mettre à jour le total d'une ligne
    function updateLigneTotal(row) {
        const prix = parseFloat(row.querySelector('.prix-unitaire').value) || 0;
        const quantite = parseInt(row.querySelector('.quantite').value) || 0;
        const total = prix * quantite;
        row.querySelector('.ligne-total').textContent = formatMoneyFCFA(total);
        updateTotal();
    }

    // Formater un montant en FCFA
    function formatMoneyFCFA(amount) {
        return new Intl.NumberFormat('fr-FR').format(amount) + ' FCFA';
    }

    // Parser un montant en FCFA
    function parseMoneyFCFA(amount) {
        return parseFloat(amount.replace(/[^\d,-]/g, '').replace(',', '.')) || 0;
    }

    // Validation du formulaire
    document.getElementById('livraisonForm').addEventListener('submit', function(e) {
        const lignes = document.querySelectorAll('#produitsTable tbody tr');
        if (lignes.length === 0) {
            e.preventDefault();
            alert('Veuillez ajouter au moins un produit à la livraison');
            return;
        }

        let isValid = true;
        lignes.forEach(ligne => {
            const produitId = ligne.querySelector('.produit-select').value;
            const prix = ligne.querySelector('.prix-unitaire').value;
            const quantite = ligne.querySelector('.quantite').value;

            if (!produitId || !prix || !quantite) {
                isValid = false;
            }
        });

        if (!isValid) {
            e.preventDefault();
            alert('Veuillez remplir tous les champs pour chaque produit');
        }
    });
    // Initialisation au chargement de la page
    document.addEventListener('DOMContentLoaded', function() {
        console.log("Page loaded, isEdition: ${isEdition}");
        if (${isEdition == true}) {
            initExistingLines();
        }
        updateTotal();

        // Auto-dismiss alerts
        setTimeout(function () {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function (alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>