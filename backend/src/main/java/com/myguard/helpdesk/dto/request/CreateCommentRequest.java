package com.myguard.helpdesk.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreateCommentRequest {

    @NotBlank(message = "Comment content is required")
    private String content;
}
