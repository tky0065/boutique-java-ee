package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.ProduitDto;
import com.enokdev.boutique.service.ProduitService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;



@Controller
@RequestMapping("/produits")
@RequiredArgsConstructor
public class ProduitController {

    private final ProduitService produitService;

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

    @GetMapping("/nouveau")
    public String nouveauProduitForm(Model model) {
        model.addAttribute("produit", new ProduitDto());
        return "produits/form";
    }

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
            model.addAttribute("produit", produitService.getProduitById(id));
            return "produits/detail";
        } catch (Exception e) {
            return "redirect:/produits";
        }
    }

    @GetMapping("/editer/{id}")
    public String editerProduitForm(@PathVariable Long id, Model model) {
        try {
            model.addAttribute("produit", produitService.getProduitById(id));
            return "produits/form";
        } catch (Exception e) {
            return "redirect:/produits";
        }
    }

    @PostMapping("/editer/{id}")
    public String editerProduit(@PathVariable Long id,
                                @Valid @ModelAttribute("produit") ProduitDto produitDto,
                                BindingResult result,
                                RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "produits/form";
        }

        try {
            produitService.updateProduit(id, produitDto);
            redirectAttributes.addFlashAttribute("success", "Produit mis à jour avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la mise à jour du produit");
        }
        return "redirect:/produits";
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> supprimerProduit(@PathVariable Long id) {
        try {
            produitService.deleteProduit(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.badRequest().build();
        }
    }

    @GetMapping("/api/stock/{id}")
    @ResponseBody
    public ResponseEntity<Integer> getStock(@PathVariable Long id) {
        try {
            ProduitDto produit = produitService.getProduitById(id);
            return ResponseEntity.ok(produit.getQuantiteStock());
        } catch (Exception e) {
            return ResponseEntity.notFound().build();
        }
    }
}
