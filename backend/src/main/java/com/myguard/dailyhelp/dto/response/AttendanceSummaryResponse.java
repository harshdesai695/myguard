package com.myguard.dailyhelp.dto.response;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class AttendanceSummaryResponse {
    String dailyHelpId;
    String month;
    int totalPresent;
    int totalAbsent;
    int totalLate;
    int workingDays;
}
