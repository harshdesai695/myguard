package com.myguard.helpdesk.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.helpdesk.dto.request.AssignTicketRequest;
import com.myguard.helpdesk.dto.request.CreateCategoryRequest;
import com.myguard.helpdesk.dto.request.CreateCommentRequest;
import com.myguard.helpdesk.dto.request.CreateTicketRequest;
import com.myguard.helpdesk.dto.request.RateTicketRequest;
import com.myguard.helpdesk.dto.request.UpdateTicketStatusRequest;
import com.myguard.helpdesk.dto.response.CategoryResponse;
import com.myguard.helpdesk.dto.response.CommentResponse;
import com.myguard.helpdesk.dto.response.HelpdeskReportResponse;
import com.myguard.helpdesk.dto.response.TicketResponse;
import com.myguard.helpdesk.service.HelpdeskService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/helpdesk")
@RequiredArgsConstructor
public class HelpdeskController {

    private final HelpdeskService helpdeskService;

    @PostMapping("/tickets")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<TicketResponse>> createTicket(
            @Valid @RequestBody CreateTicketRequest request) {
        TicketResponse response = helpdeskService.createTicket(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Ticket created"));
    }

    @GetMapping("/tickets")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<PaginatedResponse<TicketResponse>>> listMyTickets(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<TicketResponse> response = helpdeskService.listMyTickets(page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/tickets/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<TicketResponse>> getTicket(@PathVariable String id) {
        TicketResponse response = helpdeskService.getTicketById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/tickets/{id}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TicketResponse>> updateTicketStatus(
            @PathVariable String id,
            @Valid @RequestBody UpdateTicketStatusRequest request) {
        TicketResponse response = helpdeskService.updateTicketStatus(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Ticket status updated"));
    }

    @PatchMapping("/tickets/{id}/assign")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<TicketResponse>> assignTicket(
            @PathVariable String id,
            @Valid @RequestBody AssignTicketRequest request) {
        TicketResponse response = helpdeskService.assignTicket(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Ticket assigned"));
    }

    @PostMapping("/tickets/{id}/comment")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<CommentResponse>> addComment(
            @PathVariable String id,
            @Valid @RequestBody CreateCommentRequest request) {
        CommentResponse response = helpdeskService.addComment(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Comment added"));
    }

    @PostMapping("/tickets/{id}/rate")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<TicketResponse>> rateTicket(
            @PathVariable String id,
            @Valid @RequestBody RateTicketRequest request) {
        TicketResponse response = helpdeskService.rateTicket(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Ticket rated"));
    }

    @GetMapping("/tickets/admin")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<TicketResponse>>> listAllTickets(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String category) {
        PaginatedResponse<TicketResponse> response = helpdeskService.listAllTickets(page, size, societyId, status, category);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/categories")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<CategoryResponse>> createCategory(
            @Valid @RequestBody CreateCategoryRequest request) {
        CategoryResponse response = helpdeskService.createCategory(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Category created"));
    }

    @GetMapping("/categories")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<CategoryResponse>>> listCategories(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<CategoryResponse> response = helpdeskService.listCategories(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/reports")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<HelpdeskReportResponse>> getReport(
            @RequestParam(required = false) String societyId) {
        HelpdeskReportResponse response = helpdeskService.getReport(societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
