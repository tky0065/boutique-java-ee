package com.enokdev.boutique.model;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Builder
@Table(name = "ventes")
public class Vente {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "date_vente", nullable = false)
    private LocalDateTime dateVente;

    @Column(name = "nom_client", nullable = false)
    private String nomClient;

    @Column(name = "montant_total", nullable = false)
    private BigDecimal montantTotal;

    @ManyToOne
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    @OneToMany(mappedBy = "vente", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LigneVente> lignesVente = new ArrayList<>();

    public void addLigneVente(LigneVente ligne) {
        lignesVente.add(ligne);
        ligne.setVente(this);
    }

    public void removeLigneVente(LigneVente ligne) {
        lignesVente.remove(ligne);
        ligne.setVente(null);
    }
}
