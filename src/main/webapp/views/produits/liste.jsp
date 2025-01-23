
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion Boutique - Produits</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<c:url value='/resources/css/dashboard.css'/>" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
        .pagination {
            margin-bottom: 0;
        }

        .page-link {
            padding: 0.5rem 0.75rem;
            font-size: 0.875rem;
        }

        .form-select-sm {
            padding-top: 0.25rem;
            padding-bottom: 0.25rem;
        }

        .card-footer {
            background-color: #f8f9fa;
            padding: 0.75rem 1.25rem;
        }
    </style>

</head>
<body>
<div class="dashboard-container">
    <!-- Sidebar -->
    <c:import url="../layout/sidebar.jsp"/>

    <div class="main-content">
        <!-- Header -->
        <c:import url="../layout/header.jsp"/>

        <!-- Main Content Area -->
        <div class="content-wrapper">
            <div class="container-fluid mb-5 mt-5">
                <c:import url="liste-content.jsp"/>
            </div>
        </div>

        <!-- Footer -->
        <div class=" "><c:import url="../layout/footer.jsp"/></div>
    </div>
</div>


<!-- Scripts -->

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>