package com.enokdev.boutique.dto;

import jakarta.validation.constraints.NotEmpty;
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
public class VenteResponse {
    private Long id;
    private LocalDateTime dateVente;
    private String dateVenteFormatted;
    private BigDecimal montantTotal;
    private Long utilisateurId;
    private String nomClient;
    private String utilisateurNomComplet;

    @NotEmpty(message = "Au moins une ligne de vente est requise")
    private List<LigneVenteDto> lignesVente = new ArrayList<>();
}