package com.myguard.communication.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class SendMessageRequest {

    @NotBlank(message = "Message content is required")
    private String content;

    private String attachmentUrl;
}
