package com.enokdev.boutique.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LivraisonDto {
    private Long id;
    private LocalDateTime dateLivraison;

    @NotBlank(message = "Le nom du fournisseur est obligatoire")
    private String nomFournisseur;

    private BigDecimal montantTotal;
    private Long utilisateurId;
    private List<LigneLivraisonDto> lignesLivraison;
}