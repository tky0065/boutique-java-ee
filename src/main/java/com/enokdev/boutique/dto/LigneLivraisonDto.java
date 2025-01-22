package com.enokdev.boutique.dto;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LigneLivraisonDto {
    private Long id;

    @NotNull(message = "Le produit est obligatoire")
    private Long produitId;

    private ProduitDto produit;

    @NotNull(message = "La quantité est obligatoire")
    @Min(value = 1, message = "La quantité doit être d'au moins 1")
    private Integer quantite;

    @NotNull(message = "Le prix unitaire est obligatoire")
    @Min(value = 0, message = "Le prix unitaire doit être positif")
    private BigDecimal prixUnitaire;

    private BigDecimal montantTotal;




}
