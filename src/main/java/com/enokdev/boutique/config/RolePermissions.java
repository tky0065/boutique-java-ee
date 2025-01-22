package com.enokdev.boutique.config;

import com.enokdev.boutique.model.Utilisateur;
import org.springframework.stereotype.Component;

import java.util.*;

@Component
public class RolePermissions {
    private static final Map<Utilisateur.Role, Set<String>> PERMISSIONS = new HashMap<>();

    static {
        // Permissions ADMIN
        Set<String> adminPerms = new HashSet<>(Arrays.asList(
                "VENTE_LIRE", "VENTE_CREER", "VENTE_MODIFIER", "VENTE_SUPPRIMER",
                "PRODUIT_LIRE", "PRODUIT_CREER", "PRODUIT_MODIFIER", "PRODUIT_SUPPRIMER",
                "LIVRAISON_LIRE", "LIVRAISON_CREER", "LIVRAISON_MODIFIER", "LIVRAISON_SUPPRIMER",
                "UTILISATEUR_LIRE", "UTILISATEUR_CREER", "UTILISATEUR_MODIFIER", "UTILISATEUR_SUPPRIMER",
                "RAPPORT_LIRE"
        ));
        PERMISSIONS.put(Utilisateur.Role.ADMIN, adminPerms);

        // Permissions VENDEUR
        Set<String> vendeurPerms = new HashSet<>(Arrays.asList(
                "VENTE_LIRE", "VENTE_CREER",
                "PRODUIT_LIRE"
        ));
        PERMISSIONS.put(Utilisateur.Role.VENDEUR, vendeurPerms);

        // Permissions GESTIONNAIRE_STOCK
        Set<String> gestStockPerms = new HashSet<>(Arrays.asList(
                "PRODUIT_LIRE", "PRODUIT_MODIFIER",
                "LIVRAISON_LIRE", "LIVRAISON_CREER", "LIVRAISON_MODIFIER"
        ));
        PERMISSIONS.put(Utilisateur.Role.GESTIONNAIRE_STOCK, gestStockPerms);
    }

    public boolean hasPermission(Utilisateur.Role role, String permission) {
        Set<String> rolePerms = PERMISSIONS.get(role);
        return rolePerms != null && rolePerms.contains(permission);
    }
}
