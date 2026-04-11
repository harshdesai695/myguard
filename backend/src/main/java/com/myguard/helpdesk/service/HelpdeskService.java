package com.myguard.helpdesk.service;

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

public interface HelpdeskService {

    // Tickets
    TicketResponse createTicket(CreateTicketRequest request);
    PaginatedResponse<TicketResponse> listMyTickets(int page, int size);
    TicketResponse getTicketById(String id);
    TicketResponse updateTicketStatus(String id, UpdateTicketStatusRequest request);
    TicketResponse assignTicket(String id, AssignTicketRequest request);
    CommentResponse addComment(String ticketId, CreateCommentRequest request);
    TicketResponse rateTicket(String id, RateTicketRequest request);
    PaginatedResponse<TicketResponse> listAllTickets(int page, int size, String societyId, String status, String category);

    // Categories
    CategoryResponse createCategory(CreateCategoryRequest request);
    PaginatedResponse<CategoryResponse> listCategories(int page, int size, String societyId);

    // Reports
    HelpdeskReportResponse getReport(String societyId);
}
