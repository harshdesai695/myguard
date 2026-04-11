package com.myguard.dailyhelp.dto.request;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class UpdateDailyHelpRequest {
    private String name;
    private String phone;
    private String photoUrl;
    private String type;
    private List<String> flatIds;
    private String schedule;
}
