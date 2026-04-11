package com.myguard.guard.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data @Builder
public class LogPatrolRequest {
    @NotBlank(message = "Checkpoint ID is required") private String checkpointId;
    private String notes;
}
