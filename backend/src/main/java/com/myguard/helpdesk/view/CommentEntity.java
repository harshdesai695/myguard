package com.myguard.helpdesk.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /ticket_comments/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CommentEntity {
    private String id;
    private String ticketId;
    private String authorUid;
    private String content;
    private Instant createdAt;
}
