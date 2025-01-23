package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.LivraisonDetailDto;
import com.enokdev.boutique.dto.ProduitDto;
import com.enokdev.boutique.dto.VenteDetailDto;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.service.LivraisonService;
import com.enokdev.boutique.service.ProduitService;
import com.enokdev.boutique.service.VenteService;
import com.enokdev.boutique.utils.RequiredPermission;
import com.enokdev.boutique.utils.RequiredRole;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.List;


@Controller
@RequestMapping("/produits")
@RequiredArgsConstructor
public class ProduitController {

    private final ProduitService produitService;
    private final VenteService venteService;
    private final LivraisonService livraisonService;

    @GetMapping("/liste")
    public String listeProduits(Model model,
                                @RequestParam(required = false, name = "search") String search) {
        if (search != null && !search.isEmpty()) {
            model.addAttribute("produits", produitService.rechercherParNom(search));
        } else {
            model.addAttribute("produits", produitService.getAllProduits());
        }
        return "produits/liste";
    }

    @RequiredPermission("PRODUIT_CREER")
    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @GetMapping("/nouveau")
    public String nouveauProduitForm(Model model) {
        model.addAttribute("produit", new ProduitDto());
        return "produits/form";
    }

    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @PostMapping("/nouveau")
    public String ajouterProduit(@Valid @ModelAttribute("produit") ProduitDto produitDto,
                                 BindingResult result,
                                 RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "produits/form";
        }

        try {
            produitService.saveProduit(produitDto);
            redirectAttributes.addFlashAttribute("success", "Produit ajouté avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'ajout du produit");
        }
        return "redirect:/produits/liste";
    }

    @GetMapping("/{id}")
    public String detailProduit(@PathVariable(name = "id") Long id, Model model) {
        try {
            ProduitDto produit = produitService.getProduitById(id);
            model.addAttribute("produit", produit);

            // Récupérer les ventes récentes pour ce produit
            LocalDateTime debut = LocalDateTime.now().minusDays(30); // 30 derniers jours
            LocalDateTime fin = LocalDateTime.now();

            List<VenteDetailDto> ventesRecentes = venteService.getVentesParProduit(id, debut, fin);

            List<LivraisonDetailDto> livraisonsRecentes = livraisonService.getLivraisonsParProduit(id, debut, fin);

            model.addAttribute("ventesRecentes", ventesRecentes);
            model.addAttribute("livraisonsRecentes", livraisonsRecentes);

            return "produits/detail";

        } catch (Exception e) {
            return "redirect:/produits/liste";
        }
    }



    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @GetMapping("/editer/{id}")
    public String editerProduitForm(@PathVariable(name = "id") Long id, Model model) {
        try {
            model.addAttribute("produit", produitService.getProduitById(id));
            return "produits/edite";
        } catch (Exception e) {
            return "redirect:/produits/liste";
        }
    }

    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @PostMapping("/editer/{id}")
    public String editerProduit(@PathVariable(name = "id") Long id,
                                @Valid @ModelAttribute("produit") ProduitDto produitDto,
                                BindingResult result,
                                RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "produits/edite";
        }

        try {
            produitService.updateProduit(id, produitDto);
            redirectAttributes.addFlashAttribute("success", "Produit mis à jour avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la mise à jour du produit");
        }
        return "redirect:/produits/liste";
    }

    @RequiredPermission("PRODUIT_SUPPRIMER")
    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @PostMapping("/delete/{id}")
    public String supprimerProduit(@PathVariable(name = "id") Long id,
                                    RedirectAttributes redirectAttributes) {
        try {
            var  produict = produitService.getProduitById(id);
            if (produict != null) {
                produitService.deleteProduit(id);
            }
            redirectAttributes.addFlashAttribute("success",
                    "Produit supprimé avec succès");
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error",
                    "Produit non trouvé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/produits/liste";
    }

    @GetMapping("/api/stock/{id}")
    @ResponseBody
    public ResponseEntity<Integer> getStock(@PathVariable(name = "id") Long id) {
        try {
            ProduitDto produit = produitService.getProduitById(id);
            return ResponseEntity.ok(produit.getQuantiteStock());
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
}
