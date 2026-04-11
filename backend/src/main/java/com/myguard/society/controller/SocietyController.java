package com.myguard.society.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.society.dto.request.CreateFlatRequest;
import com.myguard.society.dto.request.CreateSocietyRequest;
import com.myguard.society.dto.request.UpdateFlatRequest;
import com.myguard.society.dto.request.UpdateSocietyRequest;
import com.myguard.society.dto.response.FlatResponse;
import com.myguard.society.dto.response.SocietyResponse;
import com.myguard.society.service.SocietyService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
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
@RequestMapping("/api/v1/societies")
@RequiredArgsConstructor
public class SocietyController {

    private final SocietyService societyService;

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<SocietyResponse>> createSociety(
            @Valid @RequestBody CreateSocietyRequest request) {
        SocietyResponse response = societyService.createSociety(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Society created successfully"));
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<SocietyResponse>>> listSocieties(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<SocietyResponse> response = societyService.listSocieties(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<SocietyResponse>> getSociety(@PathVariable String id) {
        SocietyResponse response = societyService.getSocietyById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<SocietyResponse>> updateSociety(
            @PathVariable String id,
            @Valid @RequestBody UpdateSocietyRequest request) {
        SocietyResponse response = societyService.updateSociety(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Society updated successfully"));
    }

    @PostMapping("/{id}/flats")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<FlatResponse>> addFlat(
            @PathVariable String id,
            @Valid @RequestBody CreateFlatRequest request) {
        FlatResponse response = societyService.addFlat(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Flat added successfully"));
    }

    @GetMapping("/{id}/flats")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<FlatResponse>>> listFlats(
            @PathVariable String id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<FlatResponse> response = societyService.listFlats(id, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}/flats/{flatId}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<FlatResponse>> getFlat(
            @PathVariable String id,
            @PathVariable String flatId) {
        FlatResponse response = societyService.getFlatById(id, flatId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{id}/flats/{flatId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<FlatResponse>> updateFlat(
            @PathVariable String id,
            @PathVariable String flatId,
            @Valid @RequestBody UpdateFlatRequest request) {
        FlatResponse response = societyService.updateFlat(id, flatId, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Flat updated successfully"));
    }

    @GetMapping("/{id}/flats/{flatId}/residents")
    @PreAuthorize("hasAnyRole('ADMIN', 'GUARD')")
    public ResponseEntity<ApiResponse<List<String>>> getResidentsInFlat(
            @PathVariable String id,
            @PathVariable String flatId) {
        List<String> residents = societyService.getResidentsInFlat(id, flatId);
        return ResponseEntity.ok(ApiResponse.success(residents));
    }
}
