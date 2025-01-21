package com.enokdev.boutique.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;


@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VenteDto {
    private Long id;
    private LocalDateTime dateVente;
    private BigDecimal montantTotal;
    private String nomClient;
    private Long utilisateurId;
    private List<LigneVenteDto> lignesVente;
}