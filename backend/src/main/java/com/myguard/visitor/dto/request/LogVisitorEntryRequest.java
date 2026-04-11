package com.myguard.visitor.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class LogVisitorEntryRequest {

    @NotBlank(message = "Visitor name is required")
    private String visitorName;

    @NotBlank(message = "Visitor phone is required")
    private String visitorPhone;

    private String photoUrl;

    @NotBlank(message = "Purpose is required")
    private String purpose;

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    private String vehicleNumber;
    private String preApprovalId;
    private String inviteCode;
}
