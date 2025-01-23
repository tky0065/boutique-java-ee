package com.enokdev.boutique.service;

import com.enokdev.boutique.dto.AlerteStockDto;
import com.enokdev.boutique.dto.PageResponse;
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


    public PageResponse<ProduitDto> getAllProduitsPagines(int page, int size) {
        int startIndex = page * size;

        // Récupérer le nombre total d'éléments
        Long total = produitRepository.getTotalProduits();

        // Récupérer une page d'éléments
        List<Produit> produits = produitRepository.findAllWithPagination(startIndex, size);

        // Convertir en DTOs
        List<ProduitDto> produitDtos = produits.stream()
                .map(produitMapper::toDto)
                .collect(Collectors.toList());

        return new PageResponse<>(produitDtos, page, size, total);
    }

    public PageResponse<ProduitDto> rechercherParNomPagine(String nom, int page, int size) {
        int startIndex = page * size;

        // Récupérer le nombre total d'éléments correspondant à la recherche
        Long total = produitRepository.countByNomContainingIgnoreCase(nom);

        // Récupérer une page d'éléments correspondant à la recherche
        List<Produit> produits = produitRepository.findByNomContainingWithPagination(nom, startIndex, size);

        // Convertir en DTOs
        List<ProduitDto> produitDtos = produits.stream()
                .map(produitMapper::toDto)
                .collect(Collectors.toList());

        return new PageResponse<>(produitDtos, page, size, total);
    }

    public void deleteProduit(Long id) {
        produitRepository.deleteById(id);
    }

    public List<ProduitDto> getProduitsSousSeuilAlerte() {
        return produitRepository.findAllWithLowStock().stream()
                .map(produitMapper::toDto)
                .collect(Collectors.toList());
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

    public List<AlerteStockDto> getProduitsEnAlerte() {
        return produitRepository.findByQuantiteStockLessThanOrEqualToSeuilAlerte().stream()
                .map(produit -> AlerteStockDto.builder()
                        .produitId(produit.getId())
                        .nom(produit.getNom())
                        .quantiteStock(produit.getQuantiteStock())
                        .seuilAlerte(produit.getSeuilAlerte())
                        .build())
                .collect(Collectors.toList());
    }


}
