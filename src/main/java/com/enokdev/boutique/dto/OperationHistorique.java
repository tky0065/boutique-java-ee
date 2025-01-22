package com.enokdev.boutique.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@Builder
public class OperationHistorique {
    private Long id;
    private String type;
    private LocalDateTime date;
    private String reference;
    private String nomPartenaire;
    private BigDecimal montant;

    public String getDateFormatted() {
        return date.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
