package com.enokdev.boutique.model;


import jakarta.persistence.*;
import lombok.*;


import java.time.LocalDate;
import java.util.Date;

@Entity
@Table(name = "utilisateurs")
@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Utilisateur {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "numero_matricule", nullable = false, unique = true)
    private String numeroMatricule;

    @Column(nullable = false)
    private String nom;

    @Column(nullable = false)
    private String prenom;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Sexe sexe;

    @Temporal(TemporalType.DATE)
    @Column(name = "date_naissance")
    private LocalDate dateNaissance;

    @Column(nullable = false, unique = true)
    private String identifiant;


    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse;

    public enum Sexe {
        HOMME,
        FEMME
    }
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role;

    public enum Role {
        ADMIN("Administrateur"),
        VENDEUR("Vendeur"),
        GESTIONNAIRE_STOCK("Gestionnaire de stock");

        private final String libelle;

        Role(String libelle) {
            this.libelle = libelle;
        }

        public String getLibelle() {
            return libelle;
        }
    }





}