package com.myguard.material.service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.exception.ValidationException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.material.constants.MaterialConstants;
import com.myguard.material.dto.request.CreateGatepassRequest;
import com.myguard.material.dto.response.GatepassResponse;
import com.myguard.material.repository.MaterialRepository;
import com.myguard.material.view.GatepassEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class MaterialServiceImpl implements MaterialService {

    private final MaterialRepository materialRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    @Override
    public GatepassResponse createGatepass(CreateGatepassRequest request) {
        String uid = getCurrentUid();
        log.info("[MATERIAL] Creating gatepass: {}", request.getType());

        GatepassEntity entity = GatepassEntity.builder()
                .type(request.getType())
                .description(request.getDescription())
                .items(request.getItems())
                .vehicleNumber(request.getVehicleNumber())
                .expectedDate(request.getExpectedDate() != null ? request.getExpectedDate().toString() : null)
                .requestedBy(uid)
                .flatId(request.getFlatId())
                .status(MaterialConstants.STATUS_PENDING)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        GatepassEntity saved = materialRepository.saveGatepass(entity);
        log.info("[MATERIAL] Gatepass created with ID: {}", saved.getId());
        return mapToGatepassResponse(saved);
    }

    @Override
    public PaginatedResponse<GatepassResponse> listMyGatepasses(int page, int size) {
        String uid = getCurrentUid();
        List<GatepassEntity> gatepasses = materialRepository.findGatepassesByRequestedBy(uid, page, size);
        long total = materialRepository.countGatepassesByRequestedBy(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<GatepassResponse> content = gatepasses.stream()
                .map(this::mapToGatepassResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<GatepassResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public GatepassResponse getGatepassById(String id) {
        GatepassEntity entity = materialRepository.findGatepassById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Gatepass not found"));
        return mapToGatepassResponse(entity);
    }

    @Override
    public GatepassResponse approveGatepass(String id) {
        String uid = getCurrentUid();
        GatepassEntity entity = materialRepository.findGatepassById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Gatepass not found"));

        if (!MaterialConstants.STATUS_PENDING.equals(entity.getStatus())) {
            throw new ValidationException("Gatepass must be in pending status to approve");
        }

        entity.setStatus(MaterialConstants.STATUS_APPROVED);
        entity.setApprovedBy(uid);

        GatepassEntity updated = materialRepository.updateGatepass(entity);
        log.info("[MATERIAL] Gatepass approved: {}", id);
        return mapToGatepassResponse(updated);
    }

    @Override
    public GatepassResponse verifyGatepass(String id) {
        String uid = getCurrentUid();
        GatepassEntity entity = materialRepository.findGatepassById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Gatepass not found"));

        if (!MaterialConstants.STATUS_APPROVED.equals(entity.getStatus())) {
            throw new ValidationException("Gatepass must be approved before verification");
        }

        entity.setStatus(MaterialConstants.STATUS_VERIFIED);
        entity.setVerifiedBy(uid);
        entity.setVerifiedAt(Instant.now().toString());

        GatepassEntity updated = materialRepository.updateGatepass(entity);
        log.info("[MATERIAL] Gatepass verified: {}", id);
        return mapToGatepassResponse(updated);
    }

    @Override
    public PaginatedResponse<GatepassResponse> listAllGatepasses(int page, int size, String societyId, String status) {
        List<GatepassEntity> gatepasses = materialRepository.findAllGatepasses(societyId, page, size, status);
        long total = materialRepository.countAllGatepasses(societyId, status);
        int totalPages = (int) Math.ceil((double) total / size);

        List<GatepassResponse> content = gatepasses.stream()
                .map(this::mapToGatepassResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<GatepassResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    private GatepassResponse mapToGatepassResponse(GatepassEntity entity) {
        return GatepassResponse.builder()
                .id(entity.getId()).type(entity.getType())
                .description(entity.getDescription()).items(entity.getItems())
                .vehicleNumber(entity.getVehicleNumber())
                .expectedDate(entity.getExpectedDate() != null ? parseInstant(entity.getExpectedDate()) : null)
                .requestedBy(entity.getRequestedBy()).flatId(entity.getFlatId())
                .status(entity.getStatus()).approvedBy(entity.getApprovedBy())
                .verifiedBy(entity.getVerifiedBy())
                .verifiedAt(entity.getVerifiedAt() != null ? parseInstant(entity.getVerifiedAt()) : null)
                .societyId(entity.getSocietyId())
                .createdAt(entity.getCreatedAt() != null ? parseInstant(entity.getCreatedAt()) : null)
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
