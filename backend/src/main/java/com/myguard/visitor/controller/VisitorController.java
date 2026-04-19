package com.myguard.visitor.controller;

import java.time.Instant;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.visitor.dto.request.CreateGuestInviteRequest;
import com.myguard.visitor.dto.request.CreatePreApprovalRequest;
import com.myguard.visitor.dto.request.CreateRecurringInviteRequest;
import com.myguard.visitor.dto.request.GroupVisitorEntryRequest;
import com.myguard.visitor.dto.request.LogVisitorEntryRequest;
import com.myguard.visitor.dto.response.PreApprovalResponse;
import com.myguard.visitor.dto.response.RecurringInviteResponse;
import com.myguard.visitor.dto.response.VisitorResponse;
import com.myguard.visitor.service.VisitorService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/api/v1/visitors")
@RequiredArgsConstructor
public class VisitorController {

    private final VisitorService visitorService;

    @PostMapping("/pre-approve")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PreApprovalResponse>> createPreApproval(
            @Valid @RequestBody CreatePreApprovalRequest request) {
        PreApprovalResponse response = visitorService.createPreApproval(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Pre-approval created"));
    }

    @GetMapping("/pre-approvals")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<PreApprovalResponse>>> listPreApprovals(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<PreApprovalResponse> response = visitorService.listMyPreApprovals(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @DeleteMapping("/pre-approvals/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> cancelPreApproval(@PathVariable String id) {
        visitorService.cancelPreApproval(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Pre-approval cancelled"));
    }

    @PostMapping("/entry")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<VisitorResponse>> logVisitorEntry(
            @Valid @RequestBody LogVisitorEntryRequest request) {
        VisitorResponse response = visitorService.logVisitorEntry(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Visitor entry logged"));
    }

    @PatchMapping("/entry/{id}/approve")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<VisitorResponse>> approveVisitorEntry(@PathVariable String id) {
        VisitorResponse response = visitorService.approveVisitorEntry(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Visitor entry approved"));
    }

    @PatchMapping("/entry/{id}/reject")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<VisitorResponse>> rejectVisitorEntry(@PathVariable String id) {
        VisitorResponse response = visitorService.rejectVisitorEntry(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Visitor entry rejected"));
    }

    @PatchMapping("/entry/{id}/exit")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<VisitorResponse>> logVisitorExit(@PathVariable String id) {
        VisitorResponse response = visitorService.logVisitorExit(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Visitor exit logged"));
    }

    @GetMapping
    @PreAuthorize("hasAnyRole('ADMIN', 'GUARD', 'RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<VisitorResponse>>> listVisitors(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String flatId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) Instant from,
            @RequestParam(required = false) Instant to) {
        PaginatedResponse<VisitorResponse> response = visitorService.listVisitors(page, size, flatId, status, from, to);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<VisitorResponse>> getVisitor(@PathVariable String id) {
        VisitorResponse response = visitorService.getVisitorById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/recurring")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<RecurringInviteResponse>> createRecurringInvite(
            @Valid @RequestBody CreateRecurringInviteRequest request) {
        RecurringInviteResponse response = visitorService.createRecurringInvite(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Recurring invite created"));
    }

    @GetMapping("/recurring")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<RecurringInviteResponse>>> listRecurringInvites(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<RecurringInviteResponse> response = visitorService.listMyRecurringInvites(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @DeleteMapping("/recurring/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> revokeRecurringInvite(@PathVariable String id) {
        visitorService.revokeRecurringInvite(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Recurring invite revoked"));
    }

    @PostMapping("/guest-invite")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PreApprovalResponse>> createGuestInvite(
            @Valid @RequestBody CreateGuestInviteRequest request) {
        PreApprovalResponse response = visitorService.createGuestInvite(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Guest invite created"));
    }

    @GetMapping("/verify/{code}")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<PreApprovalResponse>> verifyInviteCode(@PathVariable String code) {
        PreApprovalResponse response = visitorService.verifyInviteCode(code);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/overstay")
    @PreAuthorize("hasAnyRole('ADMIN', 'RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<VisitorResponse>>> listOverstayingVisitors(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<VisitorResponse> response = visitorService.listOverstayingVisitors(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/group-entry")
    @PreAuthorize("hasRole('GUARD')")
    public ResponseEntity<ApiResponse<List<VisitorResponse>>> logGroupEntry(
            @Valid @RequestBody GroupVisitorEntryRequest request) {
        List<VisitorResponse> response = visitorService.logGroupEntry(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Group entry logged"));
    }
}
