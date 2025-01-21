package com.enokdev.boutique.repository;

import com.enokdev.boutique.model.LigneVente;
import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.model.Vente;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Repository
public class LigneVenteRepository {

    @PersistenceContext
    private EntityManager em;

    public LigneVente save(LigneVente ligneVente) {
        if (ligneVente.getId() == null) {
            em.persist(ligneVente);
            return ligneVente;
        }
        return em.merge(ligneVente);
    }

}