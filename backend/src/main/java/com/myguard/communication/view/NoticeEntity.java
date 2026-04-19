package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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
    private Object postedAt;
    private Object expiryDate;
    private String societyId;
    private Object createdAt;
    private Object updatedAt;
}
