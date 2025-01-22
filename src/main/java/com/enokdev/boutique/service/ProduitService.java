package com.enokdev.boutique.service;

import com.enokdev.boutique.dto.ProduitDto;
import com.enokdev.boutique.mapper.ProduitMapper;
import com.enokdev.boutique.model.Produit;
import com.enokdev.boutique.repository.ProduitRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
@Service
@Transactional
@RequiredArgsConstructor
public class ProduitService {

    private final ProduitRepository produitRepository;
    private final ProduitMapper produitMapper;

    public List<ProduitDto> getAllProduits() {
        return produitRepository.findAll().stream()
                .map(produitMapper::toDto)
                .collect(Collectors.toList());
    }

    public ProduitDto getProduitById(Long id) {
        // return to the ProduitDto witth Product.toDto() method
        return  produitRepository.findById(id)
                .map(produitMapper::toDto)
                .orElseThrow(() -> new EntityNotFoundException("Produit non trouvé avec l'ID : " + id));

    }

    public void saveProduit(ProduitDto produitDto) {
        Produit produit = produitMapper.toEntity(produitDto);
        produit = produitRepository.save(produit);
        produitMapper.toDto(produit);
    }

    public void updateProduit(Long id, ProduitDto produitDto) {
        Produit produit = produitRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Produit non trouvé avec l'ID : " + id));

        produitMapper.updateEntityFromDto(produitDto, produit);
        produit = produitRepository.save(produit);
        produitMapper.toDto(produit);
    }

    public List<ProduitDto> rechercherParNom(String nom) {
        return produitRepository.findByNomContainingIgnoreCase(nom).stream()
                .map(produitMapper::toDto)
                .collect(Collectors.toList());
    }

    public void deleteProduit(Long id) {
        produitRepository.deleteById(id);
    }

    public List<ProduitDto> getProduitsSousSeuilAlerte() {
        return produitRepository.findAllWithLowStock().stream()
                .map(produitMapper::toDto)
                .collect(Collectors.toList());
    }

    public void updateStock(Long produitId, int quantite) {
        Produit produit = produitRepository.findById(produitId)
                .orElseThrow(() -> new EntityNotFoundException("Produit non trouvé avec l'ID : " + produitId));

        produit.setQuantiteStock(produit.getQuantiteStock() + quantite);
        produitRepository.save(produit);
    }

    public Long getTotalProduits() {
        return produitRepository.getTotalProduits();
    }


    public Optional<ProduitDto> findById(@NotNull(message = "Le produit est obligatoire") Long produitId) {
        return
                produitRepository.findById(produitId)
                .map(produitMapper::toDto);
    }

    @Transactional(readOnly = true)
    public BigDecimal calculateValeurStock() {
        List<Produit> produits = produitRepository.findAll();
        return produits.stream()
                .map(produit -> {
                    if (produit.getPrixUnitaire() == null || produit.getQuantiteStock() == null) {
                        return BigDecimal.ZERO;
                    }
                    return produit.getPrixUnitaire()
                            .multiply(BigDecimal.valueOf(produit.getQuantiteStock()));
                })
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
}
