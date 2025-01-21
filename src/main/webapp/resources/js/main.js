
// Fonction de formatage monétaire en FCFA
function formatMoney(amount) {
    return new Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
    }).format(amount) + ' FCFA';
}

// Formatage des nombres en format monétaire

function formatNumber(number) {
    return new Intl.NumberFormat('fr-FR', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
    }).format(number);
}
// Formatage des dates
function formatDate(date) {
    return new Intl.DateTimeFormat('fr-FR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    }).format(new Date(date));
}

// Gestion des formulaires dynamiques (ventes et livraisons)
class DynamicForm {
    constructor(options) {
        this.options = {
            tableId: '',
            addButtonId: '',
            templateId: '',
            onCalculate: null,
            ...options
        };

        this.index = 0;
        this.init();
    }

    init() {
        const addButton = document.getElementById(this.options.addButtonId);
        if (addButton) {
            addButton.addEventListener('click', () => this.addRow());
        }

        // Initialiser le calcul total si des lignes existent
        this.calculateTotal();
    }

    addRow() {
        const template = document.getElementById(this.options.templateId);
        const tbody = document.querySelector(`#${this.options.tableId} tbody`);

        if (template && tbody) {
            const clone = template.content.cloneNode(true);
            this.updateIndexes(clone, this.index++);

            // Ajouter les gestionnaires d'événements
            this.attachRowEvents(clone);

            tbody.appendChild(clone);
            this.calculateTotal();
        }
    }

    updateIndexes(element, index) {
        element.querySelectorAll('[name*="[{index}]"]').forEach(input => {
            input.name = input.name.replace('{index}', index);
        });
    }

    attachRowEvents(row) {
        // Gestionnaire pour le bouton de suppression
        const deleteButton = row.querySelector('.delete-row');
        if (deleteButton) {
            deleteButton.addEventListener('click', (e) => {
                const tr = e.target.closest('tr');
                if (tr) {
                    tr.remove();
                    this.calculateTotal();
                }
            });
        }

        // Gestionnaires pour les champs de calcul
        const quantityInput = row.querySelector('.quantity-input');
        const priceInput = row.querySelector('.price-input');

        [quantityInput, priceInput].forEach(input => {
            if (input) {
                input.addEventListener('change', () => this.calculateTotal());
            }
        });
    }

    calculateTotal() {
        const rows = document.querySelectorAll(`#${this.options.tableId} tbody tr`);
        let total = 0;

        rows.forEach(row => {
            const quantity = parseFloat(row.querySelector('.quantity-input')?.value || 0);
            const price = parseFloat(row.querySelector('.price-input')?.value || 0);
            const subtotal = quantity * price;

            // Mettre à jour le sous-total de la ligne
            row.querySelector('.subtotal')?.textContent = formatMoney(subtotal);

            total += subtotal;
        });

        // Mettre à jour le total général
        const totalElement = document.getElementById('total');
        if (totalElement) {
            totalElement.textContent = formatMoney(total);
        }

        // Appeler le callback personnalisé si défini
        if (this.options.onCalculate) {
            this.options.onCalculate(total);
        }
    }
}

// Gestion des alertes
class AlertManager {
    static show(message, type = 'success', duration = 3000) {
        const alertDiv = document.createElement('div');
        alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
        alertDiv.setAttribute('role', 'alert');

        alertDiv.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;

        const container = document.querySelector('.alert-container') || document.body;
        container.appendChild(alertDiv);

        if (duration > 0) {
            setTimeout(() => {
                alertDiv.remove();
            }, duration);
        }
    }
}

// Initialisation des éléments interactifs
document.addEventListener('DOMContentLoaded', function() {
    // Initialiser les tooltips Bootstrap
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.forEach(function(tooltipTriggerEl) {
        new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialiser les formulaires dynamiques si nécessaire
    if (document.getElementById('venteForm')) {
        new DynamicForm({
            tableId: 'tableProduits',
            addButtonId: 'ajouterProduit',
            templateId: 'produit-template'
        });
    }

    if (document.getElementById('livraisonForm')) {
        new DynamicForm({
            tableId: 'tableLivraison',
            addButtonId: 'ajouterProduit',
            templateId: 'produit-template'
        });
    }

    // Gérer la recherche en temps réel
    const searchInput = document.querySelector('.search-input');
    if (searchInput) {
        let timeout = null;
        searchInput.addEventListener('input', function(e) {
            clearTimeout(timeout);
            timeout = setTimeout(() => {
                const searchForm = this.closest('form');
                if (searchForm) {
                    searchForm.submit();
                }
            }, 500);
        });
    }
});

// Gestion du ticket de caisse
class TicketManager {
    static preview(venteId) {
        window.open(`/tickets/${venteId}/preview`, 'TicketPreview',
            'width=400,height=600,scrollbars=yes');
    }

    static download(venteId) {
        window.location.href = `/tickets/${venteId}`;
    }

    static print(venteId) {
        fetch(`/tickets/${venteId}/preview`)
            .then(response => response.text())
            .then(text => {
                const printWindow = window.open('', 'PrintTicket',
                    'width=400,height=600');
                printWindow.document.write(`
                    <html>
                        <head>
                            <title>Ticket de caisse</title>
                            <style>
                                body {
                                    font-family: monospace;
                                    font-size: 12px;
                                    white-space: pre;
                                    margin: 20px;
                                }
                            </style>
                        </head>
                        <body>
                            ${text.replace(/\n/g, '<br>')}
                            <script>
                                window.onload = function() {
                                    window.print();
                                    setTimeout(function() {
                                        window.close();
                                    }, 500);
                                };
                            </script>
                        </body>
                    </html>
                `);
            });
    }
}