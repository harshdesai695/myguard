package com.myguard.marketplace.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /marketplace_listings/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ListingEntity {
    private String id;
    private String title;
    private String description;
    private List<String> photos;
    private String category;
    private double price;
    private String condition;
    private String postedBy;
    private String flatId;
    private String status;
    private String societyId;
    private Instant createdAt;
}
