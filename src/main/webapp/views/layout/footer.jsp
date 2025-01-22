<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .footer {
        background-color: #96989a; /* Couleur de fond sombre */
        color: #ffffff; /* Couleur de texte blanche */
        padding: 6px 0; /* Espacement interne */
        text-align: center; /* Centrage du contenu */
        font-size: 8px; /* Taille du texte */
        box-shadow: 0 -2px 3px rgba(0, 0, 0, 0.1); /* Ombre subtile */
        position: fixed; /* Collé en bas */
        bottom: 0;
        width: 100%;
        z-index: 1030;/* Toujours au-dessus des autres éléments */
    }

    .footer a {
        color: #ffdd57; /* Lien avec une couleur contrastante */
        text-decoration: none;
    }

    .footer a:hover {
        text-decoration: underline;
    }
</style>

<footer class="footer">
    <div class="container">
        <div>
            &copy; <script>document.write(new Date().getFullYear());</script>
            <span>Gestion Boutique</span>. Tous droits réservés.
            <br>
            <a href="#">Conditions d'utilisation</a> | <a href="#">Politique de confidentialité</a>
        </div>
    </div>
</footer>
