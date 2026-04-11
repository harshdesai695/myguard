package com.myguard.emergency.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TriggerPanicRequest {

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    private String location;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
