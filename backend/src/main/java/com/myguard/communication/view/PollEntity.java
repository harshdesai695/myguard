package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /polls/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PollEntity {
    private String id;
    private String question;
    private List<String> options;
    private Instant startDate;
    private Instant endDate;
    private boolean isSecret;
    private boolean allowMultipleVotes;
    private String createdBy;
    private String societyId;
    private Instant createdAt;
}
