package com.myguard.visitor.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;

@Data
@Builder
public class CreateRecurringInviteRequest {

    @NotBlank(message = "Visitor name is required")
    private String visitorName;

    @NotBlank(message = "Visitor phone is required")
    private String visitorPhone;

    @NotBlank(message = "Purpose is required")
    private String purpose;

    @NotNull(message = "Valid from date is required")
    private Instant validFrom;

    @NotNull(message = "Valid until date is required")
    private Instant validUntil;
}
