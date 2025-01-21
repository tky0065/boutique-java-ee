
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>
<%--<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>--%>

<%--<!DOCTYPE html>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <meta charset="UTF-8">--%>
<%--    <title>Ticket de Caisse #${vente.id}</title>--%>
<%--    <style>--%>
<%--        body {--%>
<%--            font-family: monospace;--%>
<%--            font-size: 12px;--%>
<%--            margin: 20px;--%>
<%--            padding: 0;--%>
<%--        }--%>
<%--        .ticket-container {--%>
<%--            width: 300px;--%>
<%--            margin: 0 auto;--%>
<%--            padding: 10px;--%>
<%--            border: 1px dashed #ccc;--%>
<%--        }--%>
<%--        .center {--%>
<%--            text-align: center;--%>
<%--        }--%>
<%--        .bold {--%>
<%--            font-weight: bold;--%>
<%--        }--%>
<%--        .separator {--%>
<%--            border-top: 1px dashed #000;--%>
<%--            margin: 5px 0;--%>
<%--        }--%>
<%--        .item {--%>
<%--            display: flex;--%>
<%--            justify-content: space-between;--%>
<%--            margin: 5px 0;--%>
<%--        }--%>
<%--        .total {--%>
<%--            font-size: 14px;--%>
<%--            font-weight: bold;--%>
<%--            margin-top: 10px;--%>
<%--        }--%>
<%--        @media print {--%>
<%--            body {--%>
<%--                margin: 0;--%>
<%--            }--%>
<%--            .ticket-container {--%>
<%--                border: none;--%>
<%--            }--%>
<%--            .no-print {--%>
<%--                display: none;--%>
<%--            }--%>
<%--        }--%>
<%--    </style>--%>
<%--</head>--%>
<%--<body>--%>
<%--<div class="ticket-container">--%>
<%--    <div class="center bold">--%>
<%--        <h2>BOUTIQUE</h2>--%>
<%--        <p>Ticket de Caisse</p>--%>
<%--    </div>--%>

<%--    <div class="separator"></div>--%>

<%--    <div class="item">--%>
<%--        <span>N° Ticket:</span>--%>
<%--        <span>#${vente.id}</span>--%>
<%--    </div>--%>
<%--    <div class="item">--%>
<%--        <span>Date:</span>--%>
<%--        <span>--%>
<%--                <fmt:formatDate value="${vente.dateVente}"--%>
<%--                                pattern="dd/MM/yyyy HH:mm:ss"/>--%>
<%--            </span>--%>
<%--    </div>--%>
<%--    <div class="item">--%>
<%--        <span>Vendeur:</span>--%>
<%--        <span>${vente.utilisateur.nom}</span>--%>
<%--    </div>--%>

<%--    <div class="separator"></div>--%>

<%--    <c:forEach items="${vente.lignesVente}" var="ligne">--%>
<%--        <div class="item">--%>
<%--            <span>${ligne.produit.nom}</span>--%>
<%--            <span>--%>
<%--                    ${ligne.quantite} x--%>
<%--                    <fmt:formatNumber value="${ligne.prixUnitaire}"--%>
<%--                                      pattern="#,##0 FCFA"/>--%>
<%--                </span>--%>
<%--        </div>--%>
<%--        <div class="item">--%>
<%--            <span></span>--%>
<%--            <span>--%>
<%--                    <fmt:formatNumber value="${ligne.montantTotal}"--%>
<%--                                      pattern="#,##0 FCFA"/>--%>
<%--                </span>--%>
<%--        </div>--%>
<%--    </c:forEach>--%>

<%--    <div class="separator"></div>--%>

<%--    <div class="item total">--%>
<%--        <span>TOTAL:</span>--%>
<%--        <span>--%>
<%--                <fmt:formatNumber value="${vente.montantTotal}"--%>
<%--                                  pattern="#,##0 FCFA"/>--%>
<%--            </span>--%>
<%--    </div>--%>

<%--    <div class="separator"></div>--%>

<%--    <div class="center">--%>
<%--        <p>Merci de votre visite !</p>--%>
<%--        <p>À bientôt !</p>--%>
<%--    </div>--%>
<%--</div>--%>

<%--<div class="no-print center" style="margin-top: 20px;">--%>
<%--    <button onclick="window.print()">Imprimer</button>--%>
<%--    <button onclick="window.close()">Fermer</button>--%>
<%--</div>--%>

<%--<script>--%>
<%--    // Impression automatique à l'ouverture--%>
<%--    window.onload = function() {--%>
<%--        if(!window.location.search.includes('noprint')) {--%>
<%--            window.print();--%>
<%--        }--%>
<%--    };--%>
<%--</script>--%>
<%--</body>--%>
<%--</html>--%>