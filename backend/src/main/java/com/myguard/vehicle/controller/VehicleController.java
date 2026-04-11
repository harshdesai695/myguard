package com.myguard.vehicle.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.vehicle.dto.request.AllocateParkingRequest;
import com.myguard.vehicle.dto.request.LogVisitorVehicleRequest;
import com.myguard.vehicle.dto.request.RegisterVehicleRequest;
import com.myguard.vehicle.dto.request.UpdateVehicleRequest;
import com.myguard.vehicle.dto.response.ParkingSlotResponse;
import com.myguard.vehicle.dto.response.VehicleResponse;
import com.myguard.vehicle.dto.response.VisitorVehicleLogResponse;
import com.myguard.vehicle.service.VehicleService;
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

@Slf4j
@RestController
@RequestMapping("/api/v1/vehicles")
@RequiredArgsConstructor
public class VehicleController {

    private final VehicleService vehicleService;

    @PostMapping
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<VehicleResponse>> registerVehicle(
            @Valid @RequestBody RegisterVehicleRequest request) {
        VehicleResponse response = vehicleService.registerVehicle(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Vehicle registered"));
    }

    @GetMapping
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<VehicleResponse>>> listMyVehicles(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<VehicleResponse> response = vehicleService.listMyVehicles(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<VehicleResponse>> getVehicle(@PathVariable String id) {
        VehicleResponse response = vehicleService.getVehicleById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<VehicleResponse>> updateVehicle(
            @PathVariable String id,
            @Valid @RequestBody UpdateVehicleRequest request) {
        VehicleResponse response = vehicleService.updateVehicle(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Vehicle updated"));
    }

    @DeleteMapping("/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> deleteVehicle(@PathVariable String id) {
        vehicleService.deleteVehicle(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Vehicle deregistered"));
    }

    @GetMapping("/lookup/{plateNumber}")
    @PreAuthorize("hasAnyRole('GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<VehicleResponse>> lookupVehicle(@PathVariable String plateNumber) {
        VehicleResponse response = vehicleService.lookupByPlateNumber(plateNumber);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/parking")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<ParkingSlotResponse>> allocateParking(
            @Valid @RequestBody AllocateParkingRequest request) {
        ParkingSlotResponse response = vehicleService.allocateParking(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Parking allocated"));
    }

    @GetMapping("/parking")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<ParkingSlotResponse>>> listParkingSlots(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<ParkingSlotResponse> response = vehicleService.listParkingSlots(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/visitor-log")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<VisitorVehicleLogResponse>> logVisitorVehicle(
            @Valid @RequestBody LogVisitorVehicleRequest request) {
        VisitorVehicleLogResponse response = vehicleService.logVisitorVehicle(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Visitor vehicle logged"));
    }

    @GetMapping("/visitor-log")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<VisitorVehicleLogResponse>>> listVisitorVehicleLogs(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<VisitorVehicleLogResponse> response = vehicleService.listVisitorVehicleLogs(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
