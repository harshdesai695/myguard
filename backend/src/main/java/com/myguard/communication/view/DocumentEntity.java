package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


/**
 * Firestore collection: /documents/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DocumentEntity {
    private String id;
    private String title;
    private String description;
    private String category;
    private String fileUrl;
    private String fileName;
    private String fileType;
    private String uploadedBy;
    private String societyId;
    private Object createdAt;
}
