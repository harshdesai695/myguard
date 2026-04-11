package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /notices/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class NoticeEntity {
    private String id;
    private String title;
    private String body;
    private String type;
    private List<String> attachments;
    private String postedBy;
    private Instant postedAt;
    private Instant expiryDate;
    private String societyId;
    private Instant createdAt;
    private Instant updatedAt;
}
