package com.myguard.communication.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.communication.dto.request.CastVoteRequest;
import com.myguard.communication.dto.request.CreateGroupRequest;
import com.myguard.communication.dto.request.CreateNoticeRequest;
import com.myguard.communication.dto.request.CreatePollRequest;
import com.myguard.communication.dto.request.SendMessageRequest;
import com.myguard.communication.dto.request.UpdateNoticeRequest;
import com.myguard.communication.dto.request.UploadDocumentRequest;
import com.myguard.communication.dto.response.DocumentResponse;
import com.myguard.communication.dto.response.GroupResponse;
import com.myguard.communication.dto.response.MessageResponse;
import com.myguard.communication.dto.response.NoticeResponse;
import com.myguard.communication.dto.response.PollResponse;
import com.myguard.communication.service.CommunicationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/communications")
@RequiredArgsConstructor
public class CommunicationController {

    private final CommunicationService communicationService;

    // --- Notices ---

    @PostMapping("/notices")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<NoticeResponse>> createNotice(
            @Valid @RequestBody CreateNoticeRequest request) {
        NoticeResponse response = communicationService.createNotice(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Notice posted"));
    }

    @GetMapping("/notices")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<NoticeResponse>>> listNotices(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<NoticeResponse> response = communicationService.listNotices(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/notices/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<NoticeResponse>> getNotice(@PathVariable String id) {
        NoticeResponse response = communicationService.getNoticeById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/notices/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<NoticeResponse>> updateNotice(
            @PathVariable String id,
            @Valid @RequestBody UpdateNoticeRequest request) {
        NoticeResponse response = communicationService.updateNotice(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Notice updated"));
    }

    @DeleteMapping("/notices/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<Void>> deleteNotice(@PathVariable String id) {
        communicationService.deleteNotice(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Notice deleted"));
    }

    // --- Polls ---

    @PostMapping("/polls")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PollResponse>> createPoll(
            @Valid @RequestBody CreatePollRequest request) {
        PollResponse response = communicationService.createPoll(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Poll created"));
    }

    @GetMapping("/polls")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<PollResponse>>> listPolls(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<PollResponse> response = communicationService.listPolls(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/polls/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PollResponse>> getPoll(@PathVariable String id) {
        PollResponse response = communicationService.getPollById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PostMapping("/polls/{id}/vote")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> castVote(
            @PathVariable String id,
            @Valid @RequestBody CastVoteRequest request) {
        communicationService.castVote(id, request);
        return ResponseEntity.ok(ApiResponse.success(null, "Vote cast successfully"));
    }

    // --- Groups ---

    @PostMapping("/groups")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<GroupResponse>> createGroup(
            @Valid @RequestBody CreateGroupRequest request) {
        GroupResponse response = communicationService.createGroup(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Group created"));
    }

    @GetMapping("/groups")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<GroupResponse>>> listGroups(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<GroupResponse> response = communicationService.listGroups(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    // --- Messages ---

    @PostMapping("/groups/{id}/messages")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<MessageResponse>> sendMessage(
            @PathVariable String id,
            @Valid @RequestBody SendMessageRequest request) {
        MessageResponse response = communicationService.sendMessage(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Message sent"));
    }

    @GetMapping("/groups/{id}/messages")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<MessageResponse>>> listMessages(
            @PathVariable String id,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        PaginatedResponse<MessageResponse> response = communicationService.listMessages(id, page, size);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    // --- Documents ---

    @PostMapping("/documents")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<DocumentResponse>> uploadDocument(
            @Valid @RequestBody UploadDocumentRequest request) {
        DocumentResponse response = communicationService.uploadDocument(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Document uploaded"));
    }

    @GetMapping("/documents")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<DocumentResponse>>> listDocuments(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId) {
        PaginatedResponse<DocumentResponse> response = communicationService.listDocuments(page, size, societyId);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/documents/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<DocumentResponse>> getDocument(@PathVariable String id) {
        DocumentResponse response = communicationService.getDocumentById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
