package com.myguard.pet.service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.pet.dto.request.AddVaccinationRequest;
import com.myguard.pet.dto.request.RegisterPetRequest;
import com.myguard.pet.dto.request.UpdatePetRequest;
import com.myguard.pet.dto.response.PetResponse;
import com.myguard.pet.dto.response.VaccinationResponse;
import com.myguard.pet.repository.PetRepository;
import com.myguard.pet.view.PetEntity;
import com.myguard.pet.view.VaccinationEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class PetServiceImpl implements PetService {

    private final PetRepository petRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    @Override
    public PetResponse registerPet(RegisterPetRequest request) {
        String uid = getCurrentUid();
        log.info("[PET] Registering pet: {}", request.getName());

        PetEntity entity = PetEntity.builder()
                .name(request.getName())
                .breed(request.getBreed())
                .type(request.getType())
                .age(request.getAge())
                .photoUrl(request.getPhotoUrl())
                .ownerUid(uid)
                .flatId(request.getFlatId())
                .vaccinationStatus("PENDING")
                .societyId(request.getSocietyId())
                .createdAt(Instant.now())
                .build();

        PetEntity saved = petRepository.savePet(entity);
        log.info("[PET] Pet registered with ID: {}", saved.getId());
        return mapToPetResponse(saved);
    }

    @Override
    public PaginatedResponse<PetResponse> listPets(int page, int size, String societyId) {
        List<PetEntity> pets = petRepository.findPets(societyId, page, size);
        long total = petRepository.countPets(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<PetResponse> content = pets.stream()
                .map(this::mapToPetResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<PetResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public PetResponse getPetById(String id) {
        PetEntity entity = petRepository.findPetById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found"));
        return mapToPetResponse(entity);
    }

    @Override
    public PetResponse updatePet(String id, UpdatePetRequest request) {
        PetEntity entity = petRepository.findPetById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found"));

        if (request.getName() != null) entity.setName(request.getName());
        if (request.getBreed() != null) entity.setBreed(request.getBreed());
        if (request.getType() != null) entity.setType(request.getType());
        if (request.getAge() != null) entity.setAge(request.getAge());
        if (request.getPhotoUrl() != null) entity.setPhotoUrl(request.getPhotoUrl());
        if (request.getVaccinationStatus() != null) entity.setVaccinationStatus(request.getVaccinationStatus());

        PetEntity updated = petRepository.updatePet(entity);
        log.info("[PET] Pet updated: {}", id);
        return mapToPetResponse(updated);
    }

    @Override
    public void deletePet(String id) {
        petRepository.findPetById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found"));
        petRepository.deletePet(id);
        log.info("[PET] Pet deleted: {}", id);
    }

    @Override
    public VaccinationResponse addVaccination(String petId, AddVaccinationRequest request) {
        petRepository.findPetById(petId)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found"));

        VaccinationEntity entity = VaccinationEntity.builder()
                .petId(petId)
                .vaccineName(request.getVaccineName())
                .dateAdministered(request.getDateAdministered())
                .nextDueDate(request.getNextDueDate())
                .vetName(request.getVetName())
                .certificateUrl(request.getCertificateUrl())
                .createdAt(Instant.now())
                .build();

        VaccinationEntity saved = petRepository.saveVaccination(entity);
        log.info("[PET] Vaccination added for pet: {}", petId);
        return mapToVaccinationResponse(saved);
    }

    @Override
    public List<VaccinationResponse> listVaccinations(String petId) {
        petRepository.findPetById(petId)
                .orElseThrow(() -> new ResourceNotFoundException("Pet not found"));

        return petRepository.findVaccinationsByPetId(petId).stream()
                .map(this::mapToVaccinationResponse)
                .collect(Collectors.toList());
    }

    private PetResponse mapToPetResponse(PetEntity entity) {
        return PetResponse.builder()
                .id(entity.getId()).name(entity.getName())
                .breed(entity.getBreed()).type(entity.getType())
                .age(entity.getAge()).photoUrl(entity.getPhotoUrl())
                .ownerUid(entity.getOwnerUid()).flatId(entity.getFlatId())
                .vaccinationStatus(entity.getVaccinationStatus())
                .societyId(entity.getSocietyId()).createdAt(entity.getCreatedAt())
                .build();
    }

    private VaccinationResponse mapToVaccinationResponse(VaccinationEntity entity) {
        return VaccinationResponse.builder()
                .id(entity.getId()).petId(entity.getPetId())
                .vaccineName(entity.getVaccineName())
                .dateAdministered(entity.getDateAdministered())
                .nextDueDate(entity.getNextDueDate())
                .vetName(entity.getVetName())
                .certificateUrl(entity.getCertificateUrl())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
