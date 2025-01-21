package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.UtilisateurDto;
import com.enokdev.boutique.service.UtilisateurService;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Log4j2
@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UtilisateurService utilisateurService;

    @GetMapping("/login")
    public String showLoginForm() {
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam(name = "identifiant") String identifiant,
                        @RequestParam(name = "motDePasse") String motDePasse,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        try {
            UtilisateurDto utilisateur = utilisateurService.authenticateUtilisateur(identifiant, motDePasse);
            session.setAttribute("utilisateur", utilisateur);
            session.setAttribute("userId", utilisateur.getId());
            return "redirect:/dashboard";
        } catch (RuntimeException e) {
            redirectAttributes.addFlashAttribute("error", "Identifiants incorrects");
            return "redirect:/auth/login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/auth/login";
    }

    @GetMapping("/register")
    public String showRegisterForm(Model model) {
        var user = new UtilisateurDto();

        model.addAttribute("utilisateur", user);
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@ModelAttribute UtilisateurDto utilisateurDto,
                           RedirectAttributes redirectAttributes) {
        try {

            utilisateurService.saveUtilisateur(utilisateurDto);
            log.info("Utilisateur créé avec succès : {}", utilisateurDto);
            redirectAttributes.addFlashAttribute("success", "Compte créé avec succès");
            return "redirect:/auth/login";
        } catch (Exception e) {

            redirectAttributes.addFlashAttribute("error", "Erreur lors de la création du compte : " + e.getMessage());
            return "redirect:/auth/register";
        }
    }
}