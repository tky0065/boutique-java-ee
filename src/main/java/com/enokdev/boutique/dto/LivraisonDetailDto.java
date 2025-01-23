package com.enokdev.boutique.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class LivraisonDetailDto {
    private LocalDateTime dateLivraison;
    private String nomFournisseur;
    private Integer quantite;
    private BigDecimal prixUnitaire;

    // format date
    public String getDateLivraison() {
        return dateLivraison.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}