package com.enokdev.boutique.service;

import com.enokdev.boutique.dto.UtilisateurDto;
import com.enokdev.boutique.mapper.UtilisateurMapper;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.repository.UtilisateurRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;


import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class UtilisateurService {

    private final UtilisateurRepository utilisateurRepository;
    private final UtilisateurMapper utilisateurMapper;

    public List<UtilisateurDto> getAllUtilisateurs() {
        return utilisateurRepository.findAll().stream()
                .map(utilisateurMapper::toDto)
                .collect(Collectors.toList());
    }

    public UtilisateurDto getUtilisateurById(Long id) {
        return utilisateurRepository.findById(id)
                .map(utilisateurMapper::toDto)
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé avec l'ID : " + id));
    }

    public void saveUtilisateur(UtilisateurDto utilisateurDto) {
        Utilisateur utilisateur = new Utilisateur();
        utilisateur.setNumeroMatricule(utilisateurDto.getNumeroMatricule());
        utilisateur.setNom(utilisateurDto.getNom());
        utilisateur.setPrenom(utilisateurDto.getPrenom());
        utilisateur.setSexe(Utilisateur.Sexe.valueOf(utilisateurDto.getSexe()));
        utilisateur.setDateNaissance(Date.valueOf(utilisateurDto.getDateNaissance()).toLocalDate()); // Conversion de LocalDate en Date
        utilisateur.setIdentifiant(utilisateurDto.getIdentifiant());
        utilisateur.setMotDePasse(utilisateurDto.getMotDePasse());
        utilisateurRepository.save(utilisateur);

    }

    public UtilisateurDto authenticateUtilisateur(String identifiant, String motDePasse) {
        return utilisateurRepository.findByIdentifiantAndMotDePasse(identifiant, motDePasse)
                .map(utilisateurMapper::toDto)
                .orElseThrow(() -> new RuntimeException("Identifiants invalides"));
    }
}
