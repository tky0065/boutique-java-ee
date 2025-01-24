<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid mt-4 mb-4">
    <!-- Messages flash -->
    <c:import url="../fragments/messages.jsp"/>

    <div class="card shadow">
        <div class="card-header">
            <h3 class="card-title mb-0">${isEdition ? 'Modifier' : 'Nouvelle'} Vente</h3>
        </div>
        <div class="card-body">
            <form id="venteForm" action="<c:url value='${isEdition ? "/ventes/editer/".concat(vente.id) : "/ventes/nouvelle"}'/>" method="post">
                <!-- Champs cachés -->
                <input type="hidden" name="utilisateurId" value="${sessionScope.userId}">
                <input type="hidden" name="montantTotal" id="montantTotalInput">
                <c:if test="${isEdition}">
                    <input type="hidden" name="id" value="${vente.id}">
                </c:if>

                <!-- Information client -->
                <div class="mb-4">
                    <label for="client" class="form-label">Client</label>
                    <input type="text" class="form-control" id="client" name="nomClient"
                           value="${vente.nomClient}"
                           placeholder="Nom du client">
                </div>

                <!-- Tableau des produits -->
                <div class="card mb-4">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">Produits</h5>
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
                                    <td colspan="3" class="text-end"><strong>Total</strong></td>
                                    <td><span id="totalGeneral">0 FCFA</span></td>
                                    <td></td>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

                <div class="text-end">
                    <a href="<c:url value='/ventes'/>" class="btn btn-secondary">
                        <i class="bi bi-x-circle"></i> Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg"></i> ${isEdition ? 'Modifier' : 'Enregistrer'}
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
            <select class="form-select produit-select" name="lignesVente[{index}].produitId" required>
                <option value="">Sélectionner un produit</option>
                <c:forEach items="${produits}" var="produit">
                    <option value="${produit.id}"
                            data-prix="${produit.prixUnitaire}"
                            data-stock="${produit.quantiteStock}">
                            ${produit.nom} (Stock: ${produit.quantiteStock})
                    </option>
                </c:forEach>
            </select>
        </td>
        <td>
            <input type="hidden" name="lignesVente[{index}].prixUnitaire" class="prix-unitaire-input">
            <input type="text" class="form-control-plaintext prix-unitaire" readonly>
        </td>
        <td>
            <input type="number" class="form-control quantite"
                   name="lignesVente[{index}].quantite"
                   min="1" required>
        </td>
        <td>
            <input type="hidden" name="lignesVente[{index}].montantTotal" class="montant-total-input">
            <span class="total">0 FCFA</span>
        </td>
        <td>
            <button type="button" class="btn btn-danger btn-sm supprimer">
                <i class="bi bi-trash"></i>
            </button>
        </td>
    </tr>
</template>


<script>
    let indexProduit = ${isEdition ? vente.lignesVente.size() : 0};

    function initExistingLines() {
        console.log("Initializing existing lines");
        const tbody = document.querySelector('#produitsTable tbody');
        tbody.innerHTML = ''; // Vider le tbody

        <c:if test="${not empty vente.lignesVente}">
        <c:forEach items="${vente.lignesVente}" var="ligne" varStatus="status">
        addNewLine({
            produitId: '${ligne.produitId}',
            prixUnitaire: '${ligne.prixUnitaire}',
            quantite: '${ligne.quantite}',
            index: ${status.index}
        });
        </c:forEach>
        </c:if>
    }

    function addNewLine(data = null) {
        const template = document.getElementById('ligneProduitTemplate');
        const tbody = document.querySelector('#produitsTable tbody');
        const clone = template.content.cloneNode(true);
        const row = clone.querySelector('tr');

        row.innerHTML = row.innerHTML.replaceAll('{index}', data ? data.index : indexProduit);
        tbody.appendChild(clone);
        const newRow = tbody.lastElementChild;

        if (data) {
            const select = newRow.querySelector('.produit-select');
            select.value = data.produitId;

            const prixInput = newRow.querySelector('.prix-unitaire');
            const prixHiddenInput = newRow.querySelector('.prix-unitaire-input');
            prixInput.value = data.prixUnitaire;
            prixHiddenInput.value = data.prixUnitaire;

            const quantiteInput = newRow.querySelector('.quantite');
            quantiteInput.value = data.quantite;
        }

        attachEventHandlers(newRow);
        updateLigneTotal(newRow);

        if (!data) indexProduit++;
        return newRow;
    }

    // Ajouter une ligne de produit
    document.getElementById('ajouterProduit').addEventListener('click', function() {
        const template = document.getElementById('ligneProduitTemplate');
        const tbody = document.querySelector('#produitsTable tbody');
        const clone = template.content.cloneNode(true);

        // Mettre à jour les indices
        clone.querySelector('tr').innerHTML = clone.querySelector('tr').innerHTML
            .replace(/{index}/g, indexProduit++);

        tbody.appendChild(clone);
        attachEventHandlers(tbody.lastElementChild);
        updateTotal();
    });

    // Attacher les événements aux éléments d'une ligne
    function attachEventHandlers(row) {
        const select = row.querySelector('.produit-select');
        const quantiteInput = row.querySelector('.quantite');
        const supprimerBtn = row.querySelector('.supprimer');

        select.addEventListener('change', function() {
            const option = this.selectedOptions[0];
            if (option) {
                const prix = option.dataset.prix;
                row.querySelector('.prix-unitaire').value = prix;
                updateLigneTotal(row);

                // Vérifier le stock disponible
                const stock = parseInt(option.dataset.stock);
                quantiteInput.max = stock;
            }
        });

        quantiteInput.addEventListener('input', () => updateLigneTotal(row));
        supprimerBtn.addEventListener('click', () => {
            row.remove();
            updateTotal();
        });
    }

    // Mettre à jour le total d'une ligne
    function updateLigneTotal(row) {
        const prix = parseFloat(row.querySelector('.prix-unitaire').value) || 0;
        const quantite = parseInt(row.querySelector('.quantite').value) || 0;
        const total = prix * quantite;
        // Mettre à jour les champs cachés
        row.querySelector('.prix-unitaire-input').value = prix;
        row.querySelector('.montant-total-input').value = total;


        row.querySelector('.total').textContent = formatMoney(total);
        updateTotal();
    }

    // Mettre à jour le total général
    function updateTotal() {
        let total = 0;
        document.querySelectorAll('.total').forEach(el => {
            total += parseMoney(el.textContent);
        });
        document.getElementById('totalGeneral').textContent = formatMoney(total);
        document.getElementById('montantTotalInput').value = total;
    }

    // Formater un montant en FCFA
    function formatMoney(amount) {
        return new Intl.NumberFormat('fr-FR').format(amount) + ' FCFA';
    }

    // Parser un montant en FCFA
    function parseMoney(amount) {
        return parseFloat(amount.replace(/[^\d,-]/g, '').replace(',', '.')) || 0;
    }


    // Validation du formulaire
    document.getElementById('venteForm').addEventListener('submit', function(e) {
        e.preventDefault(); // Empêcher la soumission par défaut
        console.log('Soumission du formulaire...');
        const formData = new FormData(this);
        console.log('Données du formulaire:', Object.fromEntries(formData));

        const lignes = document.querySelectorAll('#produitsTable tbody tr');
        if (lignes.length === 0) {
            alert('Veuillez ajouter au moins un produit à la vente');
            return;
        }

        // Vérifier que tous les champs requis sont remplis
        let isValid = true;
        lignes.forEach((ligne, index) => {
            const produitId = ligne.querySelector('select').value;
            const quantite = ligne.querySelector('.quantite').value;

            if (!produitId || !quantite) {
                isValid = false;
                alert(`Veuillez remplir tous les champs pour la ligne ${index + 1}`);
            }
        });

        if (isValid) {
            console.log('Formulaire valide, soumission...');
            this.submit();
        }
    });
    // Auto-dismiss alerts after 5 seconds
    document.addEventListener('DOMContentLoaded', function() {
        if (${isEdition == true}) {
            initExistingLines();
        }
        updateTotal();
        setTimeout(function () {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function (alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    });
</script>
