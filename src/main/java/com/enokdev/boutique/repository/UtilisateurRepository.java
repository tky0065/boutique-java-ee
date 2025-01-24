package com.enokdev.boutique.repository;

import com.enokdev.boutique.model.*;
import jakarta.persistence.NoResultException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Repository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import java.util.List;
import java.util.Optional;

@Repository
public class UtilisateurRepository {

    private static final Logger log = LogManager.getLogger(UtilisateurRepository.class);
    @PersistenceContext
    private EntityManager em;

    public Utilisateur save(Utilisateur utilisateur) {
        if (utilisateur.getId() == null) {
            em.persist(utilisateur);

            return utilisateur;
        }
        return em.merge(utilisateur);
    }

    public Optional<Utilisateur> findById(Long id) {
        return Optional.ofNullable(em.find(Utilisateur.class, id));
    }

    public List<Utilisateur> findAll() {
        return em.createQuery("SELECT u FROM Utilisateur u ORDER BY u.nom, u.prenom", Utilisateur.class)
                .getResultList();
    }

    public Optional<Utilisateur> findByIdentifiant(String identifiant) {
        try {
            TypedQuery<Utilisateur> query = em.createQuery(
                    "SELECT u FROM Utilisateur u WHERE u.identifiant = :identifiant",
                    Utilisateur.class);
            query.setParameter("identifiant", identifiant);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        }
    }



    public void delete(Utilisateur utilisateur) {
        em.remove(em.contains(utilisateur) ? utilisateur : em.merge(utilisateur));
    }




}

