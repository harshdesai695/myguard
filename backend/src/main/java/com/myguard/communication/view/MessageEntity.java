package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /group_messages/{id}
 * Document ID: Auto-generated
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageEntity {
    private String id;
    private String groupId;
    private String senderUid;
    private String content;
    private String attachmentUrl;
    private Instant sentAt;
    private Instant createdAt;
}
