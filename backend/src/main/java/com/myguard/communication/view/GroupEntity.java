package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.util.List;

/**
 * Firestore collection: /communication_groups/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GroupEntity {
    private String id;
    private String name;
    private String description;
    private String type;
    private List<String> memberUids;
    private String createdBy;
    private String societyId;
    private Instant createdAt;
}
