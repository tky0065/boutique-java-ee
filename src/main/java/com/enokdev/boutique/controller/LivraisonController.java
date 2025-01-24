package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.LivraisonDto;
import com.enokdev.boutique.dto.LivraisonResponse;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.service.LivraisonService;
import com.enokdev.boutique.service.ProduitService;
import com.enokdev.boutique.utils.RequiredPermission;
import com.enokdev.boutique.utils.RequiredRole;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/livraisons")
@RequiredArgsConstructor
public class LivraisonController {

    private final LivraisonService livraisonService;
    private final ProduitService produitService;

    @GetMapping
    public String listeLivraisons(Model model,
                                  @RequestParam(required = false, name = "dateDebut") LocalDate dateDebut,
                                  @RequestParam(required = false,name = "dateFin") LocalDate dateFin,
                                  @RequestParam(required = false,name = "fournisseur") String fournisseur) {
        if (dateDebut != null && dateFin != null) {
            LocalDateTime debut = dateDebut.atStartOfDay();
            LocalDateTime fin = dateFin.atTime(23, 59, 59);
            model.addAttribute("livraisons", livraisonService.getLivraisonsParPeriode(debut, fin));
        } else {
            model.addAttribute("livraisons", livraisonService.getAllLivraisons());
        }
        model.addAttribute("dateDebut", dateDebut);
        model.addAttribute("dateFin", dateFin);
        model.addAttribute("fournisseur", fournisseur);
        return "livraisons/liste";
    }

    @GetMapping("/nouvelle")
    public String nouvelleLivraisonForm(Model model) {
        model.addAttribute("livraison", new LivraisonDto());
        model.addAttribute("produits", produitService.getAllProduits());
        return "livraisons/form";
    }

    @PostMapping("/nouvelle")
    public String ajouterLivraison(@Valid @ModelAttribute("livraison") LivraisonDto livraisonDto,
                                   BindingResult result,
                                   HttpSession session,
                                   Model model,
                                   RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("produits", produitService.getAllProduits());
            return "livraisons/form";
        }

        try {
            Long userId = (Long) session.getAttribute("userId");
            livraisonDto.setUtilisateurId(userId);
            livraisonDto.setDateLivraison(LocalDateTime.now());

            LivraisonDto saved = livraisonService.saveLivraison(livraisonDto);
            redirectAttributes.addFlashAttribute("success", "Livraison enregistrée avec succès");
            return "redirect:/livraisons/" + saved.getId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de l'enregistrement de la livraison: " + e.getMessage());
            model.addAttribute("produits", produitService.getAllProduits());
            return "livraisons/form";
        }
    }

    @GetMapping("/{id}")
    public String detailLivraison(@PathVariable(name = "id") Long id, Model model) {
        try {
            model.addAttribute("livraison", livraisonService.getLivraisonById(id));
            return "livraisons/detail";
        } catch (Exception e) {
            return "redirect:/livraisons";
        }
    }

    @GetMapping("/editer/{id}")
    public String editerLivraisonForm(@PathVariable(name = "id") Long id, Model model) {
        try {

            LivraisonResponse livraison = livraisonService.getLivraisonById(id);
            model.addAttribute("livraison", livraison);
            model.addAttribute("produits", produitService.getAllProduits());
            model.addAttribute("isEdition", true);


            return "livraisons/form";
        } catch (Exception e) {
            return "redirect:/livraisons";
        }
    }

    @PostMapping("/editer/{id}")
    public String editerLivraison(@PathVariable(name = "id") Long id,
                                  @Valid @ModelAttribute("livraison") LivraisonDto livraisonDto,
                                  BindingResult result,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("produits", produitService.getAllProduits());
            return "livraisons/form";
        }

        try {
            Long userId = (Long) session.getAttribute("userId");
            livraisonDto.setUtilisateurId(userId);
            livraisonDto.setDateLivraison(LocalDateTime.now());

            LivraisonDto saved = livraisonService.updateLivraison(livraisonDto);
            redirectAttributes.addFlashAttribute("success", "Livraison enregistrée avec succès");

            return "redirect:/livraisons/" + saved.getId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la mise à jour de la livraison");
            return "redirect:/livraisons/editer/" + id;
        }
    }



    @RequiredPermission("LIVRAISON_SUPPRIMER")
    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @PostMapping("/delete/{id}")
    public String supprimerLivraison(@PathVariable(name = "id") Long id,
                                   RedirectAttributes redirectAttributes) {
        try {
            var  produict = livraisonService.getLivraisonById(id);
            if (produict != null) {
                livraisonService.deleteLivraison(id);
            }
            redirectAttributes.addFlashAttribute("success",
                    "Livraison supprimé avec succès");
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error",
                    "Livraison non trouvé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/livraisons";
    }


    @GetMapping("/imprimer/{id}")
    public String imprimerBonLivraison(@PathVariable(name = "id") Long id, Model model) {
        try {
            model.addAttribute("livraison", livraisonService.getLivraisonById(id));
            return "livraisons/imprimer";
        } catch (Exception e) {
            return "redirect:/livraisons";
        }
    }
}