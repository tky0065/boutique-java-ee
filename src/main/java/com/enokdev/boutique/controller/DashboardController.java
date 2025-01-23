package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.ProduitDto;
import com.enokdev.boutique.dto.VenteDto;
import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.service.ProduitService;
import com.enokdev.boutique.service.VenteService;
import com.enokdev.boutique.service.LivraisonService;
import com.google.gson.Gson;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final ProduitService produitService;
    private final VenteService venteService;
    private final LivraisonService livraisonService;
    private final Logger log = LogManager.getLogger();


    @GetMapping
    public String dashboard(Model model, HttpSession session) {
        LocalDateTime debutJour = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime finJour = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
        Gson gson = new Gson();

        try {
            // Statistiques des ventes du jour
            List<VenteResponse> ventesJour = venteService.getVentesParPeriode(debutJour, finJour);
            BigDecimal totalVentesJour = ventesJour.stream()
                    .map(VenteResponse::getMontantTotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // Statistiques des livraisons du jour
            BigDecimal totalLivraisonsJour = livraisonService.getTotalLivraisonsParPeriode(debutJour, finJour);

            // Produits en alerte de stock
            List<ProduitDto> produitsAlerte = produitService.getProduitsSousSeuilAlerte();

            // Total des produits
            Long totalProduits = produitService.getTotalProduits();

            // Top 5 des produits vendus
            List<Map> topProduits = venteService.getTopProduitsVendus(debutJour, finJour, 5);
            Map<String, Object> topProduitsData = transformerTopProduitsData(topProduits);

            // Données des ventes pour le graphique
            Map<String, Object> ventesData = transformerVentesData(ventesJour);

            // Ajouter les données au modèle
            model.addAttribute("ventesJour", ventesJour);
            model.addAttribute("ventesJourTotal", totalVentesJour);
            model.addAttribute("livraisonsJourTotal", totalLivraisonsJour);
            model.addAttribute("produitsAlerte", produitsAlerte);
            model.addAttribute("totalProduits", totalProduits);

            // Ajouter les données JSON pour les graphiques
            model.addAttribute("ventesDataJson", gson.toJson(ventesData));
            model.addAttribute("topProduitsDataJson", gson.toJson(topProduitsData));

        } catch (Exception e) {
            // Gérer les erreurs
            log.error("Erreur lors du chargement du dashboard", e);
        }

        return "dashboard/index";
    }

    private Map<String, Object> transformerTopProduitsData(List<Map> topProduits) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Number> quantites = new ArrayList<>();

        for (Map produit : topProduits) {
            labels.add((String) produit.get("nom"));
            quantites.add((Number) produit.get("quantite"));
        }

        result.put("labels", labels);
        result.put("donnees", quantites);
        return result;
    }

    private Map<String, Object> transformerVentesData(List<VenteResponse> ventes) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> montants = new ArrayList<>();

        for (VenteResponse vente : ventes) {
            labels.add(vente.getDateVenteFormatted());
            montants.add(vente.getMontantTotal());
        }

        result.put("labels", labels);
        result.put("donnees", montants);
        return result;
    }
    @GetMapping("/stats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getStats(
            @RequestParam(required = false) LocalDate debut,
            @RequestParam(required = false) LocalDate fin) {

        if (debut == null) {
            debut = LocalDate.now().minusDays(30);
        }
        if (fin == null) {
            fin = LocalDate.now();
        }

        LocalDateTime debutDateTime = debut.atStartOfDay();
        LocalDateTime finDateTime = fin.atTime(LocalTime.MAX);

        Map<String, Object> stats = new HashMap<>();

        // Statistiques des ventes
        List<VenteResponse> ventes = venteService.getVentesParPeriode(debutDateTime, finDateTime);
        BigDecimal totalVentes = ventes.stream()
                .map(VenteResponse::getMontantTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // Statistiques des livraisons
        BigDecimal totalLivraisons = livraisonService.getTotalLivraisonsParPeriode(debutDateTime, finDateTime);

        // Top produits vendus
        List<Map> topProduits = venteService.getTopProduitsVendus(debutDateTime, finDateTime, 5);

        stats.put("totalVentes", totalVentes);
        stats.put("totalLivraisons", totalLivraisons);
        stats.put("nombreVentes", ventes.size());
        stats.put("topProduits", topProduits);

        return ResponseEntity.ok(stats);
    }

    @GetMapping("/chart-data")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getChartData(
            @RequestParam(required = false) String type,
            @RequestParam(required = false) Integer periode) {

        if (periode == null) {
            periode = 7; // Par défaut 7 jours
        }

        LocalDateTime debut = LocalDateTime.now().minusDays(periode);
        LocalDateTime fin = LocalDateTime.now();

        Map<String, Object> chartData = new HashMap<>();

        if ("ventes".equals(type)) {
            chartData.put("data", venteService.getVentesQuotidiennes(debut, fin));
            chartData.put("label", "Ventes quotidiennes");
        } else if ("livraisons".equals(type)) {
            chartData.put("data", livraisonService.getLivraisonsQuotidiennes(debut, fin));
            chartData.put("label", "Livraisons quotidiennes");
        } else {
            // Par défaut, retourner les deux
            chartData.put("ventes", venteService.getVentesQuotidiennes(debut, fin));
            chartData.put("livraisons", livraisonService.getLivraisonsQuotidiennes(debut, fin));
        }

        return ResponseEntity.ok(chartData);
    }

    @GetMapping("/alertes")
    @ResponseBody
    public ResponseEntity<List<ProduitDto>> getAlertes() {
        return ResponseEntity.ok(produitService.getProduitsSousSeuilAlerte());
    }

    @GetMapping("/refresh-stats")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> refreshStats() {
        Map<String, Object> stats = new HashMap<>();
        LocalDateTime debutJour = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime finJour = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);

        stats.put("ventesJourTotal", venteService.getTotalVentesParPeriode(debutJour, finJour));
        stats.put("livraisonsJourTotal", livraisonService.getTotalLivraisonsParPeriode(debutJour, finJour));
        stats.put("nombreProduitsAlerte", produitService.getProduitsSousSeuilAlerte().size());

        return ResponseEntity.ok(stats);
    }

}