package com.myguard.communication.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CastVoteRequest {

    @NotEmpty(message = "At least one option must be selected")
    private List<String> selectedOptions;
}
