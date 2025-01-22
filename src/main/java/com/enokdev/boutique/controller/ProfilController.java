package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.UtilisateurDto;
import com.enokdev.boutique.service.UtilisateurService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/profile")
@RequiredArgsConstructor
public class ProfilController {

    private final UtilisateurService utilisateurService;

    @GetMapping
    public String showProfil(HttpSession session, Model model) {
        Long userId = (Long) session.getAttribute("userId");
        UtilisateurDto utilisateur = utilisateurService.getUtilisateurById(userId);
        model.addAttribute("utilisateur", utilisateur);
        return "profile/index";
    }

    @PostMapping("/update")
    public String updateProfil(
            @ModelAttribute UtilisateurDto utilisateurDto,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            Long userId = (Long) session.getAttribute("userId");
            utilisateurDto.setId(userId);
            utilisateurService.updateProfil(utilisateurDto);
            redirectAttributes.addFlashAttribute("success", "Profil mis à jour avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur lors de la mise à jour: " + e.getMessage());
        }
        return "redirect:/profile";
    }

    @PostMapping("/password")
    public String changePassword(
            @RequestParam(name = "oldPassword") String oldPassword,
            @RequestParam(name = "newPassword") String newPassword,
            @RequestParam(name = "confirmPassword") String confirmPassword,
            HttpSession session,
            RedirectAttributes redirectAttributes) {
        try {
            if (!newPassword.equals(confirmPassword)) {
                throw new IllegalArgumentException("Les mots de passe ne correspondent pas");
            }
            Long userId = (Long) session.getAttribute("userId");
            utilisateurService.changePassword(userId, oldPassword, newPassword);
            redirectAttributes.addFlashAttribute("success", "Mot de passe modifié avec succès");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Erreur: " + e.getMessage());
        }
        return "redirect:/profile";
    }
}