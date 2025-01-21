package com.enokdev.boutique.mapper;

import com.enokdev.boutique.dto.LigneVenteDto;
import com.enokdev.boutique.model.LigneVente;
import org.springframework.stereotype.Service;

@Service
public class LigneVenteMapper {
    public LigneVenteDto toDto(LigneVente ligneVente){
        return LigneVenteDto.builder()
                .id(ligneVente.getId())
                .produitId(ligneVente.getProduit().getId())
                .quantite(ligneVente.getQuantite())
                .prixUnitaire(ligneVente.getPrixUnitaire())
                .montantTotal(ligneVente.getMontantTotal())

                .build();
    }

    public LigneVente toEntity(LigneVenteDto dto){
        if (dto == null) return null;
        return LigneVente.builder()
                .id(dto.getId())
                .quantite(dto.getQuantite())
                .prixUnitaire(dto.getPrixUnitaire())
                .montantTotal(dto.getMontantTotal())
                .build();
    }
}
