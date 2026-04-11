package com.myguard.communication.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class DocumentResponse {
    String id;
    String title;
    String description;
    String category;
    String fileUrl;
    String fileName;
    String fileType;
    String uploadedBy;
    String societyId;
    Instant createdAt;
}
