package com.myguard.visitor.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreateGuestInviteRequest {

    @NotBlank(message = "Guest name is required")
    private String guestName;

    @NotBlank(message = "Guest phone is required")
    private String guestPhone;

    @NotBlank(message = "Purpose is required")
    private String purpose;

    private Long validHours;
}
