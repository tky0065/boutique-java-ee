package com.enokdev.boutique.service;
import com.enokdev.boutique.dto.*;
import com.enokdev.boutique.mapper.LivraisonMapper;

import com.enokdev.boutique.mapper.ProduitMapper;
import com.enokdev.boutique.model.LigneLivraison;
import com.enokdev.boutique.model.Livraison;
import com.enokdev.boutique.model.Produit;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.repository.LivraisonRepository;
import com.enokdev.boutique.repository.UtilisateurRepository;
import jakarta.persistence.EntityNotFoundException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;


@Service
@Transactional
@RequiredArgsConstructor
public class LivraisonService {

    private final LivraisonRepository livraisonRepository;
    private final LivraisonMapper livraisonMapper;
    private final ProduitService produitService;
    private final UtilisateurRepository utilisateurRepository;
    private final Logger log = LogManager.getLogger();
    private final ProduitMapper produitMapper;

    public List<LivraisonResponse> getAllLivraisons() {
        return livraisonRepository.findAll().stream()
                .map(this::toLivraisonResponse)
                .collect(Collectors.toList());
    }

    private LivraisonResponse toLivraisonResponse(Livraison livraison) {
           LivraisonResponse response = new LivraisonResponse();
              response.setId(livraison.getId());
                response.setDateLivraison(livraison.getDateLivraison());
                response.setNomFournisseur(livraison.getNomFournisseur());
                response.setDateLivraisonFormatted(livraison.getDateLivraison().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
                response.setMontantTotal(livraison.getMontantTotal());
                response.setUtilisateurId(livraison.getUtilisateur().getId());
                response.setUtilisateurNomComplet(livraison.getUtilisateur().getNom() + " " + livraison.getUtilisateur().getPrenom());

                // mapping des lignes de livraison
                List<LigneLivraisonDto> lignesDto = livraison.getLignesLivraison().stream()
                        .map(this::toLigneLivraisonDto)
                        .collect(Collectors.toList());
                response.setLignesLivraison(lignesDto);
                return response;
    }

    public LivraisonResponse getLivraisonById(Long id) {
        return livraisonRepository.findById(id)
                .map(this::toLivraisonResponse)
                .orElseThrow(() -> new EntityNotFoundException("Livraison non trouvée avec l'ID : " + id));
    }
    @Transactional
    public LivraisonDto saveLivraison(LivraisonDto livraisonDto) {
        log.info("Début de la sauvegarde de la livraison");
        log.info("LivraisonDto reçu: {}", livraisonDto);

        try {
            // 1. Vérification des données
            if (livraisonDto.getLignesLivraison() == null || livraisonDto.getLignesLivraison().isEmpty()) {
                log.error("Tentative de sauvegarde d'une livraison sans lignes");
                throw new IllegalArgumentException("La livraison doit contenir au moins une ligne");
            }

            // 2. Création de la livraison
            Livraison livraison = new Livraison();
            livraison.setDateLivraison(LocalDateTime.now());
            livraison.setNomFournisseur(livraisonDto.getNomFournisseur());

            // 3. Récupération et association de l'utilisateur
            log.info("Recherche de l'utilisateur ID: {}", livraisonDto.getUtilisateurId());
            Utilisateur utilisateur = utilisateurRepository.findById(livraisonDto.getUtilisateurId())
                    .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé: " + livraisonDto.getUtilisateurId()));
            livraison.setUtilisateur(utilisateur);

            // 4. Traitement des lignes de livraison
            BigDecimal montantTotal = BigDecimal.ZERO;
            log.info("Traitement de {} lignes de livraison", livraisonDto.getLignesLivraison().size());

            for (LigneLivraisonDto ligneDto : livraisonDto.getLignesLivraison()) {
                log.info("Traitement de la ligne pour le produit ID: {}", ligneDto.getProduitId());

                // Récupération du produit
                Produit produit = produitService.findById(ligneDto.getProduitId()).map(produitMapper::toEntity)
                        .orElseThrow(() -> new EntityNotFoundException("Produit non trouvé: " + ligneDto.getProduitId()));

                // Création de la ligne de livraison
                LigneLivraison ligneLivraison = new LigneLivraison();
                ligneLivraison.setProduit(produit);
                ligneLivraison.setLivraison(livraison);
                ligneLivraison.setQuantite(ligneDto.getQuantite());
                ligneLivraison.setPrixUnitaire(ligneDto.getPrixUnitaire());
                ligneLivraison.setMontantTotal(ligneDto.getPrixUnitaire().multiply(BigDecimal.valueOf(ligneDto.getQuantite())));

                livraison.getLignesLivraison().add(ligneLivraison);
                montantTotal = montantTotal.add(ligneLivraison.getMontantTotal());

                // Mise à jour du stock
                produit.setQuantiteStock(produit.getQuantiteStock() + ligneDto.getQuantite());
                produitService.saveProduit(ProduitDto.builder()
                        .id(produit.getId())
                        .nom(produit.getNom())
                        .description(produit.getDescription())
                        .prixUnitaire(produit.getPrixUnitaire())
                        .quantiteStock(produit.getQuantiteStock())
                        .seuilAlerte(produit.getSeuilAlerte())
                        .build());
            }

            livraison.setMontantTotal(montantTotal);
            log.info("Montant total calculé pour la livraison: {}", montantTotal);

            // 5. Sauvegarde de la livraison
            log.info("Sauvegarde de la livraison en base de données...");
            Livraison livraisonSauvegardee = livraisonRepository.save(livraison);
            log.info("Livraison sauvegardée avec succès, ID: {}", livraisonSauvegardee.getId());

            return toDto(livraisonSauvegardee);

        } catch (Exception e) {
            log.error("Erreur lors de la sauvegarde de la livraison", e);
            throw new RuntimeException("Erreur lors de la sauvegarde de la livraison: " + e.getMessage(), e);
        }
    }

    public List<LivraisonDetailDto> getLivraisonsParProduit(Long produitId, LocalDateTime debut, LocalDateTime fin) {
        List<Object[]> resultats = livraisonRepository.findLivraisonsParProduit(produitId, debut, fin);
        List<LivraisonDetailDto> livraisons = new ArrayList<>();

        for (Object[] resultat : resultats) {
            LivraisonDetailDto livraison = new LivraisonDetailDto();
            livraison.setDateLivraison((LocalDateTime) resultat[0]);
            livraison.setNomFournisseur((String) resultat[1]);
            livraison.setQuantite((Integer) resultat[2]);
            livraison.setPrixUnitaire((BigDecimal) resultat[3]);
            livraisons.add(livraison);
        }

        return livraisons;
    }

    // Méthode de mapping de Livraison vers LivraisonDto
    private LivraisonDto toDto(Livraison livraison) {
        LivraisonDto dto = new LivraisonDto();
        dto.setId(livraison.getId());
        dto.setDateLivraison(livraison.getDateLivraison());
        dto.setNomFournisseur(livraison.getNomFournisseur());
        dto.setMontantTotal(livraison.getMontantTotal());
        dto.setUtilisateurId(livraison.getUtilisateur().getId());

        // Mapping des lignes de livraison
        List<LigneLivraisonDto> lignesDto = livraison.getLignesLivraison().stream()
                .map(this::toLigneLivraisonDto)
                .collect(Collectors.toList());
        dto.setLignesLivraison(lignesDto);

        return dto;
    }

    // Méthode de mapping de LigneLivraison vers LigneLivraisonDto
    private LigneLivraisonDto toLigneLivraisonDto(LigneLivraison ligne) {
        return LigneLivraisonDto.builder()
                .id(ligne.getId())
                .produitId(ligne.getProduit().getId())
                .produit(ligne.getProduit() != null ? produitMapper.toDto(ligne.getProduit()) : null)
                .quantite(ligne.getQuantite())
                .prixUnitaire(ligne.getPrixUnitaire())
                .montantTotal(ligne.getMontantTotal())
                .build();
    }



    public List<LivraisonResponse> getLivraisonsParPeriode(LocalDateTime debut, LocalDateTime fin) {
        return livraisonRepository.findByDateLivraisonBetween(debut, fin).stream()
                .map(this::toLivraisonResponse)
                .collect(Collectors.toList());
    }

    public void deleteLivraison(Long id) {

    }

    public BigDecimal getTotalLivraisonsParPeriode(LocalDateTime debutJour, LocalDateTime finJour) {
        return livraisonRepository.getTotalLivraisonsParPeriode(debutJour, finJour);
    }

    public Object getLivraisonsQuotidiennes(LocalDateTime debut, LocalDateTime fin) {
        return livraisonRepository.findLivraisonsQuotidiennes(debut, fin);
    }
}