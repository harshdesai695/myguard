package com.myguard.helpdesk.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /helpdesk_categories/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CategoryEntity {
    private String id;
    private String name;
    private String description;
    private List<String> subCategories;
    private String societyId;
    private Instant createdAt;
}
