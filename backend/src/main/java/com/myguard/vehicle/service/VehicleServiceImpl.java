package com.myguard.vehicle.service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.vehicle.dto.request.AllocateParkingRequest;
import com.myguard.vehicle.dto.request.LogVisitorVehicleRequest;
import com.myguard.vehicle.dto.request.RegisterVehicleRequest;
import com.myguard.vehicle.dto.request.UpdateVehicleRequest;
import com.myguard.vehicle.dto.response.ParkingSlotResponse;
import com.myguard.vehicle.dto.response.VehicleResponse;
import com.myguard.vehicle.dto.response.VisitorVehicleLogResponse;
import com.myguard.vehicle.repository.VehicleRepository;
import com.myguard.vehicle.view.ParkingSlotEntity;
import com.myguard.vehicle.view.VehicleEntity;
import com.myguard.vehicle.view.VisitorVehicleLogEntity;
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
public class VehicleServiceImpl implements VehicleService {

    private final VehicleRepository vehicleRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    @Override
    public VehicleResponse registerVehicle(RegisterVehicleRequest request) {
        String uid = getCurrentUid();
        log.info("[VEHICLE] Registering vehicle: {}", request.getPlateNumber());

        VehicleEntity entity = VehicleEntity.builder()
                .plateNumber(request.getPlateNumber())
                .make(request.getMake())
                .model(request.getModel())
                .colour(request.getColour())
                .type(request.getType())
                .ownerUid(uid)
                .flatId(request.getFlatId())
                .societyId(request.getSocietyId())
                .createdAt(Instant.now())
                .build();

        VehicleEntity saved = vehicleRepository.saveVehicle(entity);
        log.info("[VEHICLE] Vehicle registered with ID: {}", saved.getId());
        return mapToVehicleResponse(saved);
    }

    @Override
    public PaginatedResponse<VehicleResponse> listMyVehicles(int page, int size) {
        String uid = getCurrentUid();
        List<VehicleEntity> vehicles = vehicleRepository.findVehiclesByOwner(uid, page, size);
        long total = vehicleRepository.countVehiclesByOwner(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<VehicleResponse> content = vehicles.stream()
                .map(this::mapToVehicleResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<VehicleResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public VehicleResponse getVehicleById(String id) {
        VehicleEntity entity = vehicleRepository.findVehicleById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found"));
        return mapToVehicleResponse(entity);
    }

    @Override
    public VehicleResponse updateVehicle(String id, UpdateVehicleRequest request) {
        VehicleEntity entity = vehicleRepository.findVehicleById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found"));

        if (request.getPlateNumber() != null) entity.setPlateNumber(request.getPlateNumber());
        if (request.getMake() != null) entity.setMake(request.getMake());
        if (request.getModel() != null) entity.setModel(request.getModel());
        if (request.getColour() != null) entity.setColour(request.getColour());
        if (request.getType() != null) entity.setType(request.getType());

        VehicleEntity updated = vehicleRepository.updateVehicle(entity);
        log.info("[VEHICLE] Vehicle updated: {}", id);
        return mapToVehicleResponse(updated);
    }

    @Override
    public void deleteVehicle(String id) {
        vehicleRepository.findVehicleById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found"));
        vehicleRepository.deleteVehicle(id);
        log.info("[VEHICLE] Vehicle deleted: {}", id);
    }

    @Override
    public VehicleResponse lookupByPlateNumber(String plateNumber) {
        VehicleEntity entity = vehicleRepository.findVehicleByPlateNumber(plateNumber)
                .orElseThrow(() -> new ResourceNotFoundException("Vehicle not found with plate number: " + plateNumber));
        return mapToVehicleResponse(entity);
    }

    @Override
    public ParkingSlotResponse allocateParking(AllocateParkingRequest request) {
        log.info("[VEHICLE] Allocating parking slot: {}", request.getSlotNumber());

        ParkingSlotEntity entity = ParkingSlotEntity.builder()
                .slotNumber(request.getSlotNumber())
                .blockZone(request.getBlockZone())
                .type(request.getType())
                .allocatedVehicleId(request.getAllocatedVehicleId())
                .societyId(request.getSocietyId())
                .createdAt(Instant.now())
                .build();

        ParkingSlotEntity saved = vehicleRepository.saveParkingSlot(entity);
        log.info("[VEHICLE] Parking slot allocated with ID: {}", saved.getId());
        return mapToParkingSlotResponse(saved);
    }

    @Override
    public PaginatedResponse<ParkingSlotResponse> listParkingSlots(int page, int size, String societyId) {
        List<ParkingSlotEntity> slots = vehicleRepository.findParkingSlots(societyId, page, size);
        long total = vehicleRepository.countParkingSlots(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<ParkingSlotResponse> content = slots.stream()
                .map(this::mapToParkingSlotResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<ParkingSlotResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public VisitorVehicleLogResponse logVisitorVehicle(LogVisitorVehicleRequest request) {
        log.info("[VEHICLE] Logging visitor vehicle: {}", request.getPlateNumber());

        VisitorVehicleLogEntity entity = VisitorVehicleLogEntity.builder()
                .plateNumber(request.getPlateNumber())
                .entryTime(Instant.now())
                .visitorEntryId(request.getVisitorEntryId())
                .societyId(request.getSocietyId())
                .createdAt(Instant.now())
                .build();

        VisitorVehicleLogEntity saved = vehicleRepository.saveVisitorVehicleLog(entity);
        log.info("[VEHICLE] Visitor vehicle log created with ID: {}", saved.getId());
        return mapToVisitorVehicleLogResponse(saved);
    }

    @Override
    public PaginatedResponse<VisitorVehicleLogResponse> listVisitorVehicleLogs(int page, int size, String societyId) {
        List<VisitorVehicleLogEntity> logs = vehicleRepository.findVisitorVehicleLogs(societyId, page, size);
        long total = vehicleRepository.countVisitorVehicleLogs(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<VisitorVehicleLogResponse> content = logs.stream()
                .map(this::mapToVisitorVehicleLogResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<VisitorVehicleLogResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    // --- Mappers ---

    private VehicleResponse mapToVehicleResponse(VehicleEntity entity) {
        return VehicleResponse.builder()
                .id(entity.getId()).plateNumber(entity.getPlateNumber())
                .make(entity.getMake()).model(entity.getModel())
                .colour(entity.getColour()).type(entity.getType())
                .ownerUid(entity.getOwnerUid()).flatId(entity.getFlatId())
                .parkingSlotId(entity.getParkingSlotId())
                .societyId(entity.getSocietyId()).createdAt(entity.getCreatedAt())
                .build();
    }

    private ParkingSlotResponse mapToParkingSlotResponse(ParkingSlotEntity entity) {
        return ParkingSlotResponse.builder()
                .id(entity.getId()).slotNumber(entity.getSlotNumber())
                .blockZone(entity.getBlockZone()).type(entity.getType())
                .allocatedVehicleId(entity.getAllocatedVehicleId())
                .societyId(entity.getSocietyId()).createdAt(entity.getCreatedAt())
                .build();
    }

    private VisitorVehicleLogResponse mapToVisitorVehicleLogResponse(VisitorVehicleLogEntity entity) {
        return VisitorVehicleLogResponse.builder()
                .id(entity.getId()).plateNumber(entity.getPlateNumber())
                .entryTime(entity.getEntryTime()).exitTime(entity.getExitTime())
                .visitorEntryId(entity.getVisitorEntryId())
                .societyId(entity.getSocietyId()).createdAt(entity.getCreatedAt())
                .build();
    }
}
