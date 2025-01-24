package com.enokdev.boutique.mapper;


import com.enokdev.boutique.dto.ProduitDto;
import com.enokdev.boutique.model.Produit;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class ProduitMapper {

    public ProduitDto toDto(Produit produit) {
       return ProduitDto.builder()
                .id(produit.getId())
                .nom(produit.getNom())
                .description(produit.getDescription())
                .prixUnitaire(produit.getPrixUnitaire())
                .quantiteStock(produit.getQuantiteStock())
                .seuilAlerte(produit.getSeuilAlerte())
                .build();
    }

    public Produit toEntity(ProduitDto dto) {
        if (dto == null) return null;

        return Produit.builder()
                .id(dto.getId())
                .nom(dto.getNom())
                .description(dto.getDescription())
                .prixUnitaire(dto.getPrixUnitaire())
                .quantiteStock(dto.getQuantiteStock())
                .seuilAlerte(dto.getSeuilAlerte())
                .build();
    }



    public void updateEntityFromDto(ProduitDto dto, Produit produit) {
        if (dto == null || produit == null) return;

        produit.setNom(dto.getNom());
        produit.setDescription(dto.getDescription());
        produit.setPrixUnitaire(dto.getPrixUnitaire());
        produit.setQuantiteStock(dto.getQuantiteStock());
        produit.setSeuilAlerte(dto.getSeuilAlerte());
    }
}