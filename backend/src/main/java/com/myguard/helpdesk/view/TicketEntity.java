package com.myguard.helpdesk.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Firestore collection: /helpdesk_tickets/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class TicketEntity {
    private String id;
    private String title;
    private String description;
    private String category;
    private String subCategory;
    private List<String> attachments;
    private String flatId;
    private String raisedBy;
    private String status;
    private String priority;
    private String assignedTo;
    private Object slaDeadline;
    private Integer rating;
    private String ratingComment;
    private String societyId;
    private Object createdAt;
    private Object updatedAt;
}
