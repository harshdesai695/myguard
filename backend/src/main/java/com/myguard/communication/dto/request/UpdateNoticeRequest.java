package com.myguard.communication.dto.request;

import lombok.Builder;
import lombok.Data;

import java.time.Instant;
import java.util.List;

@Data
@Builder
public class UpdateNoticeRequest {
    private String title;
    private String body;
    private String type;
    private List<String> attachments;
    private Instant expiryDate;
}
