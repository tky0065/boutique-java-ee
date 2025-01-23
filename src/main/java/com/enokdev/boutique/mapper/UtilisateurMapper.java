package com.enokdev.boutique.mapper;

import com.enokdev.boutique.dto.UtilisateurDto;
import com.enokdev.boutique.model.Utilisateur;

import org.springframework.stereotype.Service;

@Service
public class UtilisateurMapper {

    public  UtilisateurDto toDto(Utilisateur utilisateur){
        return UtilisateurDto.builder()
                .id(utilisateur.getId())
                .nom(utilisateur.getNom())
                .prenom(utilisateur.getPrenom())
                .dateNaissance(utilisateur.getDateNaissance())
                .identifiant(utilisateur.getIdentifiant())
                .sexe(String.valueOf(utilisateur.getSexe()))
                .numeroMatricule(utilisateur.getNumeroMatricule())
                .motDePasse(utilisateur.getMotDePasse())
                .role(utilisateur.getRole())
                .build();
    }

}