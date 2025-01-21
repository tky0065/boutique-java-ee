package com.enokdev.boutique.mapper;

import com.enokdev.boutique.dto.LigneVenteDto;
import com.enokdev.boutique.dto.VenteDto;
import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.model.LigneVente;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.model.Vente;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class VenteMapper {

  public   VenteDto toDto(Vente vente){
      return VenteDto.builder()
              .id(vente.getId())
                .dateVente(vente.getDateVente())
                .montantTotal(vente.getMontantTotal())
                .nomClient(vente.getNomClient())
                .utilisateurId(vente.getUtilisateur().getId())
                .lignesVente(vente.getLignesVente().stream().map(this::ligneVenteToDto).collect(Collectors.toList()))
              .build();
  }

    public Vente toEntity(VenteDto dto){
        if (dto == null) return null;

        return Vente.builder()
                .id(dto.getId())
                .dateVente(dto.getDateVente())
                .nomClient(dto.getNomClient())
                .montantTotal(dto.getMontantTotal())
                .utilisateur(Utilisateur.builder()
                        .id(dto.getUtilisateurId())
                        .build()
                ).build();
    }

    public  LigneVenteDto ligneVenteToDto(LigneVente ligneVente){
        return LigneVenteDto.builder()
                .id(ligneVente.getId())
                .produitId(ligneVente.getProduit().getId())
                .quantite(ligneVente.getQuantite())
                .prixUnitaire(ligneVente.getPrixUnitaire())
                .montantTotal(ligneVente.getMontantTotal())
                .build();
    }

    public LigneVente dtoToLigneVente(LigneVenteDto dto){
        if (dto == null) return null;
        return LigneVente.builder()
                .id(dto.getId())
                .quantite(dto.getQuantite())
                .prixUnitaire(dto.getPrixUnitaire())
                .montantTotal(dto.getMontantTotal())
                .build();
    }



}