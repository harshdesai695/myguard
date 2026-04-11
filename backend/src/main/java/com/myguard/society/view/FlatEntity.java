package com.myguard.society.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /flats/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class FlatEntity {
    private String id;
    private String societyId;
    private String block;
    private int floor;
    private String flatNumber;
    private String type;
    private String status;
    private String primaryResidentUid;
    private Instant createdAt;
    private Instant updatedAt;
}
