package com.enokdev.boutique.service;

import com.enokdev.boutique.dto.UtilisateurDto;
import com.enokdev.boutique.mapper.UtilisateurMapper;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.repository.UtilisateurRepository;
import jakarta.persistence.EntityNotFoundException;
import org.mindrot.jbcrypt.BCrypt;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;


import java.sql.Date;
import java.util.Arrays;
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
        if (utilisateurDto.getRole() == null) {
            utilisateurDto.setRole(Utilisateur.Role.ADMIN);
        }
        utilisateur.setNumeroMatricule(utilisateurDto.getNumeroMatricule());
        utilisateur.setNom(utilisateurDto.getNom());
        utilisateur.setPrenom(utilisateurDto.getPrenom());
        utilisateur.setSexe(Utilisateur.Sexe.valueOf(utilisateurDto.getSexe()));
        utilisateur.setDateNaissance(Date.valueOf(utilisateurDto.getDateNaissance()).toLocalDate()); // Conversion de LocalDate en Date
        utilisateur.setIdentifiant(utilisateurDto.getIdentifiant());

        utilisateur.setRole(utilisateurDto.getRole());
        // Crypter le mot de passe avant de le sauvegarder
        String hashedPassword = BCrypt.hashpw(utilisateurDto.getMotDePasse(), BCrypt.gensalt());
        utilisateur.setMotDePasse(hashedPassword);

        utilisateurRepository.save(utilisateur);

    }

    public UtilisateurDto authenticateUtilisateur(String identifiant, String motDePasse) {
        Utilisateur utilisateur = utilisateurRepository.findByIdentifiant(identifiant)
                .orElseThrow(() -> new RuntimeException("Identifiant invalide"));

        // Vérifier le mot de passe
        if (!BCrypt.checkpw(motDePasse, utilisateur.getMotDePasse())) {
            throw new RuntimeException("Mot de passe incorrect");
        }

        return utilisateurMapper.toDto(utilisateur);
    }
    public void deleteUtilisateur(Long id) {
        utilisateurRepository.findById(id)
                .ifPresent(utilisateurRepository::delete);
    }
    public void updateProfil(UtilisateurDto utilisateurDto) {
        Utilisateur utilisateur = utilisateurRepository.findById(utilisateurDto.getId())
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé"));

        utilisateur.setNom(utilisateurDto.getNom());
        utilisateur.setPrenom(utilisateurDto.getPrenom());
        utilisateur.setSexe(Utilisateur.Sexe.valueOf(utilisateurDto.getSexe()));
        utilisateur.setIdentifiant(utilisateurDto.getIdentifiant());
        utilisateur.setRole(utilisateurDto.getRole());

        utilisateur.setDateNaissance(Date.valueOf(utilisateurDto.getDateNaissance()).toLocalDate());

        utilisateurRepository.save(utilisateur);
    }

    public void changePassword(Long userId, String oldPassword, String newPassword) {
        Utilisateur utilisateur = utilisateurRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("Utilisateur non trouvé"));

        // Vérifier l'ancien mot de passe
        if (!BCrypt.checkpw(oldPassword, utilisateur.getMotDePasse())) {
            throw new IllegalArgumentException("Ancien mot de passe incorrect");
        }

        // Crypter le nouveau mot de passe
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        utilisateur.setMotDePasse(hashedPassword);
        utilisateurRepository.save(utilisateur);
    }

    public List<Utilisateur.Role> getAllRoles() {
        return Arrays.asList(Utilisateur.Role.values());
    }
}
