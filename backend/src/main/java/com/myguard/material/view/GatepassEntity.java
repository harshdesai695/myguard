package com.myguard.material.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * Firestore collection: /material_gatepasses/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class GatepassEntity {
    private String id;
    private String type;
    private String description;
    private List<String> items;
    private String vehicleNumber;
    private Object expectedDate;
    private String requestedBy;
    private String flatId;
    private String status;
    private String approvedBy;
    private String verifiedBy;
    private Object verifiedAt;
    private String societyId;
    private Object createdAt;
}
