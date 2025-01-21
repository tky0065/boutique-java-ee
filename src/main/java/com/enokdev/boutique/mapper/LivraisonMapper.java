package com.enokdev.boutique.mapper;

import com.enokdev.boutique.dto.LigneLivraisonDto;
import com.enokdev.boutique.dto.LivraisonDto;
import com.enokdev.boutique.model.LigneLivraison;
import com.enokdev.boutique.model.Livraison;
import com.enokdev.boutique.model.Produit;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.repository.LivraisonRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Objects;
import java.util.stream.Collectors;

@Service

public class LivraisonMapper {
    public LivraisonDto toDto(Livraison livraison){
        return LivraisonDto.builder()
                .id(livraison.getId())
                .dateLivraison(livraison.getDateLivraison())
                .nomFournisseur(livraison.getNomFournisseur())
                .utilisateurId(livraison.getUtilisateur().getId())
                .lignesLivraison(livraison.getLignesLivraison().stream().map(this::ligneLivraisonToDto).collect(Collectors.toList()))
                .montantTotal(livraison.getMontantTotal())

                .build();
    }

   public Livraison toEntity(LivraisonDto dto){

        if (dto == null) return null;

       return Livraison.builder()
                .id(dto.getId())
                .dateLivraison(dto.getDateLivraison())
                .nomFournisseur(dto.getNomFournisseur())
                .montantTotal(dto.getMontantTotal())
               .utilisateur(Utilisateur.builder()
               .id(dto.getUtilisateurId())
               .build()
               ).build();

   }

   public LigneLivraisonDto ligneLivraisonToDto(LigneLivraison ligneLivraison){
         return LigneLivraisonDto.builder()
                .id(ligneLivraison.getId())
                .produitId(ligneLivraison.getProduit().getId())
                .quantite(ligneLivraison.getQuantite())
                .prixUnitaire(ligneLivraison.getPrixUnitaire())
                .montantTotal(ligneLivraison.getMontantTotal())
                .build();
   }

   public LigneLivraison dtoToLigneLivraison(LigneLivraisonDto dto){
         if (dto == null) return null;
         return LigneLivraison.builder()
                .id(dto.getId())
                 .produit(Produit.builder()
                            .id(dto.getProduitId())
                         .build())
                .quantite(dto.getQuantite())
                .prixUnitaire(dto.getPrixUnitaire())
                .montantTotal(dto.getMontantTotal())

                .build();

   }
}
