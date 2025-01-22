package com.enokdev.boutique.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AlerteStockDto {
    private Long produitId;
    private String nom;
    private Integer quantiteStock;
    private Integer seuilAlerte;
}
