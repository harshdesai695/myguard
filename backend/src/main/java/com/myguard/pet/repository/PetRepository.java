package com.myguard.pet.repository;

import com.myguard.pet.view.PetEntity;
import com.myguard.pet.view.VaccinationEntity;

import java.util.List;
import java.util.Optional;

public interface PetRepository {

    PetEntity savePet(PetEntity pet);
    Optional<PetEntity> findPetById(String id);
    PetEntity updatePet(PetEntity pet);
    void deletePet(String id);
    List<PetEntity> findPets(String societyId, int page, int size);
    long countPets(String societyId);

    VaccinationEntity saveVaccination(VaccinationEntity vaccination);
    List<VaccinationEntity> findVaccinationsByPetId(String petId);
}
