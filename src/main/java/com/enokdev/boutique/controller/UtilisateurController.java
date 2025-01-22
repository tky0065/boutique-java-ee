package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.UtilisateurDto;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.service.UtilisateurService;
import com.enokdev.boutique.utils.RequiredRole;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.format.datetime.DateFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
@RequestMapping("/utilisateurs")
@RequiredArgsConstructor
@RequiredRole({Utilisateur.Role.ADMIN})
public class UtilisateurController {

    private final UtilisateurService utilisateurService;

    @GetMapping
    public String listUtilisateurs(Model model) {
        List<UtilisateurDto> utilisateurs = utilisateurService.getAllUtilisateurs();
        utilisateurs.forEach(utilisateur -> {
            utilisateur.setMotDePasse("********");
        });

        model.addAttribute("utilisateurs", utilisateurs);
        return "utilisateurs/utilisateurs";
    }

    @GetMapping("/edit/{id}")
    public String editUtilisateur(@PathVariable(name = "id") Long id, Model model) {
        try {
            UtilisateurDto utilisateur = utilisateurService.getUtilisateurById(id);
            model.addAttribute("utilisateur", utilisateur);
            return "utilisateurs/edit";
        } catch (EntityNotFoundException e) {
            return "redirect:/utilisateurs";
        }
    }

    @PostMapping("/save")
    public String saveUtilisateur(@ModelAttribute UtilisateurDto utilisateurDto,
                                  RedirectAttributes redirectAttributes) {
        try {
            utilisateurService.saveUtilisateur(utilisateurDto);
            redirectAttributes.addFlashAttribute("success",
                    "Utilisateur enregistré avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de l'enregistrement: " + e.getMessage());
        }
        return "redirect:/utilisateurs";
    }

    @PostMapping("/update")
    public String updateUtilisateur(@ModelAttribute UtilisateurDto utilisateurDto,
                                    RedirectAttributes redirectAttributes) {
        try {
            // Récupérer l'ancien mot de passe si le nouveau est vide
            if (utilisateurDto.getMotDePasse() == null ||
                    utilisateurDto.getMotDePasse().trim().isEmpty()) {
                UtilisateurDto existingUser =
                        utilisateurService.getUtilisateurById(utilisateurDto.getId());
                utilisateurDto.setMotDePasse(existingUser.getMotDePasse());
            }

            utilisateurService.saveUtilisateur(utilisateurDto);
            redirectAttributes.addFlashAttribute("success",
                    "Utilisateur mis à jour avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de la mise à jour: " + e.getMessage());
        }
        return "redirect:/utilisateurs";
    }

    @PostMapping("/delete/{id}")
    public String deleteUtilisateur(@PathVariable(name = "id") Long id,
                                    RedirectAttributes redirectAttributes) {
        try {
            var  user = utilisateurService.getUtilisateurById(id);
           if (user != null) {
               utilisateurService.deleteUtilisateur(id);
           }
            redirectAttributes.addFlashAttribute("success",
                    "Utilisateur supprimé avec succès");
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("error",
                    "Utilisateur non trouvé");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error",
                    "Erreur lors de la suppression: " + e.getMessage());
        }
        return "redirect:/utilisateurs";
    }
}