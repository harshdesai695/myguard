package com.myguard.visitor.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.visitor.dto.request.CreateGuestInviteRequest;
import com.myguard.visitor.dto.request.CreatePreApprovalRequest;
import com.myguard.visitor.dto.request.CreateRecurringInviteRequest;
import com.myguard.visitor.dto.request.GroupVisitorEntryRequest;
import com.myguard.visitor.dto.request.LogVisitorEntryRequest;
import com.myguard.visitor.dto.response.PreApprovalResponse;
import com.myguard.visitor.dto.response.RecurringInviteResponse;
import com.myguard.visitor.dto.response.VisitorResponse;

import java.time.Instant;
import java.util.List;

public interface VisitorService {
    // Pre-approvals
    PreApprovalResponse createPreApproval(CreatePreApprovalRequest request);
    PaginatedResponse<PreApprovalResponse> listMyPreApprovals(int page, int size);
    void cancelPreApproval(String id);

    // Visitor entry/exit
    VisitorResponse logVisitorEntry(LogVisitorEntryRequest request);
    VisitorResponse approveVisitorEntry(String id);
    VisitorResponse rejectVisitorEntry(String id);
    VisitorResponse logVisitorExit(String id);
    PaginatedResponse<VisitorResponse> listVisitors(int page, int size, String flatId, String status, Instant from, Instant to);
    VisitorResponse getVisitorById(String id);

    // Recurring invites
    RecurringInviteResponse createRecurringInvite(CreateRecurringInviteRequest request);
    PaginatedResponse<RecurringInviteResponse> listMyRecurringInvites(int page, int size);
    void revokeRecurringInvite(String id);

    // Guest invites
    PreApprovalResponse createGuestInvite(CreateGuestInviteRequest request);
    PreApprovalResponse verifyInviteCode(String code);

    // Overstay
    PaginatedResponse<VisitorResponse> listOverstayingVisitors(int page, int size);

    // Group entry
    List<VisitorResponse> logGroupEntry(GroupVisitorEntryRequest request);
}
