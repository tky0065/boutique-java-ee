package com.enokdev.boutique.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ErrorController {

    @GetMapping("/acces-refuse")
    public String accessDenied() {
        return "errors/acces-refuse";
    }
}