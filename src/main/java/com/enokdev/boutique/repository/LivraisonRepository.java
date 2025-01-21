package com.enokdev.boutique.repository;

import com.enokdev.boutique.model.Livraison;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public class LivraisonRepository {

    @PersistenceContext
    private EntityManager em;

    public Livraison save(Livraison livraison) {
        if (livraison.getId() == null) {
            em.persist(livraison);
            return livraison;
        }
        return em.merge(livraison);
    }

    public Optional<Livraison> findById(Long id) {
        return Optional.ofNullable(em.find(Livraison.class, id));
    }

    public List<Livraison> findAll() {
        return em.createQuery(
                        "SELECT l FROM Livraison l ORDER BY l.dateLivraison DESC", Livraison.class)
                .getResultList();
    }

    public List<Livraison> findByDateLivraisonBetween(LocalDateTime debut, LocalDateTime fin) {
        TypedQuery<Livraison> query = em.createQuery(
                "SELECT l FROM Livraison l WHERE l.dateLivraison BETWEEN :debut AND :fin ORDER BY l.dateLivraison DESC",
                Livraison.class);
        query.setParameter("debut", debut);
        query.setParameter("fin", fin);
        return query.getResultList();
    }

    public List<Livraison> findByFournisseur(String fournisseur) {
        TypedQuery<Livraison> query = em.createQuery(
                "SELECT l FROM Livraison l WHERE LOWER(l.nomFournisseur) LIKE LOWER(:fournisseur) ORDER BY l.dateLivraison DESC",
                Livraison.class);
        query.setParameter("fournisseur", "%" + fournisseur + "%");
        return query.getResultList();
    }

    public List<Livraison> findByFournisseurAndDateLivraisonBetween(
            String fournisseur, LocalDateTime debut, LocalDateTime fin) {
        TypedQuery<Livraison> query = em.createQuery(
                "SELECT l FROM Livraison l WHERE LOWER(l.nomFournisseur) LIKE LOWER(:fournisseur) " +
                        "AND l.dateLivraison BETWEEN :debut AND :fin ORDER BY l.dateLivraison DESC",
                Livraison.class);
        query.setParameter("fournisseur", "%" + fournisseur + "%");
        query.setParameter("debut", debut);
        query.setParameter("fin", fin);
        return query.getResultList();
    }

    public BigDecimal getTotalLivraisonsParPeriode(LocalDateTime debut, LocalDateTime fin) {
        TypedQuery<BigDecimal> query = em.createQuery(
                "SELECT COALESCE(SUM(l.montantTotal), 0) FROM Livraison l WHERE l.dateLivraison BETWEEN :debut AND :fin",
                BigDecimal.class);
        query.setParameter("debut", debut);
        query.setParameter("fin", fin);
        return query.getSingleResult();
    }

    public void delete(Livraison livraison) {
        em.remove(em.contains(livraison) ? livraison : em.merge(livraison));
    }

    public Object findLivraisonsQuotidiennes(LocalDateTime debut, LocalDateTime fin) {
            return em.createQuery(
                    "SELECT DATE(l.dateLivraison) AS date, COUNT(l) AS nombreLivraisons, SUM(l.montantTotal) AS montantTotal " +
                            "FROM Livraison l WHERE l.dateLivraison BETWEEN :debut AND :fin " +
                            "GROUP BY DATE(l.dateLivraison) ORDER BY DATE(l.dateLivraison) ASC")
                    .setParameter("debut", debut)
                    .setParameter("fin", fin)
                    .getResultList();
    }
}