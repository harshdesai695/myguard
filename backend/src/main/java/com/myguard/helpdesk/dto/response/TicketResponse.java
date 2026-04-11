package com.myguard.helpdesk.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class TicketResponse {
    String id;
    String title;
    String description;
    String category;
    String subCategory;
    List<String> attachments;
    String flatId;
    String raisedBy;
    String status;
    String priority;
    String assignedTo;
    Instant slaDeadline;
    Integer rating;
    String ratingComment;
    String societyId;
    Instant createdAt;
    Instant updatedAt;
}
