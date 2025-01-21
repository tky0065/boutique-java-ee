package com.enokdev.boutique.service;
import com.enokdev.boutique.dto.LivraisonDto;
import com.enokdev.boutique.mapper.LivraisonMapper;

import com.enokdev.boutique.model.Livraison;
import com.enokdev.boutique.repository.LivraisonRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.transaction.annotation.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;


@Service
@Transactional
@RequiredArgsConstructor
public class LivraisonService {

    private final LivraisonRepository livraisonRepository;
    private final LivraisonMapper livraisonMapper;
    private final ProduitService produitService;

    public List<LivraisonDto> getAllLivraisons() {
        return livraisonRepository.findAll().stream()
                .map(livraisonMapper::toDto)
                .collect(Collectors.toList());
    }

    public LivraisonDto getLivraisonById(Long id) {
        return livraisonRepository.findById(id)
                .map(livraisonMapper::toDto)
                .orElseThrow(() -> new EntityNotFoundException("Livraison non trouvée avec l'ID : " + id));
    }

    public LivraisonDto saveLivraison(LivraisonDto livraisonDto) {
        Livraison livraison = livraisonMapper.toEntity(livraisonDto);

        // Mise à jour des stocks
        livraison.getLignesLivraison().forEach(ligne -> {
            produitService.updateStock(ligne.getProduit().getId(), ligne.getQuantite());
        });

        livraison = livraisonRepository.save(livraison);
        return livraisonMapper.toDto(livraison);
    }

    public List<LivraisonDto> getLivraisonsParPeriode(LocalDateTime debut, LocalDateTime fin) {
        return livraisonRepository.findByDateLivraisonBetween(debut, fin).stream()
                .map(livraisonMapper::toDto)
                .collect(Collectors.toList());
    }

    public void deleteLivraison(Long id) {

    }

    public BigDecimal getTotalLivraisonsParPeriode(LocalDateTime debutJour, LocalDateTime finJour) {
        return livraisonRepository.getTotalLivraisonsParPeriode(debutJour, finJour);
    }

    public Object getLivraisonsQuotidiennes(LocalDateTime debut, LocalDateTime fin) {
        return livraisonRepository.findLivraisonsQuotidiennes(debut, fin);
    }
}