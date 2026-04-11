package com.myguard.pet.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.pet.dto.request.AddVaccinationRequest;
import com.myguard.pet.dto.request.RegisterPetRequest;
import com.myguard.pet.dto.request.UpdatePetRequest;
import com.myguard.pet.dto.response.PetResponse;
import com.myguard.pet.dto.response.VaccinationResponse;

import java.util.List;

public interface PetService {

    PetResponse registerPet(RegisterPetRequest request);
    PaginatedResponse<PetResponse> listPets(int page, int size, String societyId);
    PetResponse getPetById(String id);
    PetResponse updatePet(String id, UpdatePetRequest request);
    void deletePet(String id);
    VaccinationResponse addVaccination(String petId, AddVaccinationRequest request);
    List<VaccinationResponse> listVaccinations(String petId);
}
