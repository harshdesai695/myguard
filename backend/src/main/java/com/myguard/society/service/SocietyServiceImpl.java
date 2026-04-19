package com.myguard.society.service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.society.constants.SocietyConstants;
import com.myguard.society.dto.request.CreateFlatRequest;
import com.myguard.society.dto.request.CreateSocietyRequest;
import com.myguard.society.dto.request.UpdateFlatRequest;
import com.myguard.society.dto.request.UpdateSocietyRequest;
import com.myguard.society.dto.response.FlatResponse;
import com.myguard.society.dto.response.SocietyResponse;
import com.myguard.society.repository.SocietyRepository;
import com.myguard.society.view.FlatEntity;
import com.myguard.society.view.SocietyEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class SocietyServiceImpl implements SocietyService {

    private final SocietyRepository societyRepository;

    @Override
    public SocietyResponse createSociety(CreateSocietyRequest request) {
        log.info("[SOCIETY] Creating new society: {}", request.getName());

        SocietyEntity entity = SocietyEntity.builder()
                .name(request.getName())
                .address(request.getAddress())
                .city(request.getCity())
                .state(request.getState())
                .pincode(request.getPincode())
                .totalBlocks(request.getTotalBlocks())
                .totalFlats(request.getTotalFlats())
                .logoUrl(request.getLogoUrl())
                .status(SocietyConstants.STATUS_ACTIVE)
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        SocietyEntity saved = societyRepository.saveSociety(entity);
        log.info("[SOCIETY] Society created with ID: {}", saved.getId());
        return mapToSocietyResponse(saved);
    }

    @Override
    public PaginatedResponse<SocietyResponse> listSocieties(int page, int size) {
        log.info("[SOCIETY] Listing societies - page: {}, size: {}", page, size);

        List<SocietyEntity> societies = societyRepository.findAllSocieties(page, size);
        long totalElements = societyRepository.countSocieties();
        int totalPages = (int) Math.ceil((double) totalElements / size);

        List<SocietyResponse> content = societies.stream()
                .map(this::mapToSocietyResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<SocietyResponse>builder()
                .content(content)
                .page(page)
                .size(size)
                .totalElements(totalElements)
                .totalPages(totalPages)
                .hasNext(page < totalPages - 1)
                .hasPrevious(page > 0)
                .build();
    }

    @Override
    public SocietyResponse getSocietyById(String id) {
        SocietyEntity entity = societyRepository.findSocietyById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Society not found with ID: " + id));
        return mapToSocietyResponse(entity);
    }

    @Override
    public SocietyResponse updateSociety(String id, UpdateSocietyRequest request) {
        SocietyEntity entity = societyRepository.findSocietyById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Society not found with ID: " + id));

        if (request.getName() != null) entity.setName(request.getName());
        if (request.getAddress() != null) entity.setAddress(request.getAddress());
        if (request.getCity() != null) entity.setCity(request.getCity());
        if (request.getState() != null) entity.setState(request.getState());
        if (request.getPincode() != null) entity.setPincode(request.getPincode());
        if (request.getTotalBlocks() != null) entity.setTotalBlocks(request.getTotalBlocks());
        if (request.getTotalFlats() != null) entity.setTotalFlats(request.getTotalFlats());
        if (request.getLogoUrl() != null) entity.setLogoUrl(request.getLogoUrl());
        if (request.getStatus() != null) entity.setStatus(request.getStatus());
        entity.setUpdatedAt(Instant.now().toString());

        SocietyEntity updated = societyRepository.updateSociety(entity);
        log.info("[SOCIETY] Society updated with ID: {}", id);
        return mapToSocietyResponse(updated);
    }

    @Override
    public FlatResponse addFlat(String societyId, CreateFlatRequest request) {
        societyRepository.findSocietyById(societyId)
                .orElseThrow(() -> new ResourceNotFoundException("Society not found with ID: " + societyId));

        log.info("[SOCIETY] Adding flat to society: {}", societyId);

        FlatEntity entity = FlatEntity.builder()
                .societyId(societyId)
                .block(request.getBlock())
                .floor(request.getFloor())
                .flatNumber(request.getFlatNumber())
                .type(request.getType())
                .status(request.getPrimaryResidentUid() != null
                        ? SocietyConstants.FLAT_STATUS_OCCUPIED
                        : SocietyConstants.FLAT_STATUS_VACANT)
                .primaryResidentUid(request.getPrimaryResidentUid())
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        FlatEntity saved = societyRepository.saveFlat(entity);
        log.info("[SOCIETY] Flat created with ID: {}", saved.getId());
        return mapToFlatResponse(saved);
    }

    @Override
    public PaginatedResponse<FlatResponse> listFlats(String societyId, int page, int size) {
        societyRepository.findSocietyById(societyId)
                .orElseThrow(() -> new ResourceNotFoundException("Society not found with ID: " + societyId));

        List<FlatEntity> flats = societyRepository.findFlatsBySocietyId(societyId, page, size);
        long totalElements = societyRepository.countFlatsBySocietyId(societyId);
        int totalPages = (int) Math.ceil((double) totalElements / size);

        List<FlatResponse> content = flats.stream()
                .map(this::mapToFlatResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<FlatResponse>builder()
                .content(content)
                .page(page)
                .size(size)
                .totalElements(totalElements)
                .totalPages(totalPages)
                .hasNext(page < totalPages - 1)
                .hasPrevious(page > 0)
                .build();
    }

    @Override
    public FlatResponse getFlatById(String societyId, String flatId) {
        FlatEntity entity = societyRepository.findFlatById(flatId)
                .orElseThrow(() -> new ResourceNotFoundException("Flat not found with ID: " + flatId));

        if (!entity.getSocietyId().equals(societyId)) {
            throw new ResourceNotFoundException("Flat not found in this society");
        }

        return mapToFlatResponse(entity);
    }

    @Override
    public FlatResponse updateFlat(String societyId, String flatId, UpdateFlatRequest request) {
        FlatEntity entity = societyRepository.findFlatById(flatId)
                .orElseThrow(() -> new ResourceNotFoundException("Flat not found with ID: " + flatId));

        if (!entity.getSocietyId().equals(societyId)) {
            throw new ResourceNotFoundException("Flat not found in this society");
        }

        if (request.getBlock() != null) entity.setBlock(request.getBlock());
        if (request.getFloor() != null) entity.setFloor(request.getFloor());
        if (request.getFlatNumber() != null) entity.setFlatNumber(request.getFlatNumber());
        if (request.getType() != null) entity.setType(request.getType());
        if (request.getStatus() != null) entity.setStatus(request.getStatus());
        if (request.getPrimaryResidentUid() != null) entity.setPrimaryResidentUid(request.getPrimaryResidentUid());
        entity.setUpdatedAt(Instant.now().toString());

        FlatEntity updated = societyRepository.updateFlat(entity);
        log.info("[SOCIETY] Flat updated with ID: {}", flatId);
        return mapToFlatResponse(updated);
    }

    @Override
    public List<String> getResidentsInFlat(String societyId, String flatId) {
        societyRepository.findFlatById(flatId)
                .orElseThrow(() -> new ResourceNotFoundException("Flat not found with ID: " + flatId));

        return societyRepository.findResidentUidsByFlatId(flatId);
    }

    private SocietyResponse mapToSocietyResponse(SocietyEntity entity) {
        return SocietyResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .address(entity.getAddress())
                .city(entity.getCity())
                .state(entity.getState())
                .pincode(entity.getPincode())
                .totalBlocks(entity.getTotalBlocks())
                .totalFlats(entity.getTotalFlats())
                .logoUrl(entity.getLogoUrl())
                .status(entity.getStatus())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private FlatResponse mapToFlatResponse(FlatEntity entity) {
        return FlatResponse.builder()
                .id(entity.getId())
                .societyId(entity.getSocietyId())
                .block(entity.getBlock())
                .floor(entity.getFloor())
                .flatNumber(entity.getFlatNumber())
                .type(entity.getType())
                .status(entity.getStatus())
                .primaryResidentUid(entity.getPrimaryResidentUid())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
