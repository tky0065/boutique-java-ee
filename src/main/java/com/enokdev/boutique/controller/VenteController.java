package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.LivraisonDto;
import com.enokdev.boutique.dto.LivraisonResponse;
import com.enokdev.boutique.dto.VenteDto;
import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.service.ProduitService;
import com.enokdev.boutique.service.TicketService;
import com.enokdev.boutique.service.VenteService;
import com.enokdev.boutique.utils.RequiredPermission;
import com.enokdev.boutique.utils.RequiredRole;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;


@Controller
@RequestMapping("/ventes")
@RequiredArgsConstructor

public class VenteController {

    private final VenteService venteService;
    private final ProduitService produitService;
    private final TicketService ticketService;
    Logger log = LogManager.getLogger();

    @GetMapping
    public String listeVentes(Model model,
                              @RequestParam(required = false ,name = "dateDebut") LocalDate dateDebut,
                              @RequestParam(required = false,name = "dateFin") LocalDate dateFin) {
        if (dateDebut != null && dateFin != null) {

            LocalDateTime debut = dateDebut.atStartOfDay();

            LocalDateTime fin = dateFin.atTime(23, 59, 59);
            model.addAttribute("ventes", venteService.getVentesParPeriode(debut, fin));
        } else {
            model.addAttribute("ventes", venteService.getAllVentes());
        }
        return "ventes/liste";
    }

    @GetMapping("/nouvelle")
    public String nouvelleVenteForm(Model model) {
        model.addAttribute("vente", new VenteDto());
        model.addAttribute("produits", produitService.getAllProduits());
        return "ventes/form";
    }

    @RequiredPermission("VENTE_CREER")
    @RequiredRole({Utilisateur.Role.VENDEUR, Utilisateur.Role.ADMIN})
    @PostMapping("/nouvelle")

    public String ajouterVente(@Valid @ModelAttribute("vente") VenteDto venteDto,
                               BindingResult result,
                               HttpSession session,
                               RedirectAttributes redirectAttributes,
                               Model model) {
        log.info("Réception d'une nouvelle vente");

        if (result.hasErrors()) {
            log.warn("Erreurs de validation: {}", result.getAllErrors());
            return "ventes/form";
        }

        try {
            // Récupérer l'ID de l'utilisateur de la session
            Long userId = (Long) session.getAttribute("userId");
            if (userId == null) {
                throw new IllegalStateException("Utilisateur non connecté");
            }
            venteDto.setUtilisateurId(userId);
            log.info("UserId récupéré de la session: {}", userId);

            // Sauvegarder la vente
            VenteDto savedVente = venteService.save(venteDto);
            log.info("Vente sauvegardée avec succès, ID: {}", savedVente.getId());

            redirectAttributes.addFlashAttribute("success", "Vente enregistrée avec succès");
            return "redirect:/ventes";
        } catch (Exception e) {
            log.error("Erreur lors de l'enregistrement de la vente", e);
            model.addAttribute("error", "Erreur lors de l'enregistrement de la vente: " + e.getMessage());
            model.addAttribute("produits", produitService.getAllProduits());
            return "ventes/form";
        }
    }

    @GetMapping("/{id}")
    public String detailVente(@PathVariable(name = "id") Long id, Model model) {
        try {
            model.addAttribute("vente", venteService.getVenteById(id));
            log.info("Détails de la vente ID: {}", id);
            log.info("Récupération des lignes de vente pour la vente ID: {}", venteService.getVenteById(id));
            return "ventes/detail";
        } catch (Exception e) {
            return "redirect:/ventes";
        }
    }

    @GetMapping("/ticket/{id}")
    public void imprimerTicket(@PathVariable(name = "id") Long id, HttpServletResponse response) {
        try {
            VenteResponse vente = venteService.getVenteById(id);
            byte[] ticket = ticketService.generateTicket(vente);


            response.setContentType("text/plain");

            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=ticket-" + id + ".txt");
            response.getOutputStream().write(ticket);
        } catch (Exception e) {
            // Gérer l'erreur
        }
    }
    @GetMapping("/editer/{id}")
    public String editerVenteForm(@PathVariable(name = "id") Long id, Model model) {
        try {

            VenteResponse vente = venteService.getVenteById(id);
            model.addAttribute("vente", vente);
            model.addAttribute("produits", produitService.getAllProduits());
            model.addAttribute("isEdition", true);

            return "ventes/form";
        } catch (Exception e) {
            return "redirect:/ventes/liste";
        }
    }

    @PostMapping("/editer/{id}")
    public String editerVente(@PathVariable(name = "id") Long id,
                                  @Valid @ModelAttribute("vente") VenteDto venteDto,
                                  BindingResult result,
                                  HttpSession session,
                                  Model model,
                                  RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("produits", produitService.getAllProduits());
            return "ventes/form";
        }

        try {
            Long userId = (Long) session.getAttribute("userId");
            venteDto.setUtilisateurId(userId);
            venteDto.setDateVente(LocalDateTime.now());

            VenteDto saved = venteService.update(venteDto);
            redirectAttributes.addFlashAttribute("success", "Vente enregistrée avec succès");

            return "redirect:/ventes/" + saved.getId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la mise à jour de la Vente");
            return "redirect:/ventes/editer/" + id;
        }
    }

    @GetMapping("/api/stats")
    @ResponseBody
    public ResponseEntity<List<VenteResponse>> getVentesStats(
            @RequestParam(name = "dateDebut") LocalDate dateDebut,
            @RequestParam(name = "dateFin") LocalDate dateFin) {
        LocalDateTime debut = dateDebut.atStartOfDay();
        LocalDateTime fin = dateFin.atTime(23, 59, 59);
        return ResponseEntity.ok(venteService.getVentesParPeriode(debut, fin));
    }

    @RequiredPermission("VENTE_SUPPRIMER")
    @RequiredRole({Utilisateur.Role.ADMIN, Utilisateur.Role.GESTIONNAIRE_STOCK})
    @PostMapping("/delete/{id}")
    public String supprimerVente(@PathVariable(name = "id") Long id,
                                     RedirectAttributes redirectAttributes) {
        try {
            var  vente = venteService.getVenteById(id);
            if (vente != null) {
                venteService.deleteVente(id);
            }
            redirectAttributes.addFlashAttribute("success",
                    "Vente supprimé avec succès");
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error",
                    "Vente non trouvé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/ventes";
    }
}

