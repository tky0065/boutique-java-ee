package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.LivraisonResponse;
import com.enokdev.boutique.dto.OperationHistorique;
import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.service.LivraisonService;
import com.enokdev.boutique.service.VenteService;
import lombok.RequiredArgsConstructor;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/historique")
@RequiredArgsConstructor


public class HistoriqueController {

    private final VenteService venteService;
    private final LivraisonService livraisonService; private final Logger log = LogManager.getLogger();


    @GetMapping
    public String afficherHistorique(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateDebut,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate dateFin,
            Model model) {

        if (dateDebut == null) dateDebut = LocalDate.now().minusMonths(1);
        if (dateFin == null) dateFin = LocalDate.now();

        List<OperationHistorique> operations = new ArrayList<>();

        // Récupérer les ventes
        if (type == null || "all".equals(type) || "ventes".equals(type)) {
            List<VenteResponse> ventes = venteService.getVentesParPeriode(
                    dateDebut.atStartOfDay(),
                    dateFin.atTime(23, 59, 59)
            );
            operations.addAll(ventes.stream()
                    .map(this::convertirVenteEnOperation)
                    .collect(Collectors.toList()));
        }

        // Récupérer les livraisons
        if (type == null || "all".equals(type) || "livraisons".equals(type)) {
            List<LivraisonResponse> livraisons = livraisonService.getLivraisonsParPeriode(
                    dateDebut.atStartOfDay(),
                    dateFin.atTime(23, 59, 59)
            );
            operations.addAll(livraisons.stream()
                    .map(this::convertirLivraisonEnOperation)
                    .collect(Collectors.toList()));
        }

        // Trier par date décroissante
        operations.sort((o1, o2) -> o2.getDate().compareTo(o1.getDate()));

        model.addAttribute("operations", operations);
        return "historique/historique";
    }

    @GetMapping("/{id}/details")
    public String getDetails(@PathVariable Long id, @RequestParam String type, Model model) {
        if ("VENTE".equals(type)) {
            model.addAttribute("operation", venteService.getVenteById(id));
            return "ventes/detail";
        } else {
            model.addAttribute("operation", livraisonService.getLivraisonById(id));
            return "livraisons/detail";
        }
    }

    private OperationHistorique convertirVenteEnOperation(VenteResponse vente) {
        return OperationHistorique.builder()
                .id(vente.getId())
                .type("VENTE")
                .date(vente.getDateVente())
                .reference("V-" + vente.getId())
                .nomPartenaire(vente.getNomClient())
                .montant(vente.getMontantTotal())
                .build();
    }

    private OperationHistorique convertirLivraisonEnOperation(LivraisonResponse livraison) {
        return OperationHistorique.builder()
                .id(livraison.getId())
                .type("LIVRAISON")
                .date(livraison.getDateLivraison())
                .reference("L-" + livraison.getId())
                .nomPartenaire(livraison.getNomFournisseur())
                .montant(livraison.getMontantTotal())
                .build();
    }
}