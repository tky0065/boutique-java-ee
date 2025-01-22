package com.enokdev.boutique.controller;

import com.enokdev.boutique.dto.AlerteStockDto;
import com.enokdev.boutique.service.ProduitService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/alertes")
@RequiredArgsConstructor
public class AlerteController {

    private final ProduitService produitService;

    @GetMapping
    public String listAlertes(Model model) {
        List<AlerteStockDto> alertes = produitService.getProduitsEnAlerte();
        model.addAttribute("alertes", alertes);
        return "alertes/alertes";
    }
}