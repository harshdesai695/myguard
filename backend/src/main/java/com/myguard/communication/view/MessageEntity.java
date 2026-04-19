package com.myguard.communication.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


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
    private Object sentAt;
    private Object createdAt;
}
