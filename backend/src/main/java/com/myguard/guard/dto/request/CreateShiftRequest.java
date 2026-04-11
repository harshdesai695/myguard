package com.myguard.guard.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data @Builder
public class CreateShiftRequest {
    @NotBlank(message = "Guard UID is required") private String guardUid;
    @NotBlank(message = "Society ID is required") private String societyId;
    @NotBlank(message = "Shift name is required") private String shiftName;
    @NotBlank(message = "Start time is required") private String startTime;
    @NotBlank(message = "End time is required") private String endTime;
    @NotBlank(message = "Date is required") private String date;
}
