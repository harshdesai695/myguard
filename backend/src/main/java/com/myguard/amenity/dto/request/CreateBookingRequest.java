package com.myguard.amenity.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CreateBookingRequest {

    @NotBlank(message = "Amenity ID is required")
    private String amenityId;

    private String flatId;

    @NotBlank(message = "Slot date is required")
    private String slotDate;

    @NotBlank(message = "Start time is required")
    private String slotStartTime;

    @NotBlank(message = "End time is required")
    private String slotEndTime;

    private int companions;
    private String societyId;
}
