package com.myguard.dailyhelp.service;

import java.time.Instant;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.dailyhelp.dto.request.CreateDailyHelpRequest;
import com.myguard.dailyhelp.dto.request.UpdateDailyHelpRequest;
import com.myguard.dailyhelp.dto.response.AttendanceResponse;
import com.myguard.dailyhelp.dto.response.AttendanceSummaryResponse;
import com.myguard.dailyhelp.dto.response.DailyHelpResponse;
import com.myguard.dailyhelp.repository.DailyHelpRepository;
import com.myguard.dailyhelp.view.AttendanceEntity;
import com.myguard.dailyhelp.view.DailyHelpEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class DailyHelpServiceImpl implements DailyHelpService {

    private final DailyHelpRepository dailyHelpRepository;

    @Override
    public DailyHelpResponse create(CreateDailyHelpRequest request) {
        String uid = getCurrentUid();
        log.info("[DAILYHELP] Creating daily help: {}", request.getName());

        DailyHelpEntity entity = DailyHelpEntity.builder()
                .name(request.getName())
                .phone(request.getPhone())
                .photoUrl(request.getPhotoUrl())
                .type(request.getType())
                .residentUid(uid)
                .flatIds(request.getFlatIds())
                .schedule(request.getSchedule())
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        DailyHelpEntity saved = dailyHelpRepository.save(entity);
        log.info("[DAILYHELP] Daily help created with ID: {}", saved.getId());
        return mapToResponse(saved);
    }

    @Override
    public PaginatedResponse<DailyHelpResponse> listMyDailyHelps(int page, int size) {
        String uid = getCurrentUid();
        List<DailyHelpEntity> entities = dailyHelpRepository.findByResidentUid(uid, page, size);
        long total = dailyHelpRepository.countByResidentUid(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        return PaginatedResponse.<DailyHelpResponse>builder()
                .content(entities.stream().map(this::mapToResponse).collect(Collectors.toList()))
                .page(page).size(size).totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public DailyHelpResponse getById(String id) {
        return mapToResponse(dailyHelpRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Daily help not found")));
    }

    @Override
    public DailyHelpResponse update(String id, UpdateDailyHelpRequest request) {
        DailyHelpEntity entity = dailyHelpRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Daily help not found"));

        if (request.getName() != null) entity.setName(request.getName());
        if (request.getPhone() != null) entity.setPhone(request.getPhone());
        if (request.getPhotoUrl() != null) entity.setPhotoUrl(request.getPhotoUrl());
        if (request.getType() != null) entity.setType(request.getType());
        if (request.getFlatIds() != null) entity.setFlatIds(request.getFlatIds());
        if (request.getSchedule() != null) entity.setSchedule(request.getSchedule());
        entity.setUpdatedAt(Instant.now().toString());

        return mapToResponse(dailyHelpRepository.update(entity));
    }

    @Override
    public void delete(String id) {
        dailyHelpRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Daily help not found"));
        dailyHelpRepository.delete(id);
        log.info("[DAILYHELP] Daily help deleted: {}", id);
    }

    @Override
    public AttendanceResponse markAttendance(String dailyHelpId) {
        String guardUid = getCurrentUid();
        dailyHelpRepository.findById(dailyHelpId)
                .orElseThrow(() -> new ResourceNotFoundException("Daily help not found"));

        AttendanceEntity attendance = AttendanceEntity.builder()
                .dailyHelpId(dailyHelpId)
                .guardUid(guardUid)
                .entryTime(Instant.now().toString())
                .date(LocalDate.now().format(DateTimeFormatter.ISO_LOCAL_DATE))
                .status("PRESENT")
                .createdAt(Instant.now().toString())
                .build();

        AttendanceEntity saved = dailyHelpRepository.saveAttendance(attendance);
        log.info("[DAILYHELP] Attendance marked for daily help: {}", dailyHelpId);
        return mapToAttendanceResponse(saved);
    }

    @Override
    public PaginatedResponse<AttendanceResponse> getAttendanceHistory(String dailyHelpId, int page, int size) {
        List<AttendanceEntity> records = dailyHelpRepository.findAttendanceByDailyHelpId(dailyHelpId, page, size);
        long total = dailyHelpRepository.countAttendanceByDailyHelpId(dailyHelpId);
        int totalPages = (int) Math.ceil((double) total / size);

        return PaginatedResponse.<AttendanceResponse>builder()
                .content(records.stream().map(this::mapToAttendanceResponse).collect(Collectors.toList()))
                .page(page).size(size).totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public AttendanceSummaryResponse getAttendanceSummary(String dailyHelpId, String yearMonth) {
        List<AttendanceEntity> records = dailyHelpRepository.findAttendanceByMonth(dailyHelpId, yearMonth);

        int present = (int) records.stream().filter(r -> "PRESENT".equals(r.getStatus())).count();
        int late = (int) records.stream().filter(r -> "LATE".equals(r.getStatus())).count();
        int workingDays = 26;
        int absent = workingDays - present - late;

        return AttendanceSummaryResponse.builder()
                .dailyHelpId(dailyHelpId)
                .month(yearMonth)
                .totalPresent(present)
                .totalAbsent(Math.max(absent, 0))
                .totalLate(late)
                .workingDays(workingDays)
                .build();
    }

    private String getCurrentUid() {
        return (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    private DailyHelpResponse mapToResponse(DailyHelpEntity entity) {
        return DailyHelpResponse.builder()
                .id(entity.getId()).name(entity.getName()).phone(entity.getPhone())
                .photoUrl(entity.getPhotoUrl()).type(entity.getType())
                .residentUid(entity.getResidentUid()).flatIds(entity.getFlatIds())
                .societyId(entity.getSocietyId()).schedule(entity.getSchedule())
                .createdAt(parseInstant(entity.getCreatedAt())).updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private AttendanceResponse mapToAttendanceResponse(AttendanceEntity entity) {
        return AttendanceResponse.builder()
                .id(entity.getId()).dailyHelpId(entity.getDailyHelpId())
                .guardUid(entity.getGuardUid()).entryTime(parseInstant(entity.getEntryTime()))
                .exitTime(parseInstant(entity.getExitTime())).date(entity.getDate())
                .status(entity.getStatus()).createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
