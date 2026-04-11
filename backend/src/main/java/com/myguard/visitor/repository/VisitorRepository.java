package com.myguard.visitor.repository;

import com.myguard.visitor.view.PreApprovalEntity;
import com.myguard.visitor.view.RecurringInviteEntity;
import com.myguard.visitor.view.VisitorEntity;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

public interface VisitorRepository {
    // Visitors
    VisitorEntity saveVisitor(VisitorEntity visitor);
    Optional<VisitorEntity> findVisitorById(String id);
    VisitorEntity updateVisitor(VisitorEntity visitor);
    List<VisitorEntity> findVisitors(int page, int size, String flatId, String status, Instant from, Instant to);
    long countVisitors(String flatId, String status, Instant from, Instant to);
    List<VisitorEntity> findOverstayingVisitors(Instant threshold, int page, int size);
    long countOverstayingVisitors(Instant threshold);

    // Pre-approvals
    PreApprovalEntity savePreApproval(PreApprovalEntity preApproval);
    Optional<PreApprovalEntity> findPreApprovalById(String id);
    void deletePreApproval(String id);
    List<PreApprovalEntity> findPreApprovalsByResident(String residentUid, int page, int size);
    long countPreApprovalsByResident(String residentUid);
    Optional<PreApprovalEntity> findPreApprovalByCode(String inviteCode);

    // Recurring invites
    RecurringInviteEntity saveRecurringInvite(RecurringInviteEntity invite);
    Optional<RecurringInviteEntity> findRecurringInviteById(String id);
    void deleteRecurringInvite(String id);
    List<RecurringInviteEntity> findRecurringInvitesByResident(String residentUid, int page, int size);
    long countRecurringInvitesByResident(String residentUid);
}
