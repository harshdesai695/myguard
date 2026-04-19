package com.myguard.emergency.service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.emergency.constants.EmergencyConstants;
import com.myguard.emergency.dto.request.CreateEmergencyContactRequest;
import com.myguard.emergency.dto.request.TriggerPanicRequest;
import com.myguard.emergency.dto.request.UpdateEmergencyContactRequest;
import com.myguard.emergency.dto.response.ChildAlertResponse;
import com.myguard.emergency.dto.response.EmergencyContactResponse;
import com.myguard.emergency.dto.response.PanicAlertResponse;
import com.myguard.emergency.repository.EmergencyRepository;
import com.myguard.emergency.view.ChildAlertEntity;
import com.myguard.emergency.view.EmergencyContactEntity;
import com.myguard.emergency.view.PanicAlertEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class EmergencyServiceImpl implements EmergencyService {

    private final EmergencyRepository emergencyRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    // --- Panic Alerts ---

    @Override
    public PanicAlertResponse triggerPanic(TriggerPanicRequest request) {
        String uid = getCurrentUid();
        log.info("[EMERGENCY] Panic triggered by user: {}", uid);

        PanicAlertEntity entity = PanicAlertEntity.builder()
                .flatId(request.getFlatId())
                .triggeredBy(uid)
                .timestamp(Instant.now().toString())
                .location(request.getLocation())
                .status(EmergencyConstants.STATUS_ACTIVE)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        PanicAlertEntity saved = emergencyRepository.savePanicAlert(entity);
        log.info("[EMERGENCY] Panic alert created with ID: {}", saved.getId());
        return mapToPanicAlertResponse(saved);
    }

    @Override
    public PaginatedResponse<PanicAlertResponse> listActivePanicAlerts(int page, int size, String societyId) {
        List<PanicAlertEntity> alerts = emergencyRepository.findActivePanicAlerts(societyId, page, size);
        long total = emergencyRepository.countActivePanicAlerts(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<PanicAlertResponse> content = alerts.stream()
                .map(this::mapToPanicAlertResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<PanicAlertResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public PanicAlertResponse resolvePanicAlert(String id) {
        String uid = getCurrentUid();
        PanicAlertEntity entity = emergencyRepository.findPanicAlertById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Panic alert not found"));

        entity.setStatus(EmergencyConstants.STATUS_RESOLVED);
        entity.setResolvedBy(uid);
        entity.setResolvedAt(Instant.now().toString());

        PanicAlertEntity updated = emergencyRepository.updatePanicAlert(entity);
        log.info("[EMERGENCY] Panic alert resolved: {}", id);
        return mapToPanicAlertResponse(updated);
    }

    // --- Emergency Contacts ---

    @Override
    public EmergencyContactResponse addEmergencyContact(CreateEmergencyContactRequest request) {
        log.info("[EMERGENCY] Adding emergency contact: {}", request.getName());

        EmergencyContactEntity entity = EmergencyContactEntity.builder()
                .name(request.getName())
                .phone(request.getPhone())
                .type(request.getType())
                .address(request.getAddress())
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        EmergencyContactEntity saved = emergencyRepository.saveEmergencyContact(entity);
        log.info("[EMERGENCY] Emergency contact created with ID: {}", saved.getId());
        return mapToEmergencyContactResponse(saved);
    }

    @Override
    public PaginatedResponse<EmergencyContactResponse> listEmergencyContacts(int page, int size, String societyId) {
        List<EmergencyContactEntity> contacts = emergencyRepository.findEmergencyContacts(societyId, page, size);
        long total = emergencyRepository.countEmergencyContacts(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<EmergencyContactResponse> content = contacts.stream()
                .map(this::mapToEmergencyContactResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<EmergencyContactResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public EmergencyContactResponse updateEmergencyContact(String id, UpdateEmergencyContactRequest request) {
        EmergencyContactEntity entity = emergencyRepository.findEmergencyContactById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Emergency contact not found"));

        if (request.getName() != null) entity.setName(request.getName());
        if (request.getPhone() != null) entity.setPhone(request.getPhone());
        if (request.getType() != null) entity.setType(request.getType());
        if (request.getAddress() != null) entity.setAddress(request.getAddress());

        EmergencyContactEntity updated = emergencyRepository.updateEmergencyContact(entity);
        log.info("[EMERGENCY] Emergency contact updated: {}", id);
        return mapToEmergencyContactResponse(updated);
    }

    @Override
    public void deleteEmergencyContact(String id) {
        emergencyRepository.findEmergencyContactById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Emergency contact not found"));
        emergencyRepository.deleteEmergencyContact(id);
        log.info("[EMERGENCY] Emergency contact deleted: {}", id);
    }

    // --- Mappers ---

    private PanicAlertResponse mapToPanicAlertResponse(PanicAlertEntity entity) {
        return PanicAlertResponse.builder()
                .id(entity.getId())
                .flatId(entity.getFlatId())
                .triggeredBy(entity.getTriggeredBy())
                .timestamp(parseInstant(entity.getTimestamp()))
                .location(entity.getLocation())
                .status(entity.getStatus())
                .resolvedBy(entity.getResolvedBy())
                .resolvedAt(parseInstant(entity.getResolvedAt()))
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private EmergencyContactResponse mapToEmergencyContactResponse(EmergencyContactEntity entity) {
        return EmergencyContactResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .phone(entity.getPhone())
                .type(entity.getType())
                .address(entity.getAddress())
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    @Override
    public PaginatedResponse<ChildAlertResponse> getChildAlerts(int page, int size) {
        String uid = getCurrentUid();
        log.info("[EMERGENCY] Fetching child alerts for user: {}", uid);
        List<ChildAlertEntity> alerts = emergencyRepository.findChildAlertsByResidentUid(uid, page, size);
        long total = emergencyRepository.countChildAlertsByResidentUid(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<ChildAlertResponse> content = alerts.stream()
                .map(this::mapToChildAlertResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<ChildAlertResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    private ChildAlertResponse mapToChildAlertResponse(ChildAlertEntity entity) {
        return ChildAlertResponse.builder()
                .id(entity.getId())
                .childName(entity.getChildName())
                .flatId(entity.getFlatId())
                .residentUid(entity.getResidentUid())
                .type(entity.getType())
                .gateId(entity.getGateId())
                .societyId(entity.getSocietyId())
                .timestamp(parseInstant(entity.getTimestamp()))
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
