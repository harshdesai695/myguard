package com.myguard.visitor.service;

import com.myguard.common.exception.ForbiddenException;
import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.exception.ValidationException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.visitor.constants.VisitorConstants;
import com.myguard.visitor.dto.request.CreateGuestInviteRequest;
import com.myguard.visitor.dto.request.CreatePreApprovalRequest;
import com.myguard.visitor.dto.request.CreateRecurringInviteRequest;
import com.myguard.visitor.dto.request.GroupVisitorEntryRequest;
import com.myguard.visitor.dto.request.LogVisitorEntryRequest;
import com.myguard.visitor.dto.response.PreApprovalResponse;
import com.myguard.visitor.dto.response.RecurringInviteResponse;
import com.myguard.visitor.dto.response.VisitorResponse;
import com.myguard.visitor.repository.VisitorRepository;
import com.myguard.visitor.view.PreApprovalEntity;
import com.myguard.visitor.view.RecurringInviteEntity;
import com.myguard.visitor.view.VisitorEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class VisitorServiceImpl implements VisitorService {

    private final VisitorRepository visitorRepository;

    @Override
    public PreApprovalResponse createPreApproval(CreatePreApprovalRequest request) {
        String uid = getCurrentUid();
        log.info("[VISITOR] Creating pre-approval for visitor: {}", request.getVisitorName());

        long validHours = request.getValidHours() != null ? request.getValidHours() : VisitorConstants.DEFAULT_PRE_APPROVAL_HOURS;

        PreApprovalEntity entity = PreApprovalEntity.builder()
                .visitorName(request.getVisitorName())
                .visitorPhone(request.getVisitorPhone())
                .purpose(request.getPurpose())
                .residentUid(uid)
                .inviteCode(generateInviteCode())
                .status(VisitorConstants.STATUS_ACTIVE)
                .validFrom(Instant.now())
                .validUntil(Instant.now().plus(validHours, ChronoUnit.HOURS))
                .createdAt(Instant.now())
                .build();

        PreApprovalEntity saved = visitorRepository.savePreApproval(entity);
        log.info("[VISITOR] Pre-approval created with ID: {}", saved.getId());
        return mapToPreApprovalResponse(saved);
    }

    @Override
    public PaginatedResponse<PreApprovalResponse> listMyPreApprovals(int page, int size) {
        String uid = getCurrentUid();
        List<PreApprovalEntity> preApprovals = visitorRepository.findPreApprovalsByResident(uid, page, size);
        long total = visitorRepository.countPreApprovalsByResident(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<PreApprovalResponse> content = preApprovals.stream()
                .map(this::mapToPreApprovalResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<PreApprovalResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public void cancelPreApproval(String id) {
        String uid = getCurrentUid();
        PreApprovalEntity entity = visitorRepository.findPreApprovalById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Pre-approval not found"));

        if (!entity.getResidentUid().equals(uid)) {
            throw new ForbiddenException("You can only cancel your own pre-approvals");
        }

        visitorRepository.deletePreApproval(id);
        log.info("[VISITOR] Pre-approval cancelled with ID: {}", id);
    }

    @Override
    public VisitorResponse logVisitorEntry(LogVisitorEntryRequest request) {
        String guardUid = getCurrentUid();
        log.info("[VISITOR] Logging visitor entry: {}", request.getVisitorName());

        VisitorEntity entity = VisitorEntity.builder()
                .visitorName(request.getVisitorName())
                .visitorPhone(request.getVisitorPhone())
                .photoUrl(request.getPhotoUrl())
                .purpose(request.getPurpose())
                .flatId(request.getFlatId())
                .entryTime(Instant.now())
                .status(VisitorConstants.STATUS_PENDING)
                .vehicleNumber(request.getVehicleNumber())
                .guardUid(guardUid)
                .preApprovalId(request.getPreApprovalId())
                .inviteCode(request.getInviteCode())
                .isGroupEntry(false)
                .groupSize(1)
                .createdAt(Instant.now())
                .updatedAt(Instant.now())
                .build();

        // Auto-approve if pre-approval or valid invite code exists
        if (request.getPreApprovalId() != null) {
            visitorRepository.findPreApprovalById(request.getPreApprovalId())
                    .ifPresent(pa -> {
                        if (VisitorConstants.STATUS_ACTIVE.equals(pa.getStatus())
                                && pa.getValidUntil().isAfter(Instant.now())) {
                            entity.setStatus(VisitorConstants.STATUS_APPROVED);
                            entity.setResidentUid(pa.getResidentUid());
                        }
                    });
        }

        VisitorEntity saved = visitorRepository.saveVisitor(entity);
        log.info("[VISITOR] Visitor entry logged with ID: {}", saved.getId());
        return mapToVisitorResponse(saved);
    }

    @Override
    public VisitorResponse approveVisitorEntry(String id) {
        String uid = getCurrentUid();
        VisitorEntity visitor = visitorRepository.findVisitorById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Visitor entry not found"));

        if (!VisitorConstants.STATUS_PENDING.equals(visitor.getStatus())) {
            throw new ValidationException("Visitor entry is not in pending status");
        }

        visitor.setStatus(VisitorConstants.STATUS_APPROVED);
        visitor.setResidentUid(uid);
        visitor.setUpdatedAt(Instant.now());

        VisitorEntity updated = visitorRepository.updateVisitor(visitor);
        log.info("[VISITOR] Visitor entry approved: {}", id);
        return mapToVisitorResponse(updated);
    }

    @Override
    public VisitorResponse rejectVisitorEntry(String id) {
        String uid = getCurrentUid();
        VisitorEntity visitor = visitorRepository.findVisitorById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Visitor entry not found"));

        if (!VisitorConstants.STATUS_PENDING.equals(visitor.getStatus())) {
            throw new ValidationException("Visitor entry is not in pending status");
        }

        visitor.setStatus(VisitorConstants.STATUS_REJECTED);
        visitor.setResidentUid(uid);
        visitor.setUpdatedAt(Instant.now());

        VisitorEntity updated = visitorRepository.updateVisitor(visitor);
        log.info("[VISITOR] Visitor entry rejected: {}", id);
        return mapToVisitorResponse(updated);
    }

    @Override
    public VisitorResponse logVisitorExit(String id) {
        VisitorEntity visitor = visitorRepository.findVisitorById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Visitor entry not found"));

        if (!VisitorConstants.STATUS_APPROVED.equals(visitor.getStatus())) {
            throw new ValidationException("Visitor must be in approved status to log exit");
        }

        visitor.setExitTime(Instant.now());
        visitor.setStatus(VisitorConstants.STATUS_COMPLETED);
        visitor.setUpdatedAt(Instant.now());

        VisitorEntity updated = visitorRepository.updateVisitor(visitor);
        log.info("[VISITOR] Visitor exit logged: {}", id);
        return mapToVisitorResponse(updated);
    }

    @Override
    public PaginatedResponse<VisitorResponse> listVisitors(int page, int size, String flatId, String status, Instant from, Instant to) {
        List<VisitorEntity> visitors = visitorRepository.findVisitors(page, size, flatId, status, from, to);
        long total = visitorRepository.countVisitors(flatId, status, from, to);
        int totalPages = (int) Math.ceil((double) total / size);

        List<VisitorResponse> content = visitors.stream()
                .map(this::mapToVisitorResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<VisitorResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public VisitorResponse getVisitorById(String id) {
        VisitorEntity visitor = visitorRepository.findVisitorById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Visitor entry not found"));
        return mapToVisitorResponse(visitor);
    }

    @Override
    public RecurringInviteResponse createRecurringInvite(CreateRecurringInviteRequest request) {
        String uid = getCurrentUid();
        log.info("[VISITOR] Creating recurring invite for: {}", request.getVisitorName());

        RecurringInviteEntity entity = RecurringInviteEntity.builder()
                .visitorName(request.getVisitorName())
                .visitorPhone(request.getVisitorPhone())
                .purpose(request.getPurpose())
                .residentUid(uid)
                .status(VisitorConstants.STATUS_ACTIVE)
                .validFrom(request.getValidFrom())
                .validUntil(request.getValidUntil())
                .createdAt(Instant.now())
                .build();

        RecurringInviteEntity saved = visitorRepository.saveRecurringInvite(entity);
        log.info("[VISITOR] Recurring invite created with ID: {}", saved.getId());
        return mapToRecurringInviteResponse(saved);
    }

    @Override
    public PaginatedResponse<RecurringInviteResponse> listMyRecurringInvites(int page, int size) {
        String uid = getCurrentUid();
        List<RecurringInviteEntity> invites = visitorRepository.findRecurringInvitesByResident(uid, page, size);
        long total = visitorRepository.countRecurringInvitesByResident(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<RecurringInviteResponse> content = invites.stream()
                .map(this::mapToRecurringInviteResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<RecurringInviteResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public void revokeRecurringInvite(String id) {
        String uid = getCurrentUid();
        RecurringInviteEntity entity = visitorRepository.findRecurringInviteById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Recurring invite not found"));

        if (!entity.getResidentUid().equals(uid)) {
            throw new ForbiddenException("You can only revoke your own recurring invites");
        }

        visitorRepository.deleteRecurringInvite(id);
        log.info("[VISITOR] Recurring invite revoked: {}", id);
    }

    @Override
    public PreApprovalResponse createGuestInvite(CreateGuestInviteRequest request) {
        String uid = getCurrentUid();
        log.info("[VISITOR] Creating guest invite for: {}", request.getGuestName());

        long validHours = request.getValidHours() != null ? request.getValidHours() : VisitorConstants.DEFAULT_PRE_APPROVAL_HOURS;

        PreApprovalEntity entity = PreApprovalEntity.builder()
                .visitorName(request.getGuestName())
                .visitorPhone(request.getGuestPhone())
                .purpose(request.getPurpose())
                .residentUid(uid)
                .inviteCode(generateInviteCode())
                .status(VisitorConstants.STATUS_ACTIVE)
                .validFrom(Instant.now())
                .validUntil(Instant.now().plus(validHours, ChronoUnit.HOURS))
                .createdAt(Instant.now())
                .build();

        PreApprovalEntity saved = visitorRepository.savePreApproval(entity);
        log.info("[VISITOR] Guest invite created with code: {}", saved.getInviteCode());
        return mapToPreApprovalResponse(saved);
    }

    @Override
    public PreApprovalResponse verifyInviteCode(String code) {
        PreApprovalEntity entity = visitorRepository.findPreApprovalByCode(code)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid invite code"));

        if (!VisitorConstants.STATUS_ACTIVE.equals(entity.getStatus())) {
            throw new ValidationException("Invite code is no longer active");
        }

        if (entity.getValidUntil().isBefore(Instant.now())) {
            throw new ValidationException("Invite code has expired");
        }

        return mapToPreApprovalResponse(entity);
    }

    @Override
    public PaginatedResponse<VisitorResponse> listOverstayingVisitors(int page, int size) {
        Instant threshold = Instant.now().minus(VisitorConstants.DEFAULT_OVERSTAY_THRESHOLD_HOURS, ChronoUnit.HOURS);

        List<VisitorEntity> visitors = visitorRepository.findOverstayingVisitors(threshold, page, size);
        long total = visitorRepository.countOverstayingVisitors(threshold);
        int totalPages = (int) Math.ceil((double) total / size);

        List<VisitorResponse> content = visitors.stream()
                .map(this::mapToVisitorResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<VisitorResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public List<VisitorResponse> logGroupEntry(GroupVisitorEntryRequest request) {
        String guardUid = getCurrentUid();
        log.info("[VISITOR] Logging group entry with {} visitors", request.getVisitors().size());

        List<VisitorResponse> responses = new ArrayList<>();

        for (GroupVisitorEntryRequest.GroupVisitorDetail detail : request.getVisitors()) {
            VisitorEntity entity = VisitorEntity.builder()
                    .visitorName(detail.getVisitorName())
                    .visitorPhone(detail.getVisitorPhone())
                    .photoUrl(detail.getPhotoUrl())
                    .purpose(request.getPurpose())
                    .flatId(request.getFlatId())
                    .entryTime(Instant.now())
                    .status(VisitorConstants.STATUS_PENDING)
                    .vehicleNumber(request.getVehicleNumber())
                    .guardUid(guardUid)
                    .isGroupEntry(true)
                    .groupSize(request.getVisitors().size())
                    .createdAt(Instant.now())
                    .updatedAt(Instant.now())
                    .build();

            VisitorEntity saved = visitorRepository.saveVisitor(entity);
            responses.add(mapToVisitorResponse(saved));
        }

        log.info("[VISITOR] Group entry logged with {} visitors", responses.size());
        return responses;
    }

    private String getCurrentUid() {
        return (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    private String generateInviteCode() {
        return UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }

    private VisitorResponse mapToVisitorResponse(VisitorEntity entity) {
        return VisitorResponse.builder()
                .id(entity.getId())
                .visitorName(entity.getVisitorName())
                .visitorPhone(entity.getVisitorPhone())
                .photoUrl(entity.getPhotoUrl())
                .purpose(entity.getPurpose())
                .flatId(entity.getFlatId())
                .residentUid(entity.getResidentUid())
                .societyId(entity.getSocietyId())
                .entryTime(entity.getEntryTime())
                .exitTime(entity.getExitTime())
                .status(entity.getStatus())
                .vehicleNumber(entity.getVehicleNumber())
                .guardUid(entity.getGuardUid())
                .preApprovalId(entity.getPreApprovalId())
                .inviteCode(entity.getInviteCode())
                .isGroupEntry(entity.isGroupEntry())
                .groupSize(entity.getGroupSize())
                .createdAt(entity.getCreatedAt())
                .build();
    }

    private PreApprovalResponse mapToPreApprovalResponse(PreApprovalEntity entity) {
        return PreApprovalResponse.builder()
                .id(entity.getId())
                .visitorName(entity.getVisitorName())
                .visitorPhone(entity.getVisitorPhone())
                .purpose(entity.getPurpose())
                .flatId(entity.getFlatId())
                .residentUid(entity.getResidentUid())
                .inviteCode(entity.getInviteCode())
                .status(entity.getStatus())
                .validFrom(entity.getValidFrom())
                .validUntil(entity.getValidUntil())
                .createdAt(entity.getCreatedAt())
                .build();
    }

    private RecurringInviteResponse mapToRecurringInviteResponse(RecurringInviteEntity entity) {
        return RecurringInviteResponse.builder()
                .id(entity.getId())
                .visitorName(entity.getVisitorName())
                .visitorPhone(entity.getVisitorPhone())
                .purpose(entity.getPurpose())
                .flatId(entity.getFlatId())
                .residentUid(entity.getResidentUid())
                .status(entity.getStatus())
                .validFrom(entity.getValidFrom())
                .validUntil(entity.getValidUntil())
                .createdAt(entity.getCreatedAt())
                .build();
    }
}
