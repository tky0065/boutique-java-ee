package com.enokdev.boutique.repository;

import com.enokdev.boutique.model.Utilisateur;
import com.enokdev.boutique.model.Vente;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.PersistenceContextType;
import jakarta.persistence.TypedQuery;
import jakarta.transaction.Transactional;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;
@Repository

public class VenteRepository {

    @PersistenceContext(type = PersistenceContextType.TRANSACTION)
    private EntityManager em;
    Logger log = LogManager.getLogger();

    @Transactional
    public Vente save(Vente vente) {
        try {
            if (vente.getId() == null) {
                em.persist(vente);
                em.flush();
                return vente;
            }
            return em.merge(vente);
        } catch (Exception e) {
            log.error("Erreur lors de la sauvegarde de la vente", e);
            throw e;
        }
    }
    public Optional<Vente> findById(Long id) {
        return Optional.ofNullable(em.find(Vente.class, id));
    }

    public List<Vente> findAll() {
        return em.createQuery(
                        "SELECT v FROM Vente v ORDER BY v.dateVente DESC", Vente.class)
                .getResultList();
    }

    public List<Vente> findByDateVenteBetween(LocalDateTime debut, LocalDateTime fin) {
        TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.dateVente BETWEEN :debut AND :fin ORDER BY v.dateVente DESC",
                Vente.class);
        query.setParameter("debut", debut);
        query.setParameter("fin", fin);
        return query.getResultList();
    }

    public BigDecimal getTotalVentesParPeriode(LocalDateTime debut, LocalDateTime fin) {
        TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(v.montantTotal), 0) FROM Vente v WHERE v.dateVente BETWEEN :debut AND :fin",
                BigDecimal.class);
        query.setParameter("debut", debut);
        query.setParameter("fin", fin);
        return query.getSingleResult();
    }
    public List<Vente> findByUtilisateur(Utilisateur utilisateur) {
        TypedQuery<Vente> query = em.createQuery(
                "SELECT v FROM Vente v WHERE v.utilisateur = :utilisateur ORDER BY v.dateVente DESC",
                Vente.class);
        query.setParameter("utilisateur", utilisateur);
        return query.getResultList();
    }



    public void delete(Vente vente) {
        em.remove(em.contains(vente) ? vente : em.merge(vente));
    }

    public List<Map> findTopProduitsVendus(LocalDateTime debutDateTime, LocalDateTime finDateTime, int i) {
        log.info("Recherche des top produits entre {} et {}", debutDateTime, finDateTime);
        List<Map> results = em.createQuery(
                        "SELECT new map(p.nom as nom, SUM(lv.quantite) as quantite) " +
                                "FROM LigneVente lv " +
                                "JOIN lv.produit p " +
                                "JOIN lv.vente v " +
                                "WHERE v.dateVente BETWEEN :debut AND :fin " +
                                "GROUP BY p.id, p.nom " +
                                "ORDER BY SUM(lv.quantite) DESC",
                        Map.class)
                .setParameter("debut", debutDateTime)
                .setParameter("fin", finDateTime)
                .setMaxResults(i)
                .getResultList();

        log.info("Résultats trouvés : {}", results);
        return results;
    }

    public Object findVentesQuotidiennes(LocalDateTime debut, LocalDateTime fin) {
        return em.createQuery(
                "SELECT new map(FUNCTION('DATE', v.dateVente) as date, SUM(v.montantTotal) as montant) " +
                        "FROM Vente v " +
                        "WHERE v.dateVente BETWEEN :debut AND :fin " +
                        "GROUP BY FUNCTION('DATE', v.dateVente) " +
                        "ORDER BY FUNCTION('DATE', v.dateVente) ASC")
                .setParameter("debut", debut)
                .setParameter("fin", fin)
                .getResultList();
    }

}