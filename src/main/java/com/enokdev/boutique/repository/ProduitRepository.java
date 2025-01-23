package com.enokdev.boutique.repository;


import com.enokdev.boutique.model.Produit;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
@Repository
public class ProduitRepository {

    @PersistenceContext
    private EntityManager em;

    public Produit save(Produit produit) {
        if (produit.getId() == null) {
            em.persist(produit);
            return produit;
        }
        return em.merge(produit);
    }

    public Optional<Produit> findById(Long id) {
        return Optional.ofNullable(em.find(Produit.class, id));
    }

    public List<Produit> findAll() {
        return em.createQuery("SELECT p FROM Produit p ORDER BY p.nom", Produit.class)
                .getResultList();
    }

    public List<Produit> findByNomContainingIgnoreCase(String nom) {
        TypedQuery<Produit> query = em.createQuery(
                "SELECT p FROM Produit p WHERE LOWER(p.nom) LIKE LOWER(:nom) ORDER BY p.nom",
                Produit.class);
        query.setParameter("nom", "%" + nom + "%");
        return query.getResultList();
    }

    public void delete(Produit produit) {
        em.remove(em.contains(produit) ? produit : em.merge(produit));
    }

    public void deleteById(Long id) {
        findById(id).ifPresent(this::delete);
    }

    public List<Produit> findAllWithLowStock() {
        return em.createQuery(
                        "SELECT p FROM Produit p WHERE p.quantiteStock <= p.seuilAlerte ORDER BY p.quantiteStock",
                        Produit.class)
                .getResultList();
    }

    public List<Produit> findByQuantiteStockLessThan(Integer quantite) {
        TypedQuery<Produit> query = em.createQuery(
                "SELECT p FROM Produit p WHERE p.quantiteStock < :quantite ORDER BY p.quantiteStock",
                Produit.class);
        query.setParameter("quantite", quantite);
        return query.getResultList();
    }

    public void updateStock(Long id, Integer quantite) {
        em.createQuery(
                        "UPDATE Produit p SET p.quantiteStock = p.quantiteStock + :quantite WHERE p.id = :id")
                .setParameter("quantite", quantite)
                .setParameter("id", id)
                .executeUpdate();
    }

    public Long getTotalProduits() {
        return  em.createQuery("SELECT COUNT(p) FROM Produit p", Long.class)
                .getSingleResult();
    }

    public List<Produit> findByQuantiteStockLessThanOrEqualToSeuilAlerte() {
        return em.createQuery(
                        "SELECT p FROM Produit p WHERE p.quantiteStock <= p.seuilAlerte ORDER BY p.quantiteStock",
                        Produit.class)
                .getResultList();
    }

    public Integer countByQuantiteStockLessThanOrEqualToSeuilAlerte() {
        Long count = em.createQuery(
                        "SELECT COUNT(p) FROM Produit p WHERE p.quantiteStock <= p.seuilAlerte",
                        Long.class)
                .getSingleResult();
        return count.intValue();
    }
    public List<Produit> findAllWithPagination(int startIndex, int pageSize) {
        return em.createQuery("SELECT p FROM Produit p ORDER BY p.nom", Produit.class)
                .setFirstResult(startIndex)
                .setMaxResults(pageSize)
                .getResultList();
    }

    public List<Produit> findByNomContainingWithPagination(String nom, int startIndex, int pageSize) {
        return em.createQuery(
                        "SELECT p FROM Produit p WHERE LOWER(p.nom) LIKE LOWER(:nom) ORDER BY p.nom",
                        Produit.class)
                .setParameter("nom", "%" + nom + "%")
                .setFirstResult(startIndex)
                .setMaxResults(pageSize)
                .getResultList();
    }



    public Long countByNomContainingIgnoreCase(String nom) {
        return em.createQuery(
                        "SELECT COUNT(p) FROM Produit p WHERE LOWER(p.nom) LIKE LOWER(:nom)",
                        Long.class)
                .setParameter("nom", "%" + nom + "%")
                .getSingleResult();
    }
}
