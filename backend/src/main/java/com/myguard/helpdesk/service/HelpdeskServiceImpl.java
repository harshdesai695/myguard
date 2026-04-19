package com.myguard.helpdesk.service;

import java.time.Instant;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.exception.ValidationException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.helpdesk.constants.HelpdeskConstants;
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
import com.myguard.helpdesk.repository.HelpdeskRepository;
import com.myguard.helpdesk.view.CategoryEntity;
import com.myguard.helpdesk.view.CommentEntity;
import com.myguard.helpdesk.view.TicketEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class HelpdeskServiceImpl implements HelpdeskService {

    private final HelpdeskRepository helpdeskRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    @Override
    public TicketResponse createTicket(CreateTicketRequest request) {
        String uid = getCurrentUid();
        log.info("[HELPDESK] Creating ticket: {}", request.getTitle());

        TicketEntity entity = TicketEntity.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .category(request.getCategory())
                .subCategory(request.getSubCategory())
                .attachments(request.getAttachments())
                .flatId(request.getFlatId())
                .raisedBy(uid)
                .status(HelpdeskConstants.STATUS_OPEN)
                .priority(request.getPriority() != null ? request.getPriority() : HelpdeskConstants.PRIORITY_MEDIUM)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        TicketEntity saved = helpdeskRepository.saveTicket(entity);
        log.info("[HELPDESK] Ticket created with ID: {}", saved.getId());
        return mapToTicketResponse(saved);
    }

    @Override
    public PaginatedResponse<TicketResponse> listMyTickets(int page, int size) {
        String uid = getCurrentUid();
        List<TicketEntity> tickets = helpdeskRepository.findTicketsByRaisedBy(uid, page, size);
        long total = helpdeskRepository.countTicketsByRaisedBy(uid);
        int totalPages = (int) Math.ceil((double) total / size);

        List<TicketResponse> content = tickets.stream()
                .map(this::mapToTicketResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<TicketResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public TicketResponse getTicketById(String id) {
        TicketEntity entity = helpdeskRepository.findTicketById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found"));
        return mapToTicketResponse(entity);
    }

    @Override
    public TicketResponse updateTicketStatus(String id, UpdateTicketStatusRequest request) {
        TicketEntity entity = helpdeskRepository.findTicketById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found"));

        entity.setStatus(request.getStatus());
        entity.setUpdatedAt(Instant.now().toString());

        TicketEntity updated = helpdeskRepository.updateTicket(entity);
        log.info("[HELPDESK] Ticket status updated: {} -> {}", id, request.getStatus());
        return mapToTicketResponse(updated);
    }

    @Override
    public TicketResponse assignTicket(String id, AssignTicketRequest request) {
        TicketEntity entity = helpdeskRepository.findTicketById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found"));

        entity.setAssignedTo(request.getAssignedTo());
        entity.setStatus(HelpdeskConstants.STATUS_IN_PROGRESS);
        entity.setUpdatedAt(Instant.now().toString());

        TicketEntity updated = helpdeskRepository.updateTicket(entity);
        log.info("[HELPDESK] Ticket assigned: {} -> {}", id, request.getAssignedTo());
        return mapToTicketResponse(updated);
    }

    @Override
    public CommentResponse addComment(String ticketId, CreateCommentRequest request) {
        String uid = getCurrentUid();
        helpdeskRepository.findTicketById(ticketId)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found"));

        CommentEntity entity = CommentEntity.builder()
                .ticketId(ticketId)
                .authorUid(uid)
                .content(request.getContent())
                .createdAt(Instant.now().toString())
                .build();

        CommentEntity saved = helpdeskRepository.saveComment(entity);
        log.info("[HELPDESK] Comment added to ticket: {}", ticketId);
        return mapToCommentResponse(saved);
    }

    @Override
    public TicketResponse rateTicket(String id, RateTicketRequest request) {
        String uid = getCurrentUid();
        TicketEntity entity = helpdeskRepository.findTicketById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Ticket not found"));

        if (!entity.getRaisedBy().equals(uid)) {
            throw new ValidationException("Only the ticket creator can rate the ticket");
        }

        if (!HelpdeskConstants.STATUS_RESOLVED.equals(entity.getStatus())
                && !HelpdeskConstants.STATUS_CLOSED.equals(entity.getStatus())) {
            throw new ValidationException("Can only rate resolved or closed tickets");
        }

        entity.setRating(request.getRating());
        entity.setRatingComment(request.getComment());
        entity.setUpdatedAt(Instant.now().toString());

        TicketEntity updated = helpdeskRepository.updateTicket(entity);
        log.info("[HELPDESK] Ticket rated: {} with rating: {}", id, request.getRating());
        return mapToTicketResponse(updated);
    }

    @Override
    public PaginatedResponse<TicketResponse> listAllTickets(int page, int size, String societyId, String status, String category) {
        List<TicketEntity> tickets = helpdeskRepository.findAllTickets(societyId, page, size, status, category);
        long total = helpdeskRepository.countAllTickets(societyId, status, category);
        int totalPages = (int) Math.ceil((double) total / size);

        List<TicketResponse> content = tickets.stream()
                .map(this::mapToTicketResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<TicketResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public CategoryResponse createCategory(CreateCategoryRequest request) {
        log.info("[HELPDESK] Creating category: {}", request.getName());

        CategoryEntity entity = CategoryEntity.builder()
                .name(request.getName())
                .description(request.getDescription())
                .subCategories(request.getSubCategories())
                .societyId(request.getSocietyId())
                .createdAt(Instant.now().toString())
                .build();

        CategoryEntity saved = helpdeskRepository.saveCategory(entity);
        log.info("[HELPDESK] Category created with ID: {}", saved.getId());
        return mapToCategoryResponse(saved);
    }

    @Override
    public PaginatedResponse<CategoryResponse> listCategories(int page, int size, String societyId) {
        List<CategoryEntity> categories = helpdeskRepository.findCategories(societyId, page, size);
        long total = helpdeskRepository.countCategories(societyId);
        int totalPages = (int) Math.ceil((double) total / size);

        List<CategoryResponse> content = categories.stream()
                .map(this::mapToCategoryResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<CategoryResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public HelpdeskReportResponse getReport(String societyId) {
        long total = helpdeskRepository.countAllTickets(societyId, null, null);
        long open = helpdeskRepository.countAllTickets(societyId, HelpdeskConstants.STATUS_OPEN, null);
        long resolved = helpdeskRepository.countAllTickets(societyId, HelpdeskConstants.STATUS_RESOLVED, null);
        long escalated = helpdeskRepository.countAllTickets(societyId, HelpdeskConstants.STATUS_ESCALATED, null);

        return HelpdeskReportResponse.builder()
                .totalTickets(total)
                .openTickets(open)
                .resolvedTickets(resolved)
                .escalatedTickets(escalated)
                .averageResolutionTimeHours(0)
                .slaAdherencePercentage(total > 0 ? ((double) (total - escalated) / total) * 100 : 100)
                .ticketsByCategory(new HashMap<>())
                .ticketsByPriority(new HashMap<>())
                .build();
    }

    // --- Mappers ---

    private TicketResponse mapToTicketResponse(TicketEntity entity) {
        return TicketResponse.builder()
                .id(entity.getId())
                .title(entity.getTitle())
                .description(entity.getDescription())
                .category(entity.getCategory())
                .subCategory(entity.getSubCategory())
                .attachments(entity.getAttachments())
                .flatId(entity.getFlatId())
                .raisedBy(entity.getRaisedBy())
                .status(entity.getStatus())
                .priority(entity.getPriority())
                .assignedTo(entity.getAssignedTo())
                .slaDeadline(parseInstant(entity.getSlaDeadline()))
                .rating(entity.getRating())
                .ratingComment(entity.getRatingComment())
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private CategoryResponse mapToCategoryResponse(CategoryEntity entity) {
        return CategoryResponse.builder()
                .id(entity.getId())
                .name(entity.getName())
                .description(entity.getDescription())
                .subCategories(entity.getSubCategories())
                .societyId(entity.getSocietyId())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private CommentResponse mapToCommentResponse(CommentEntity entity) {
        return CommentResponse.builder()
                .id(entity.getId())
                .ticketId(entity.getTicketId())
                .authorUid(entity.getAuthorUid())
                .content(entity.getContent())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
