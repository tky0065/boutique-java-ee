package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.VenteDto;
import com.enokdev.boutique.dto.VenteResponse;
import com.enokdev.boutique.service.TicketService;
import com.enokdev.boutique.service.VenteService;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
@RequestMapping("/tickets")
@RequiredArgsConstructor
@Log4j2
public class TicketController {

    private final TicketService ticketService;
    private final VenteService venteService;

    @GetMapping("/{venteId}")
    public ResponseEntity<byte[]> imprimerTicket(@PathVariable(name = "venteId") Long venteId) {
        log.info("Demande d'impression du ticket pour la vente ID: {}", venteId);

        try {
            VenteResponse vente = venteService.getVenteById(venteId);
            byte[] ticket = ticketService.generateTicket(vente);

            String filename = String.format("ticket_%s_%06d.txt",
                    DateTimeFormatter.ofPattern("yyyyMMdd").format(LocalDateTime.now()),
                    venteId);

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.TEXT_PLAIN);
            headers.setContentDispositionFormData("attachment", filename);
            headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");

            log.info("Ticket généré avec succès pour la vente ID: {}", venteId);
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(ticket);

        } catch (Exception e) {
            log.error("Erreur lors de la génération du ticket pour la vente ID: " + venteId, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{venteId}/preview")
    public ResponseEntity<byte[]> previewTicket(@PathVariable(name = "venteId") Long venteId) {
        log.info("Demande de prévisualisation du ticket pour la vente ID: {}", venteId);

        try {
            VenteResponse vente = venteService.getVenteById(venteId);
            byte[] ticket = ticketService.generateTicket(vente);

            return ResponseEntity.ok()
                    .contentType(MediaType.TEXT_PLAIN)
                    .body(ticket);

        } catch (Exception e) {
            log.error("Erreur lors de la prévisualisation du ticket pour la vente ID: " + venteId, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    @GetMapping("/{venteId}/print")
    public String printTicket(@PathVariable(name = "venteId") Long venteId, Model model) {
        log.info("Demande d'impression directe du ticket pour la vente ID: {}", venteId);

        try {
            VenteResponse vente = venteService.getVenteById(venteId);
            model.addAttribute("vente", vente);
            model.addAttribute("ticket", new String(ticketService.generateTicket(vente)));
            return "tickets/print";

        } catch (Exception e) {
            log.error("Erreur lors de l'impression du ticket pour la vente ID: " + venteId, e);
            return "redirect:/ventes/" + venteId;
        }
    }

    @GetMapping("/{venteId}/thermal")
    public void thermalPrint(@PathVariable(name = "venteId") Long venteId, HttpServletResponse response) {
        log.info("Demande d'impression thermique du ticket pour la vente ID: {}", venteId);

        try {
            VenteResponse vente = venteService.getVenteById(venteId);
            byte[] ticket = ticketService.generateTicket(vente);

            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=thermal_" + venteId + ".bin");
            response.getOutputStream().write(ticket);

            log.info("Ticket thermique généré avec succès pour la vente ID: {}", venteId);

        } catch (Exception e) {
            log.error("Erreur lors de l'impression thermique du ticket pour la vente ID: " + venteId, e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

//    @GetMapping("/{venteId}/email")
//    public ResponseEntity<Void> emailTicket(@PathVariable Long venteId,
//                                            @RequestParam String email) {
//        log.info("Demande d'envoi du ticket par email pour la vente ID: {} à {}", venteId, email);
//
//        try {
//            VenteDto vente = venteService.getVenteById(venteId);
//            ticketService.sendTicketByEmail(vente, email);
//
//            log.info("Ticket envoyé avec succès par email pour la vente ID: {}", venteId);
//            return ResponseEntity.ok().build();
//
//        } catch (Exception e) {
//            log.error("Erreur lors de l'envoi du ticket par email pour la vente ID: " + venteId, e);
//            return ResponseEntity.internalServerError().build();
//        }
//    }

    @GetMapping("/stats/daily")
    @ResponseBody
    public ResponseEntity<?> getDailyTicketsStats(
            @RequestParam(required = false,name = "date") LocalDateTime date) {
        try {
            return ResponseEntity.ok(ticketService.getDailyTicketsStats(date));
        } catch (Exception e) {
            log.error("Erreur lors de la récupération des statistiques des tickets", e);
            return ResponseEntity.internalServerError().build();
        }
    }
}