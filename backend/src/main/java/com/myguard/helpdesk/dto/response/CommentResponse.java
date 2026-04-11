package com.myguard.helpdesk.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class CommentResponse {
    String id;
    String ticketId;
    String authorUid;
    String content;
    Instant createdAt;
}
