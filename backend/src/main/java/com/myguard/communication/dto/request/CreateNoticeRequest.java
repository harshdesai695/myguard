package com.myguard.communication.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;
import java.util.List;

@Data
@Builder
public class CreateNoticeRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Body is required")
    private String body;

    @NotBlank(message = "Type is required")
    private String type;

    private List<String> attachments;
    private Instant expiryDate;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
