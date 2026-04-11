package com.myguard.dailyhelp.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CreateDailyHelpRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Phone is required")
    private String phone;

    private String photoUrl;

    @NotBlank(message = "Type is required")
    private String type;

    private List<String> flatIds;
    private String schedule;
}
