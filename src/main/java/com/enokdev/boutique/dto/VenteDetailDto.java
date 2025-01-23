package com.enokdev.boutique.dto;

import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
public class VenteDetailDto {
    private LocalDateTime dateVente;
    private Integer quantite;
    private BigDecimal prixUnitaire;
    private BigDecimal montantTotal;

    // format date
    public String getDateVente() {
        return dateVente.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
