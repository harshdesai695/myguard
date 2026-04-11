package com.myguard.emergency.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.emergency.dto.request.CreateEmergencyContactRequest;
import com.myguard.emergency.dto.request.TriggerPanicRequest;
import com.myguard.emergency.dto.request.UpdateEmergencyContactRequest;
import com.myguard.emergency.dto.response.EmergencyContactResponse;
import com.myguard.emergency.dto.response.PanicAlertResponse;
import com.myguard.emergency.service.EmergencyService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/emergency")
@RequiredArgsConstructor
public class EmergencyController {

    private final EmergencyService emergencyService;

    // --- Panic Alerts ---

    @PostMapping("/panic")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PanicAlertResponse>> triggerPanic(
            @Valid @RequestBody TriggerPanicRequest request) {
        PanicAlertResponse response = emergencyService.triggerPanic(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Panic alert triggered"));
    }

    @GetMapping("/panic")
    @PreAuthorize("hasAnyRole('ADMIN', 'GUARD')")
    public ResponseEntity<ApiResponse<PaginatedResponse<PanicAlertResponse>>> listActivePanics(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<PanicAlertResponse> response = emergencyService.listActivePanicAlerts(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/panic/{id}/resolve")
    @PreAuthorize("hasAnyRole('ADMIN', 'GUARD')")
    public ResponseEntity<ApiResponse<PanicAlertResponse>> resolvePanic(@PathVariable String id) {
        PanicAlertResponse response = emergencyService.resolvePanicAlert(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Panic alert resolved"));
    }

    // --- Emergency Contacts ---

    @PostMapping("/contacts")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<EmergencyContactResponse>> addContact(
            @Valid @RequestBody CreateEmergencyContactRequest request) {
        EmergencyContactResponse response = emergencyService.addEmergencyContact(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Emergency contact added"));
    }

    @GetMapping("/contacts")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<EmergencyContactResponse>>> listContacts(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<EmergencyContactResponse> response = emergencyService.listEmergencyContacts(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/contacts/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<EmergencyContactResponse>> updateContact(
            @PathVariable String id,
            @Valid @RequestBody UpdateEmergencyContactRequest request) {
        EmergencyContactResponse response = emergencyService.updateEmergencyContact(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Emergency contact updated"));
    }

    @DeleteMapping("/contacts/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteContact(@PathVariable String id) {
        emergencyService.deleteEmergencyContact(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Emergency contact deleted"));
    }
}
