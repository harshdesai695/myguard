package com.myguard.helpdesk.repository;

import com.myguard.helpdesk.view.CategoryEntity;
import com.myguard.helpdesk.view.CommentEntity;
import com.myguard.helpdesk.view.TicketEntity;

import java.util.List;
import java.util.Optional;

public interface HelpdeskRepository {

    // Tickets
    TicketEntity saveTicket(TicketEntity ticket);
    Optional<TicketEntity> findTicketById(String id);
    TicketEntity updateTicket(TicketEntity ticket);
    List<TicketEntity> findTicketsByRaisedBy(String raisedBy, int page, int size);
    long countTicketsByRaisedBy(String raisedBy);
    List<TicketEntity> findAllTickets(String societyId, int page, int size, String status, String category);
    long countAllTickets(String societyId, String status, String category);

    // Categories
    CategoryEntity saveCategory(CategoryEntity category);
    Optional<CategoryEntity> findCategoryById(String id);
    List<CategoryEntity> findCategories(String societyId, int page, int size);
    long countCategories(String societyId);

    // Comments
    CommentEntity saveComment(CommentEntity comment);
    List<CommentEntity> findCommentsByTicketId(String ticketId);
}
