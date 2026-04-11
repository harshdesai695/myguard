package com.myguard.communication.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class MessageResponse {
    String id;
    String groupId;
    String senderUid;
    String content;
    String attachmentUrl;
    Instant sentAt;
    Instant createdAt;
}
