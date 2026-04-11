package com.myguard.pet.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.pet.dto.request.AddVaccinationRequest;
import com.myguard.pet.dto.request.RegisterPetRequest;
import com.myguard.pet.dto.request.UpdatePetRequest;
import com.myguard.pet.dto.response.PetResponse;
import com.myguard.pet.dto.response.VaccinationResponse;
import com.myguard.pet.service.PetService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/v1/pets")
@RequiredArgsConstructor
public class PetController {

    private final PetService petService;

    @PostMapping
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PetResponse>> registerPet(
            @Valid @RequestBody RegisterPetRequest request) {
        PetResponse response = petService.registerPet(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Pet registered"));
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<PetResponse>>> listPets(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<PetResponse> response = petService.listPets(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PetResponse>> getPet(@PathVariable String id) {
        PetResponse response = petService.getPetById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PetResponse>> updatePet(
            @PathVariable String id,
            @Valid @RequestBody UpdatePetRequest request) {
        PetResponse response = petService.updatePet(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Pet updated"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> deletePet(@PathVariable String id) {
        petService.deletePet(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Pet removed"));
    }

    @PostMapping("/{id}/vaccinations")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<VaccinationResponse>> addVaccination(
            @PathVariable String id,
            @Valid @RequestBody AddVaccinationRequest request) {
        VaccinationResponse response = petService.addVaccination(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Vaccination record added"));
    }

    @GetMapping("/{id}/vaccinations")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<List<VaccinationResponse>>> listVaccinations(@PathVariable String id) {
        List<VaccinationResponse> response = petService.listVaccinations(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
