package com.myguard.guard.service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.guard.dto.request.CreateCheckpointRequest;
import com.myguard.guard.dto.request.CreateShiftRequest;
import com.myguard.guard.dto.request.LogPatrolRequest;
import com.myguard.guard.dto.request.SendIntercomRequest;
import com.myguard.guard.dto.response.CheckpointResponse;
import com.myguard.guard.dto.response.IntercomResponse;
import com.myguard.guard.dto.response.PatrolReportResponse;
import com.myguard.guard.dto.response.PatrolResponse;
import com.myguard.guard.dto.response.ShiftResponse;
import com.myguard.guard.repository.GuardRepository;
import com.myguard.guard.view.CheckpointEntity;
import com.myguard.guard.view.IntercomEntity;
import com.myguard.guard.view.PatrolEntity;
import com.myguard.guard.view.ShiftEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class GuardServiceImpl implements GuardService {

    private final GuardRepository guardRepository;

    @Override
    public CheckpointResponse createCheckpoint(CreateCheckpointRequest request) {
        log.info("[GUARD] Creating checkpoint: {}", request.getName());
        CheckpointEntity entity = CheckpointEntity.builder()
                .name(request.getName()).description(request.getDescription())
                .societyId(request.getSocietyId()).latitude(request.getLatitude())
                .longitude(request.getLongitude()).qrCode(request.getQrCode())
                .createdAt(Instant.now().toString()).build();
        return mapCheckpoint(guardRepository.saveCheckpoint(entity));
    }

    @Override
    public PaginatedResponse<CheckpointResponse> listCheckpoints(int page, int size) {
        List<CheckpointEntity> list = guardRepository.findAllCheckpoints(page, size);
        long total = guardRepository.countCheckpoints();
        int totalPages = (int) Math.ceil((double) total / size);
        return PaginatedResponse.<CheckpointResponse>builder()
                .content(list.stream().map(this::mapCheckpoint).collect(Collectors.toList()))
                .page(page).size(size).totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0).build();
    }

    @Override
    public PatrolResponse logPatrol(LogPatrolRequest request) {
        String guardUid = getCurrentUid();
        log.info("[GUARD] Logging patrol scan at checkpoint: {}", request.getCheckpointId());
        PatrolEntity entity = PatrolEntity.builder()
                .guardUid(guardUid).checkpointId(request.getCheckpointId())
                .scannedAt(Instant.now().toString()).notes(request.getNotes())
                .createdAt(Instant.now().toString()).build();
        return mapPatrol(guardRepository.savePatrol(entity));
    }

    @Override
    public PaginatedResponse<PatrolResponse> listPatrols(int page, int size, String guardUid, Instant from, Instant to) {
        List<PatrolEntity> list = guardRepository.findPatrols(page, size, guardUid, from, to);
        long total = guardRepository.countPatrols(guardUid, from, to);
        int totalPages = (int) Math.ceil((double) total / size);
        return PaginatedResponse.<PatrolResponse>builder()
                .content(list.stream().map(this::mapPatrol).collect(Collectors.toList()))
                .page(page).size(size).totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0).build();
    }

    @Override
    public PatrolReportResponse getPatrolReport(Instant from, Instant to) {
        long totalCheckpoints = guardRepository.countCheckpoints();
        long completedScans = guardRepository.countPatrols(null, from, to);
        long missedScans = Math.max(totalCheckpoints - completedScans, 0);
        double rate = totalCheckpoints > 0 ? (double) completedScans / totalCheckpoints * 100 : 0;
        return PatrolReportResponse.builder()
                .totalCheckpoints(totalCheckpoints).completedScans(completedScans)
                .missedScans(missedScans).completionRate(rate)
                .dateRange(from + " to " + to).build();
    }

    @Override
    public ShiftResponse createShift(CreateShiftRequest request) {
        log.info("[GUARD] Creating shift for guard: {}", request.getGuardUid());
        ShiftEntity entity = ShiftEntity.builder()
                .guardUid(request.getGuardUid()).societyId(request.getSocietyId())
                .shiftName(request.getShiftName()).startTime(request.getStartTime())
                .endTime(request.getEndTime()).date(request.getDate())
                .status("ASSIGNED").createdAt(Instant.now().toString()).build();
        return mapShift(guardRepository.saveShift(entity));
    }

    @Override
    public PaginatedResponse<ShiftResponse> listShifts(int page, int size) {
        List<ShiftEntity> list = guardRepository.findShifts(page, size);
        long total = guardRepository.countShifts();
        int totalPages = (int) Math.ceil((double) total / size);
        return PaginatedResponse.<ShiftResponse>builder()
                .content(list.stream().map(this::mapShift).collect(Collectors.toList()))
                .page(page).size(size).totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0).build();
    }

    @Override
    public IntercomResponse sendIntercom(String flatId, SendIntercomRequest request) {
        String guardUid = getCurrentUid();
        log.info("[GUARD] Sending intercom to flat: {}", flatId);
        IntercomEntity entity = IntercomEntity.builder()
                .guardUid(guardUid).flatId(flatId).message(request.getMessage())
                .createdAt(Instant.now().toString()).build();
        IntercomEntity saved = guardRepository.saveIntercom(entity);
        return IntercomResponse.builder().id(saved.getId()).guardUid(saved.getGuardUid())
                .flatId(saved.getFlatId()).message(saved.getMessage())
                .societyId(saved.getSocietyId()).createdAt(parseInstant(saved.getCreatedAt())).build();
    }

    private String getCurrentUid() {
        return (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    private CheckpointResponse mapCheckpoint(CheckpointEntity e) {
        return CheckpointResponse.builder().id(e.getId()).name(e.getName()).description(e.getDescription())
                .societyId(e.getSocietyId()).latitude(e.getLatitude()).longitude(e.getLongitude())
                .qrCode(e.getQrCode()).createdAt(parseInstant(e.getCreatedAt())).build();
    }

    private PatrolResponse mapPatrol(PatrolEntity e) {
        return PatrolResponse.builder().id(e.getId()).guardUid(e.getGuardUid())
                .checkpointId(e.getCheckpointId()).societyId(e.getSocietyId())
                .scannedAt(parseInstant(e.getScannedAt())).notes(e.getNotes()).createdAt(parseInstant(e.getCreatedAt())).build();
    }

    private ShiftResponse mapShift(ShiftEntity e) {
        return ShiftResponse.builder().id(e.getId()).guardUid(e.getGuardUid())
                .societyId(e.getSocietyId()).shiftName(e.getShiftName())
                .startTime(e.getStartTime()).endTime(e.getEndTime())
                .date(e.getDate()).status(e.getStatus()).createdAt(parseInstant(e.getCreatedAt())).build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
