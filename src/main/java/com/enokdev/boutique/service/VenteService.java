package com.enokdev.boutique.service;

import com.enokdev.boutique.dto.LigneVenteDto;
import com.enokdev.boutique.dto.ProduitDto;
import com.enokdev.boutique.dto.VenteDto;
import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.mapper.ProduitMapper;
import com.enokdev.boutique.mapper.VenteMapper;
import com.enokdev.boutique.model.LigneVente;
import com.enokdev.boutique.model.Produit;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.model.Vente;

import com.enokdev.boutique.repository.UtilisateurRepository;
import com.enokdev.boutique.repository.VenteRepository;
import jakarta.persistence.EntityNotFoundException;


import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;


@Service
@Transactional
@RequiredArgsConstructor

public class VenteService {

    private final VenteRepository venteRepository;
    private final ProduitService produitService;
    private final UtilisateurRepository utilisateurRepository;
   private final  Logger log = LogManager.getLogger();
    private final ProduitMapper produitMapper;

    public List<VenteResponse> getAllVentes() {
        return venteRepository.findAll().stream()
                .map(this::toVenteResponse)
                .collect(Collectors.toList());
    }

    public VenteResponse getVenteById(Long id) {
        return venteRepository.findById(id)
                .map(this::toVenteResponse)
                .orElseThrow(() -> new EntityNotFoundException("Vente non trouvée avec l'ID : " + id));
    }
    @Transactional
    public VenteDto save(VenteDto venteDto) {
        log.info("Début de la sauvegarde de la vente");

                log.info("VenteDto reçu: {}", venteDto);

        try {
            // 1. Vérification des données
            if (venteDto.getLignesVente() == null || venteDto.getLignesVente().isEmpty()) {
                log.error("Tentative de sauvegarde d'une vente sans lignes");
                throw new IllegalArgumentException("La vente doit contenir au moins une ligne");
            }

            // 2. Création de la vente
            Vente vente = new Vente();
            vente.setDateVente(LocalDateTime.now());

            // 3. Récupération et association de l'utilisateur
            log.info("Recherche de l'utilisateur ID: {}", venteDto.getUtilisateurId());
            Utilisateur utilisateur = utilisateurRepository.findById(venteDto.getUtilisateurId())
                    .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé: " + venteDto.getUtilisateurId()));
            vente.setUtilisateur(utilisateur);

            // 4. Traitement des lignes de vente
            BigDecimal montantTotal = BigDecimal.ZERO;
            log.info("Traitement de {} lignes de vente", venteDto.getLignesVente().size());

            for (LigneVenteDto ligneDto : venteDto.getLignesVente()) {
                log.info("Traitement de la ligne pour le produit ID: {}", ligneDto.getProduitId());

                // Récupération du produit
                Produit produit = produitService.findById(ligneDto.getProduitId()).map(produitMapper::toEntity)
                        .orElseThrow(() -> new EntityNotFoundException("Produit non trouvé: " + ligneDto.getProduitId()));

                // Vérification du stock
                if (produit.getQuantiteStock() < ligneDto.getQuantite()) {
                    throw new IllegalStateException("Stock insuffisant pour le produit: " + produit.getNom());
                }

                // Création de la ligne de vente
                LigneVente ligneVente = new LigneVente();
                ligneVente.setProduit(produit);
                ligneVente.setQuantite(ligneDto.getQuantite());
                ligneVente.setPrixUnitaire(produit.getPrixUnitaire());
                ligneVente.setMontantTotal(produit.getPrixUnitaire().multiply(BigDecimal.valueOf(ligneDto.getQuantite())));

                vente.addLigneVente(ligneVente);
                montantTotal = montantTotal.add(ligneVente.getMontantTotal());

                // Mise à jour du stock
                produit.setQuantiteStock(produit.getQuantiteStock() - ligneDto.getQuantite());
                produitService.saveProduit(ProduitDto.builder()
                                .id(produit.getId())
                                .nom(produit.getNom())
                                .description(produit.getDescription())
                                .prixUnitaire(produit.getPrixUnitaire())
                                .quantiteStock(produit.getQuantiteStock())
                                .seuilAlerte(produit.getSeuilAlerte())

                        .build());
            }

            vente.setMontantTotal(montantTotal);
            vente.setNomClient(venteDto.getNomClient());
            log.info("Montant total calculé: {}", montantTotal);

            // 5. Sauvegarde de la vente
            log.info("Sauvegarde de la vente en base de données...");
            Vente venteSauvegardee = venteRepository.save(vente);
            log.info("Vente sauvegardée avec succès, ID: {}", venteSauvegardee.getId());

            return toDto(venteSauvegardee);

        } catch (Exception e) {
            log.error("Erreur lors de la sauvegarde de la vente", e);
            throw new RuntimeException("Erreur lors de la sauvegarde de la vente: " + e.getMessage(), e);
        }
    }
    // Méthode de mapping de Vente vers VenteDto
    private VenteDto toDto(Vente vente) {
        VenteDto dto = new VenteDto();
        dto.setId(vente.getId());
        dto.setNomClient(vente.getNomClient());
        dto.setMontantTotal(vente.getMontantTotal());
        dto.setUtilisateurId(vente.getUtilisateur().getId());

        // Mapping des lignes de vente
        List<LigneVenteDto> lignesDto = vente.getLignesVente().stream()
                .map(this::toLigneVenteDto)
                .collect(Collectors.toList());
        dto.setLignesVente(lignesDto);

        return dto;
    }

    // Méthode de mapping de LigneVente vers LigneVenteDto
    private LigneVenteDto toLigneVenteDto(LigneVente ligneVente) {
        LigneVenteDto dto = new LigneVenteDto();
        dto.setId(ligneVente.getId());

        dto.setProduitId(ligneVente.getProduit().getId());
        dto.setQuantite(ligneVente.getQuantite());
        dto.setPrixUnitaire(ligneVente.getPrixUnitaire());
        dto.setMontantTotal(ligneVente.getMontantTotal());
        return dto;
    }

    // Méthode de mapping de VenteDto vers Vente
    private Vente toEntity(VenteDto dto) {
        Vente vente = new Vente();
        vente.setId(dto.getId());
        vente.setNomClient(dto.getNomClient());
        vente.setDateVente(dto.getDateVente());
        vente.setMontantTotal(dto.getMontantTotal());

        if (dto.getUtilisateurId() != null) {
            Utilisateur utilisateur = utilisateurRepository.findById(dto.getUtilisateurId())
                    .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé"));
            vente.setUtilisateur(utilisateur);
        }

        return vente;
    }


    public List<VenteResponse> getVentesParPeriode(LocalDateTime debut, LocalDateTime fin) {
        return venteRepository.findByDateVenteBetween(debut, fin).stream()
                .map(this::toVenteResponse)
                .collect(Collectors.toList());
    }
    public BigDecimal getTotalVentesParPeriode(LocalDateTime debut, LocalDateTime fin) {
        BigDecimal total = venteRepository.getTotalVentesParPeriode(debut, fin);
        log.info("Total des ventes pour la période {} - {} : {}", debut, fin, total);
        return total != null ? total : BigDecimal.ZERO;
    }
    private VenteResponse toVenteResponse(Vente vente) {
        VenteResponse response = new VenteResponse();
        response.setId(vente.getId());
        response.setDateVente(vente.getDateVente());
        response.setDateVenteFormatted(
                vente.getDateVente().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"))
        );
        response.setMontantTotal(vente.getMontantTotal());
        response.setNomClient(vente.getNomClient());
        response.setUtilisateurNomComplet(vente.getUtilisateur().getNom() + " " + vente.getUtilisateur().getPrenom());

        // Mapping des lignes de vente
        List<LigneVenteDto> lignesDto = vente.getLignesVente().stream()
                .map(this::toLigneVenteDto)
                .collect(Collectors.toList());
        response.setLignesVente(lignesDto);

        return response;
    }

    public List<Map> getTopProduitsVendus(LocalDateTime debutDateTime, LocalDateTime finDateTime, int i) {
        return venteRepository.findTopProduitsVendus(debutDateTime, finDateTime, i);
    }

    public Object getVentesQuotidiennes(LocalDateTime debut, LocalDateTime fin) {
        return venteRepository.findVentesQuotidiennes(debut, fin);
    }


}