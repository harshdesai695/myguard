package com.myguard.communication.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;
import java.util.List;

@Data
@Builder
public class CreatePollRequest {

    @NotBlank(message = "Question is required")
    private String question;

    @NotEmpty(message = "At least one option is required")
    private List<String> options;

    @NotNull(message = "Start date is required")
    private Instant startDate;

    @NotNull(message = "End date is required")
    private Instant endDate;

    private boolean isSecret;
    private boolean allowMultipleVotes;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
