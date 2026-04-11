package com.myguard.visitor.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreatePreApprovalRequest {

    @NotBlank(message = "Visitor name is required")
    private String visitorName;

    @NotBlank(message = "Visitor phone is required")
    private String visitorPhone;

    @NotBlank(message = "Purpose is required")
    private String purpose;

    private Long validHours;
}
