package com.myguard.marketplace.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /marketplace_interests/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InterestEntity {
    private String id;
    private String listingId;
    private String interestedBy;
    private String message;
    private Instant createdAt;
}
