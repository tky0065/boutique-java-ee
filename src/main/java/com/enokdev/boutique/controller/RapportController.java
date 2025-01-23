package com.enokdev.boutique.controller;


import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.service.ProduitService;
import com.enokdev.boutique.service.VenteService;
import com.google.gson.Gson;
import com.itextpdf.text.*;
import com.itextpdf.text.Font;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.*;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import jakarta.servlet.http.HttpServletResponse;
import java.io.ByteArrayOutputStream;
import java.text.NumberFormat;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.List;
import java.util.stream.Stream;
import lombok.RequiredArgsConstructor;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.poi.ss.util.CellRangeAddress;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Controller
@RequestMapping("/rapports")
@RequiredArgsConstructor
@CrossOrigin("*")
public class RapportController {

    private final VenteService venteService;
    private final ProduitService produitService;
    private final Logger log = LogManager.getLogger();

    @GetMapping
    public String afficherRapports(
            @RequestParam(defaultValue = "jour",name = "periode") String periode,
            @RequestParam(required = false,name = "dateDebut") LocalDate dateDebut,
            @RequestParam(required = false,name = "dateFin") LocalDate dateFin,
            Model model)  {

        if (dateDebut == null) dateDebut = LocalDate.now();
        if (dateFin == null) dateFin = LocalDate.now();

        LocalDateTime[] plage = calculerPlage(periode, dateDebut, dateFin);
        Gson gson = new Gson();

        try {
            // Statistiques
            Map<String, Object> stats = calculerStatistiques(plage[0], plage[1]);
            model.addAttribute("stats", stats);
            model.addAttribute("statsJson", gson.toJson(stats));

            // Données des ventes
            List<VenteResponse> ventes = venteService.getVentesParPeriode(plage[0], plage[1]);
            Map<String, Object> ventesData = transformerVentesData(ventes);
            model.addAttribute("ventesDataJson", gson.toJson(ventesData));

            // Top produits
            List<Map> topProduits = venteService.getTopProduitsVendus(plage[0], plage[1], 5);
            Map<String, Object> topProduitsData = transformerTopProduitsData(topProduits);
            model.addAttribute("topProduitsDataJson", gson.toJson(topProduitsData));

            // Ajouter les paramètres de période pour le formulaire
            model.addAttribute("periode", periode);
            model.addAttribute("dateDebut", dateDebut);
            model.addAttribute("dateFin", dateFin);

        } catch (Exception e) {
            log.error("Erreur lors de la préparation des données", e);
            // Ajouter des données vides en cas d'erreur
            model.addAttribute("statsJson", "{}");
            model.addAttribute("ventesDataJson", "{\"labels\":[],\"donnees\":[]}");
            model.addAttribute("topProduitsDataJson", "{\"labels\":[],\"donnees\":[]}");
        }

        return "rapports/index";
    }

    @GetMapping("/data")
    @ResponseBody
    public Map<String, Object> getDataRapports(
            @RequestParam(defaultValue = "jour",name = "periode") String periode,
            @RequestParam(required = false,name = "dateDebut") LocalDate dateDebut,
            @RequestParam(required = false,name = "dateFin") LocalDate dateFin) {

        log.info("Récupération des données pour période: {}, dateDebut: {}, dateFin: {}",
                periode, dateDebut, dateFin);

        if (dateDebut == null) dateDebut = LocalDate.now();
        if (dateFin == null) dateFin = LocalDate.now();

        LocalDateTime[] plage = calculerPlage(periode, dateDebut, dateFin);
        Map<String, Object> data = new HashMap<>();

        try {
            // Statistiques
            Map<String, Object> stats = calculerStatistiques(plage[0], plage[1]);
            data.put("stats", stats);

            // Données des ventes
            List<VenteResponse> ventes = venteService.getVentesParPeriode(plage[0], plage[1]);
            Map<String, Object> ventesData = transformerVentesData(ventes);
            data.put("ventes", ventesData);

            // Log des données de ventes pour debug
            log.info("Données des ventes: {}", ventesData);

            // Top produits
            List<Map> topProduits = venteService.getTopProduitsVendus(plage[0], plage[1], 5);
            Map<String, Object> topProduitsData = transformerTopProduitsData(topProduits);
            data.put("topProduits", topProduitsData);

            // Log des données des top produits pour debug
            log.info("Données des top produits: {}", topProduitsData);

        } catch (Exception e) {
            log.error("Erreur lors de la récupération des données", e);
            throw new RuntimeException("Erreur lors de la récupération des données", e);
        }

        return data;
    }

    private Map<String, Object> transformerVentesData(List<VenteResponse> ventes) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<BigDecimal> montants = new ArrayList<>();

        if (ventes != null && !ventes.isEmpty()) {
            for (VenteResponse vente : ventes) {
                labels.add(vente.getDateVenteFormatted());
                montants.add(vente.getMontantTotal() != null ? vente.getMontantTotal() : BigDecimal.ZERO);
            }
        } else {
            // Ajouter au moins une donnée vide pour éviter les graphiques vides
            labels.add(LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")));
            montants.add(BigDecimal.ZERO);
        }

        result.put("labels", labels);
        result.put("donnees", montants);
        return result;
    }

    private Map<String, Object> transformerTopProduitsData(List<Map> topProduits) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels = new ArrayList<>();
        List<Number> quantites = new ArrayList<>();

        if (topProduits != null && !topProduits.isEmpty()) {
            for (Map produit : topProduits) {
                String nom = (String) produit.get("nom");
                Number quantite = (Number) produit.get("quantite");
                labels.add(nom != null ? nom : "Inconnu");
                quantites.add(quantite != null ? quantite : 0);
            }
        } else {
            // Ajouter au moins une donnée vide pour éviter les graphiques vides
            labels.add("Aucun produit");
            quantites.add(0);
        }

        result.put("labels", labels);
        result.put("donnees", quantites);
        return result;
    }


    @GetMapping("/excel")
    public void exporterExcel(
            @RequestParam(defaultValue = "jour", name = "periode") String periode,
            @RequestParam(required = false, name = "dateDebut") LocalDate dateDebut,
            @RequestParam(required = false, name = "dateFin") LocalDate dateFin,
            HttpServletResponse response) throws IOException {

        if (dateDebut == null) dateDebut = LocalDate.now();
        if (dateFin == null) dateFin = LocalDate.now();

        LocalDateTime[] plage = calculerPlage(periode, dateDebut, dateFin);
        List<VenteResponse> ventes = venteService.getVentesParPeriode(plage[0], plage[1]);
        Map<String, Object> stats = calculerStatistiques(plage[0], plage[1]);

        Workbook workbook = new HSSFWorkbook();
        Sheet sheet = workbook.createSheet("Rapport des ventes");

        // Styles
        CellStyle headerStyle = workbook.createCellStyle();
        headerStyle.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        headerStyle.setAlignment(HorizontalAlignment.CENTER);
        headerStyle.setBorderBottom(BorderStyle.THIN);
        headerStyle.setBorderTop(BorderStyle.THIN);
        headerStyle.setBorderLeft(BorderStyle.THIN);
        headerStyle.setBorderRight(BorderStyle.THIN);

        org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // Style pour les montants
        CellStyle moneyStyle = workbook.createCellStyle();
        moneyStyle.setAlignment(HorizontalAlignment.RIGHT);
        DataFormat format = workbook.createDataFormat();
        moneyStyle.setDataFormat(format.getFormat("#,##0 \"FCFA\""));

        // Style pour le texte normal
        CellStyle normalStyle = workbook.createCellStyle();
        normalStyle.setAlignment(HorizontalAlignment.LEFT);

        // Style pour les titres des statistiques
        CellStyle titleStyle = workbook.createCellStyle();
        titleStyle.setAlignment(HorizontalAlignment.LEFT);
        org.apache.poi.ss.usermodel.Font titleFont = workbook.createFont();
        titleFont.setBold(true);
        titleStyle.setFont(titleFont);

        // Titre principal
        Row titleRow = sheet.createRow(0);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Statistiques de la période du " +
                plage[0].format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) + " au " +
                plage[1].format(DateTimeFormatter.ofPattern("dd/MM/yyyy")));
        titleCell.setCellStyle(titleStyle);
        sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 4));

        // Statistiques
        Row statsRow1 = sheet.createRow(2);
        statsRow1.createCell(0).setCellValue("Chiffre d'affaires:");
        statsRow1.getCell(0).setCellStyle(normalStyle);
        Cell caCell = statsRow1.createCell(1);
        caCell.setCellValue(((BigDecimal)stats.get("chiffreAffaires")).doubleValue());
        caCell.setCellStyle(moneyStyle);

        Row statsRow2 = sheet.createRow(3);
        statsRow2.createCell(0).setCellValue("Nombre de ventes:");
        statsRow2.getCell(0).setCellStyle(normalStyle);
        statsRow2.createCell(1).setCellValue((Integer)stats.get("nombreVentes"));

        Row statsRow3 = sheet.createRow(4);
        statsRow3.createCell(0).setCellValue("Valeur du stock:");
        statsRow3.getCell(0).setCellStyle(normalStyle);
        Cell stockCell = statsRow3.createCell(1);
        stockCell.setCellValue(((BigDecimal)stats.get("valeurStock")).doubleValue());
        stockCell.setCellStyle(moneyStyle);

        Row statsRow4 = sheet.createRow(5);
        statsRow4.createCell(0).setCellValue("Bénéfice estimé:");
        statsRow4.getCell(0).setCellStyle(normalStyle);
        Cell beneficeCell = statsRow4.createCell(1);
        beneficeCell.setCellValue(((BigDecimal)stats.get("benefice")).doubleValue());
        beneficeCell.setCellStyle(moneyStyle);

        // Ligne vide
        sheet.createRow(6);

        // En-têtes du tableau
        Row headerRow = sheet.createRow(7);
        String[] headers = {"ID", "Date", "Client", "Vendeur", "Montant Total"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        // Données
        CellStyle dataStyle = workbook.createCellStyle();
        dataStyle.setBorderBottom(BorderStyle.THIN);
        dataStyle.setBorderTop(BorderStyle.THIN);
        dataStyle.setBorderLeft(BorderStyle.THIN);
        dataStyle.setBorderRight(BorderStyle.THIN);

        int rowNum = 8;
        for (VenteResponse vente : ventes) {
            Row row = sheet.createRow(rowNum++);

            // ID
            Cell idCell = row.createCell(0);
            idCell.setCellValue(vente.getId());
            idCell.setCellStyle(dataStyle);

            // Date
            Cell dateCell = row.createCell(1);
            dateCell.setCellValue(vente.getDateVenteFormatted());
            dateCell.setCellStyle(dataStyle);

            // Client
            Cell clientCell = row.createCell(2);
            clientCell.setCellValue(vente.getNomClient());
            clientCell.setCellStyle(dataStyle);

            // Vendeur
            Cell vendeurCell = row.createCell(3);
            vendeurCell.setCellValue(vente.getUtilisateurNomComplet());
            vendeurCell.setCellStyle(dataStyle);

            // Montant
            Cell montantCell = row.createCell(4);
            montantCell.setCellValue(vente.getMontantTotal().doubleValue());
            CellStyle montantStyle = workbook.createCellStyle();
            montantStyle.cloneStyleFrom(dataStyle);
            montantStyle.setDataFormat(format.getFormat("#,##0 \"FCFA\""));
            montantCell.setCellStyle(montantStyle);
        }

        // Ajuster la largeur des colonnes
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        // Écrire le fichier
        response.setContentType("application/vnd.ms-excel");
        String filename = String.format("rapport-ventes-%s.xls",
                LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")));
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    @GetMapping("/pdf")
    public void genererPDF(
            @RequestParam(defaultValue = "jour",name = "periode") String periode,
            @RequestParam(required = false,name = "dateDebut") LocalDate dateDebut,
            @RequestParam(required = false,name = "dateFin") LocalDate dateFin,
            HttpServletResponse response) throws IOException {

        LocalDateTime[] plage = calculerPlage(periode, dateDebut, dateFin);
        List<VenteResponse> ventes = venteService.getVentesParPeriode(plage[0], plage[1]);
        Map<String, Object> stats = calculerStatistiques(plage[0], plage[1]);

        Document document = new Document(PageSize.A4);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        try {
            PdfWriter.getInstance(document, baos);
            document.open();

            // Titre et en-tête
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Paragraph title = new Paragraph("Rapport des ventes", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Période
            Font normalFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
            Font boldFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);

            Paragraph periodeText = new Paragraph();
            periodeText.add(new Chunk("Période: ", boldFont));
            periodeText.add(new Chunk(plage[0].format(DateTimeFormatter.ofPattern("dd/MM/yyyy")) +
                    " au " +
                    plage[1].format(DateTimeFormatter.ofPattern("dd/MM/yyyy")), normalFont));
            periodeText.setSpacingAfter(20);
            document.add(periodeText);

            // Statistiques
            document.add(new Paragraph("Statistiques:", boldFont));
            NumberFormat formatter = NumberFormat.getInstance(new Locale("fr", "FR"));

            Paragraph statsText = new Paragraph("", normalFont);
            statsText.add(String.format("Chiffre d'affaires: %s FCFA\n",
                    formatter.format(((BigDecimal)stats.get("chiffreAffaires")).doubleValue())));
            statsText.add(String.format("Nombre de ventes: %d\n",
                    stats.get("nombreVentes")));
            statsText.add(String.format("Valeur du stock: %s FCFA\n",
                    formatter.format(((BigDecimal)stats.get("valeurStock")).doubleValue())));
            statsText.add(String.format("Bénéfice estimé: %s FCFA\n",
                    formatter.format(((BigDecimal)stats.get("benefice")).doubleValue())));
            statsText.setSpacingAfter(20);
            document.add(statsText);

            // Tableau des ventes
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            float[] columnWidths = {10f, 25f, 20f, 25f, 20f};
            table.setWidths(columnWidths);

            // Style de l'en-tête
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12, BaseColor.WHITE);
            BaseColor headerBackground = new BaseColor(51, 51, 51);

            // En-têtes du tableau
            String[] headers = {"ID", "Date", "Client", "Vendeur", "Montant Total"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(headerBackground);
                cell.setPadding(5);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
            }

            // Contenu du tableau
            for (VenteResponse vente : ventes) {
                PdfPCell cell;

                // ID
                cell = new PdfPCell(new Phrase(vente.getId().toString()));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);

                // Date
                cell = new PdfPCell(new Phrase(vente.getDateVenteFormatted()));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);

                // Client
                cell = new PdfPCell(new Phrase(vente.getNomClient()));
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                table.addCell(cell);

                // Vendeur
                cell = new PdfPCell(new Phrase(vente.getUtilisateurNomComplet()));
                cell.setHorizontalAlignment(Element.ALIGN_LEFT);
                table.addCell(cell);

                // Montant Total
                cell = new PdfPCell(new Phrase(formatter.format(vente.getMontantTotal()) + " FCFA"));
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                table.addCell(cell);
            }

            document.add(table);

        } catch (DocumentException e) {
            log.error("Erreur lors de la génération du PDF", e);
            throw new RuntimeException("Erreur lors de la génération du PDF", e);
        } finally {
            document.close();
        }

        byte[] pdfBytes = baos.toByteArray();
        response.setContentType("application/pdf");
        String filename = "rapport-ventes-" +
                LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) +
                ".pdf";
        response.setHeader("Content-Disposition", "attachment; filename=" + filename);
        response.setContentLength(pdfBytes.length);
        response.getOutputStream().write(pdfBytes);
    }

    private LocalDateTime[] calculerPlage(String periode, LocalDate dateDebut, LocalDate dateFin) {
        LocalDateTime debut;
        LocalDateTime fin = LocalDateTime.now();

        switch (periode) {
            case "semaine":
                debut = fin.minusWeeks(1).withHour(0).withMinute(0);
                break;
            case "mois":
                debut = fin.withDayOfMonth(1).withHour(0).withMinute(0);
                break;
            case "personnalise":
                debut = dateDebut.atStartOfDay();
                fin = dateFin.atTime(23, 59, 59);
                break;
            default:
                debut = fin.withHour(0).withMinute(0);
        }

        return new LocalDateTime[]{debut, fin};
    }

    private Map<String, Object> calculerStatistiques(LocalDateTime debut, LocalDateTime fin) {
        Map<String, Object> stats = new HashMap<>();

        try {
            log.info("Calcul des statistiques pour la période du {} au {}", debut, fin);

            // Chiffre d'affaires
            BigDecimal ca = (BigDecimal) venteService.getTotalVentesParPeriode(debut, fin);
            stats.put("chiffreAffaires", ca != null ? ca : BigDecimal.ZERO);
            log.info("Chiffre d'affaires calculé: {}", ca);

            // Nombre de ventes
            List<VenteResponse> ventes = venteService.getVentesParPeriode(debut, fin);
            int nombreVentes = ventes != null ? ventes.size() : 0;
            stats.put("nombreVentes", nombreVentes);
            log.info("Nombre de ventes: {}", nombreVentes);

            // Valeur du stock
            BigDecimal valeurStock = produitService.calculateValeurStock();
            stats.put("valeurStock", valeurStock != null ? valeurStock : BigDecimal.ZERO);
            log.info("Valeur du stock: {}", valeurStock);

            // Bénéfice estimé (30% de marge)
            BigDecimal benefice = ca != null ? ca.multiply(new BigDecimal("0.3")) : BigDecimal.ZERO;
            stats.put("benefice", benefice);
            log.info("Bénéfice estimé: {}", benefice);

        } catch (Exception e) {
            log.error("Erreur lors du calcul des statistiques", e);
            // En cas d'erreur, on met des valeurs par défaut
            stats.put("chiffreAffaires", BigDecimal.ZERO);
            stats.put("nombreVentes", 0);
            stats.put("valeurStock", BigDecimal.ZERO);
            stats.put("benefice", BigDecimal.ZERO);
        }

        return stats;
    }
}