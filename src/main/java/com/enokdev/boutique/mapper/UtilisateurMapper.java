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
                .build();
    }

   public Utilisateur toEntity(UtilisateurDto dto){

            if (dto == null) return null;

        return Utilisateur.builder()
                    .id(dto.getId())
                    .nom(dto.getNom())
                    .prenom(dto.getPrenom())
                    .dateNaissance(dto.getDateNaissance())
                    .identifiant(dto.getIdentifiant())
                    .sexe(Utilisateur.Sexe.valueOf(dto.getSexe()))
                    .numeroMatricule(dto.getNumeroMatricule())
                    .motDePasse(dto.getMotDePasse())
                    .build();
   }

    public   void updateEntityFromDto(UtilisateurDto dto,Utilisateur utilisateur){
        if (dto == null || utilisateur == null) return;

        utilisateur.setNom(dto.getNom());
        utilisateur.setPrenom(dto.getPrenom());
        utilisateur.setDateNaissance(dto.getDateNaissance());
        utilisateur.setIdentifiant(dto.getIdentifiant());
        utilisateur.setSexe(Utilisateur.Sexe.valueOf(dto.getSexe()));
        utilisateur.setNumeroMatricule(dto.getNumeroMatricule());
        utilisateur.setMotDePasse(dto.getMotDePasse());

    }
}