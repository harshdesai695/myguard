package com.myguard.visitor.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class GroupVisitorEntryRequest {

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    @NotBlank(message = "Purpose is required")
    private String purpose;

    @NotEmpty(message = "At least one visitor is required")
    private List<GroupVisitorDetail> visitors;

    private String vehicleNumber;

    @Data
    @Builder
    public static class GroupVisitorDetail {
        @NotBlank(message = "Visitor name is required")
        private String visitorName;

        @NotBlank(message = "Visitor phone is required")
        private String visitorPhone;

        private String photoUrl;
    }
}
