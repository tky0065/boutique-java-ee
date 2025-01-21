
// Graphiques
let ventesChart;
let stockChart;

document.addEventListener('DOMContentLoaded', function() {
    initializeCharts();
    loadChartData();
    setupRefreshTimer();
    // Toggle Sidebar
    const sidebarToggle = document.getElementById('sidebarToggle');
    const sidebar = document.querySelector('.sidebar');
    const mainContent = document.querySelector('.main-content');

    if (sidebarToggle) {
        sidebarToggle.addEventListener('click', function(e) {
            e.preventDefault();
            document.body.classList.toggle('sidebar-toggled');
            sidebar.classList.toggle('active');

            // Sauvegarder l'état dans localStorage
            localStorage.setItem('sidebarToggled',
                document.body.classList.contains('sidebar-toggled'));
        });
    }

    // Appliquer l'état sauvegardé du sidebar
    if (localStorage.getItem('sidebarToggled') === 'true') {
        document.body.classList.add('sidebar-toggled');
        sidebar.classList.add('active');
    }

    // Fermer le sidebar sur mobile lors d'un clic en dehors
    document.addEventListener('click', function(e) {
        if (window.innerWidth < 768) {
            if (!sidebar.contains(e.target) &&
                !sidebarToggle.contains(e.target) &&
                sidebar.classList.contains('active')) {
                document.body.classList.remove('sidebar-toggled');
                sidebar.classList.remove('active');
            }
        }
    });

    // Gestion des sous-menus
    const dropdownToggles = document.querySelectorAll('.sidebar .nav-link[data-bs-toggle="collapse"]');
    dropdownToggles.forEach(toggle => {
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            const submenu = document.querySelector(toggle.getAttribute('href'));
            if (submenu) {
                toggle.classList.toggle('collapsed');
                submenu.classList.toggle('show');
            }
        });
    });

    // Gestion des alertes auto-fermantes
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        if (!alert.classList.contains('alert-persistent')) {
            setTimeout(() => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }, 5000);
        }
    });

    // Activation des tooltips
    const tooltipTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="tooltip"]')
    );
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Activer les popovers
    const popoverTriggerList = [].slice.call(
        document.querySelectorAll('[data-bs-toggle="popover"]')
    );
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });

    // Gestion du scroll
    window.addEventListener('scroll', function() {
        const scrollButton = document.getElementById('scrollToTop');
        if (scrollButton) {
            if (window.pageYOffset > 100) {
                scrollButton.style.display = "block";
            } else {
                scrollButton.style.display = "none";
            }
        }
    });

    // Bouton retour en haut
    const scrollToTop = document.getElementById('scrollToTop');
    if (scrollToTop) {
        scrollToTop.addEventListener('click', function(e) {
            e.preventDefault();
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }


});

function initializeCharts() {
    // Graphique des ventes
    const ventesCtx = document.getElementById('ventesChart').getContext('2d');
    ventesChart = new Chart(ventesCtx, {
        type: 'line',
        data: {
            labels: [],
            datasets: [{
                label: 'Ventes',
                borderColor: '#4e73df',
                data: []
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return value.toLocaleString() + ' FCFA';
                        }
                    }
                }
            }
        }
    });

    // Graphique du stock
    const stockCtx = document.getElementById('stockChart').getContext('2d');
    stockChart = new Chart(stockCtx, {
        type: 'bar',
        data: {
            labels: [],
            datasets: [{
                label: 'Stock',
                backgroundColor: '#36b9cc',
                data: []
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

function loadChartData() {
    // Charger les données des ventes
    fetch('/dashboard/chart-data?type=ventes')
        .then(response => response.json())
        .then(data => {
            updateVentesChart(data);
        });

    // Charger les données des produits en alerte
    fetch('/dashboard/alertes')
        .then(response => response.json())
        .then(data => {
            updateStockChart(data);
            updateAlertesTable(data);
        });
}

function updateVentesChart(data) {
    ventesChart.data.labels = data.labels;
    ventesChart.data.datasets[0].data = data.ventes;
    ventesChart.update();
}

function updateStockChart(data) {
    stockChart.data.labels = data.map(p => p.nom);
    stockChart.data.datasets[0].data = data.map(p => p.quantiteStock);
    stockChart.update();
}

function updateAlertesTable(alertes) {
    const tbody = document.querySelector('#alertesTable tbody');
    tbody.innerHTML = '';

    alertes.forEach(produit => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${produit.nom}</td>
            <td><span class="badge bg-danger">${produit.quantiteStock}</span></td>
            <td>${produit.seuilAlerte}</td>
            <td>
                <a href="/livraisons/nouvelle?produitId=${produit.id}" 
                   class="btn btn-sm btn-primary">Commander</a>
            </td>
        `;
        tbody.appendChild(tr);
    });
}

function refreshDashboard() {
    loadChartData();

    fetch('/dashboard/refresh-stats')
        .then(response => response.json())
        .then(data => {
            document.getElementById('ventesJourTotal').textContent =
                data.ventesJourTotal.toLocaleString() + ' FCFA';
            document.getElementById('livraisonsJourTotal').textContent =
                data.livraisonsJourTotal.toLocaleString() + ' FCFA';
            document.getElementById('nombreProduitsAlerte').textContent =
                data.nombreProduitsAlerte;
        });
}

function setupRefreshTimer() {
    setInterval(refreshDashboard, 300000); // 5 minutes


}
// Fonctions utilitaires pour le dashboard
const DashboardUtils = {
    // Formater les nombres en format monétaire FCFA
    formatMoney: function(amount) {
        return new Intl.NumberFormat('fr-FR').format(amount) + ' FCFA';
    },

    // Formater les dates
    formatDate: function(date) {
        return new Intl.DateTimeFormat('fr-FR', {
            day: '2-digit',
            month: '2-digit',
            year: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        }).format(new Date(date));
    },

    // Afficher une notification
    showNotification: function(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} alert-dismissible fade show`;
        notification.innerHTML = `
            ${message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        `;

        const container = document.querySelector('.notifications-container') ||
            document.createElement('div');
        if (!document.querySelector('.notifications-container')) {
            container.className = 'notifications-container';
            document.body.appendChild(container);
        }

        container.appendChild(notification);
        setTimeout(() => notification.remove(), 5000);
    }
};

// Exporter les utilitaires pour une utilisation globale
window.DashboardUtils = DashboardUtils;