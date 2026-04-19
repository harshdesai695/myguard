package com.myguard.helpdesk.repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import org.springframework.stereotype.Repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.helpdesk.constants.HelpdeskConstants;
import com.myguard.helpdesk.view.CategoryEntity;
import com.myguard.helpdesk.view.CommentEntity;
import com.myguard.helpdesk.view.TicketEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class HelpdeskRepositoryImpl implements HelpdeskRepository {

    private final Firestore firestore;

    private CollectionReference getTicketsCollection() {
        return firestore.collection(HelpdeskConstants.COLLECTION_TICKETS);
    }

    private CollectionReference getCategoriesCollection() {
        return firestore.collection(HelpdeskConstants.COLLECTION_CATEGORIES);
    }

    private CollectionReference getCommentsCollection() {
        return firestore.collection(HelpdeskConstants.COLLECTION_COMMENTS);
    }

    // --- Tickets ---

    @Override
    public TicketEntity saveTicket(TicketEntity ticket) {
        try {
            DocumentReference docRef;
            if (ticket.getId() != null) {
                docRef = getTicketsCollection().document(ticket.getId());
            } else {
                docRef = getTicketsCollection().document();
                ticket.setId(docRef.getId());
            }
            docRef.set(ticket).get();
            log.debug("[HELPDESK] Ticket saved with ID: {}", ticket.getId());
            return ticket;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save ticket", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save ticket", e);
        }
    }

    @Override
    public Optional<TicketEntity> findTicketById(String id) {
        try {
            DocumentSnapshot doc = getTicketsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(TicketEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find ticket", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find ticket", e);
        }
    }

    @Override
    public TicketEntity updateTicket(TicketEntity ticket) {
        try {
            getTicketsCollection().document(ticket.getId()).set(ticket).get();
            log.debug("[HELPDESK] Ticket updated with ID: {}", ticket.getId());
            return ticket;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update ticket", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update ticket", e);
        }
    }

    @Override
    public List<TicketEntity> findTicketsByRaisedBy(String raisedBy, int page, int size) {
        try {
            Query query = getTicketsCollection()
                    .whereEqualTo(HelpdeskConstants.FIELD_RAISED_BY, raisedBy)
                    .offset(page * size)
                    .limit(size);
            QuerySnapshot snapshot = query.get().get();
            List<TicketEntity> result = snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(TicketEntity.class))
                    .collect(Collectors.toList());
            result.sort((a, b) -> {
                if (a.getCreatedAt() == null || b.getCreatedAt() == null) return 0;
                return String.valueOf(b.getCreatedAt()).compareTo(String.valueOf(a.getCreatedAt()));
            });
            return result;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list tickets", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list tickets", e);
        }
    }

    @Override
    public long countTicketsByRaisedBy(String raisedBy) {
        try {
            return getTicketsCollection()
                    .whereEqualTo(HelpdeskConstants.FIELD_RAISED_BY, raisedBy)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count tickets", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count tickets", e);
        }
    }

    @Override
    public List<TicketEntity> findAllTickets(String societyId, int page, int size, String status, String category) {
        try {
            Query query = getTicketsCollection();
            if (societyId != null) query = query.whereEqualTo(HelpdeskConstants.FIELD_SOCIETY_ID, societyId);
            if (status != null) query = query.whereEqualTo(HelpdeskConstants.FIELD_STATUS, status);
            if (category != null) query = query.whereEqualTo(HelpdeskConstants.FIELD_CATEGORY, category);
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            List<TicketEntity> result = snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(TicketEntity.class))
                    .collect(Collectors.toList());
            result.sort((a, b) -> {
                if (a.getCreatedAt() == null || b.getCreatedAt() == null) return 0;
                return String.valueOf(b.getCreatedAt()).compareTo(String.valueOf(a.getCreatedAt()));
            });
            return result;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list all tickets", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list all tickets", e);
        }
    }

    @Override
    public long countAllTickets(String societyId, String status, String category) {
        try {
            Query query = getTicketsCollection();
            if (societyId != null) query = query.whereEqualTo(HelpdeskConstants.FIELD_SOCIETY_ID, societyId);
            if (status != null) query = query.whereEqualTo(HelpdeskConstants.FIELD_STATUS, status);
            if (category != null) query = query.whereEqualTo(HelpdeskConstants.FIELD_CATEGORY, category);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count all tickets", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count all tickets", e);
        }
    }

    // --- Categories ---

    @Override
    public CategoryEntity saveCategory(CategoryEntity category) {
        try {
            DocumentReference docRef;
            if (category.getId() != null) {
                docRef = getCategoriesCollection().document(category.getId());
            } else {
                docRef = getCategoriesCollection().document();
                category.setId(docRef.getId());
            }
            docRef.set(category).get();
            log.debug("[HELPDESK] Category saved with ID: {}", category.getId());
            return category;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save category", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save category", e);
        }
    }

    @Override
    public Optional<CategoryEntity> findCategoryById(String id) {
        try {
            DocumentSnapshot doc = getCategoriesCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(CategoryEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find category", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find category", e);
        }
    }

    @Override
    public List<CategoryEntity> findCategories(String societyId, int page, int size) {
        try {
            Query query = getCategoriesCollection();
            if (societyId != null) {
                query = query.whereEqualTo(HelpdeskConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            List<CategoryEntity> result = snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(CategoryEntity.class))
                    .collect(Collectors.toList());
            result.sort((a, b) -> {
                if (a.getCreatedAt() == null || b.getCreatedAt() == null) return 0;
                return String.valueOf(b.getCreatedAt()).compareTo(String.valueOf(a.getCreatedAt()));
            });
            return result;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list categories", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list categories", e);
        }
    }

    @Override
    public long countCategories(String societyId) {
        try {
            Query query = getCategoriesCollection();
            if (societyId != null) {
                query = query.whereEqualTo(HelpdeskConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count categories", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count categories", e);
        }
    }

    // --- Comments ---

    @Override
    public CommentEntity saveComment(CommentEntity comment) {
        try {
            DocumentReference docRef;
            if (comment.getId() != null) {
                docRef = getCommentsCollection().document(comment.getId());
            } else {
                docRef = getCommentsCollection().document();
                comment.setId(docRef.getId());
            }
            docRef.set(comment).get();
            log.debug("[HELPDESK] Comment saved with ID: {}", comment.getId());
            return comment;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save comment", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save comment", e);
        }
    }

    @Override
    public List<CommentEntity> findCommentsByTicketId(String ticketId) {
        try {
            QuerySnapshot snapshot = getCommentsCollection()
                    .whereEqualTo(HelpdeskConstants.FIELD_TICKET_ID, ticketId)
                    .get().get();
            List<CommentEntity> result = snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(CommentEntity.class))
                    .collect(Collectors.toList());
            result.sort((a, b) -> {
                if (a.getCreatedAt() == null || b.getCreatedAt() == null) return 0;
                return String.valueOf(a.getCreatedAt()).compareTo(String.valueOf(b.getCreatedAt()));
            });
            return result;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list comments", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list comments", e);
        }
    }
}
