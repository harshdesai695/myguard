package com.myguard.communication.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class NoticeResponse {
    String id;
    String title;
    String body;
    String type;
    List<String> attachments;
    String postedBy;
    Instant postedAt;
    Instant expiryDate;
    String societyId;
    Instant createdAt;
}
