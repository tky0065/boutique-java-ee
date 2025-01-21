package com.enokdev.boutique.service;

import com.enokdev.boutique.dto.LigneVenteDto;
import com.enokdev.boutique.dto.VenteDto;
import com.enokdev.boutique.dto.VenteResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.PrintWriter;
import java.text.NumberFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
@RequiredArgsConstructor
@Log4j2
public class TicketService {

    private static final int TICKET_WIDTH = 40;
    private static final String SEPARATOR = "-".repeat(TICKET_WIDTH);
    private final DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

    public byte[] generateTicket(VenteResponse vente) {
        log.info("Génération du ticket pour la vente ID: {}", vente.getId());
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        PrintWriter writer = new PrintWriter(outputStream);

        try {
            // En-tête du ticket
            writeCentered(writer, "BOUTIQUE");
            writeCentered(writer, "----------------");
            writer.println();

            // Informations de la vente
            writer.println("Date  : " + vente.getDateVente().format(dateFormatter));
            writer.println("Ticket: #" + String.format("%06d", vente.getId()));
            if (vente.getUtilisateurId() != null) {
                writer.println("Vendeur: #" + vente.getUtilisateurId());
            }
            writer.println(SEPARATOR);

            // En-tête des produits
            String header = String.format("%-20s %5s %7s %7s",
                    "Article", "Qté", "PU", "Total");
            writer.println(header);
            writer.println(SEPARATOR);

            // Détail des produits
            if (vente.getLignesVente() != null) {
                for (LigneVenteDto ligne : vente.getLignesVente()) {
                    String nomProduit = "Produit #" + ligne.getProduitId();
                    String detail = String.format("%-20s %5d %11s %11s",
                            truncate(nomProduit, 20),
                            ligne.getQuantite(),
                            formatCurrency(ligne.getPrixUnitaire().doubleValue()),
                            formatCurrency(ligne.getMontantTotal().doubleValue())
                    );
                    writer.println(detail);
                }
            }

            // Total
            writer.println(SEPARATOR);
            String total = String.format("TOTAL : %33s",
                    formatCurrency(vente.getMontantTotal().doubleValue()));
            writer.println(total);
            writer.println(SEPARATOR);

            // Pied de ticket
            writer.println();
            writeCentered(writer, "Merci de votre visite !");
            writeCentered(writer, "À bientôt !");

            writer.flush();
            log.info("Ticket généré avec succès");
            return outputStream.toByteArray();

        } catch (Exception e) {
            log.error("Erreur lors de la génération du ticket pour la vente ID: " + vente.getId(), e);
            throw new RuntimeException("Erreur lors de la génération du ticket", e);
        } finally {
            writer.close();
        }
    }

    private void writeCentered(PrintWriter writer, String text) {
        int padding = (TICKET_WIDTH - text.length()) / 2;
        if (padding > 0) {
            writer.print(" ".repeat(padding));
        }
        writer.println(text);
    }

    private String truncate(String text, int length) {
        if (text == null) {
            return "";
        }
        if (text.length() <= length) {
            return text;
        }
        return text.substring(0, length - 3) + "...";
    }

    private String formatCurrency(double amount) {
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.FRENCH);
        nf.setGroupingUsed(true);
        nf.setMinimumFractionDigits(0);
        nf.setMaximumFractionDigits(0);
        return nf.format(amount) + " FCFA";
    }

    public Object getDailyTicketsStats(LocalDateTime date) {
        // À implémenter selon vos besoins
        log.info("Récupération des statistiques des tickets pour la date: {}", date);
        return null;
    }
}