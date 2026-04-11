package com.myguard.dailyhelp.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.dailyhelp.dto.request.CreateDailyHelpRequest;
import com.myguard.dailyhelp.dto.request.UpdateDailyHelpRequest;
import com.myguard.dailyhelp.dto.response.AttendanceResponse;
import com.myguard.dailyhelp.dto.response.AttendanceSummaryResponse;
import com.myguard.dailyhelp.dto.response.DailyHelpResponse;

public interface DailyHelpService {
    DailyHelpResponse create(CreateDailyHelpRequest request);
    PaginatedResponse<DailyHelpResponse> listMyDailyHelps(int page, int size);
    DailyHelpResponse getById(String id);
    DailyHelpResponse update(String id, UpdateDailyHelpRequest request);
    void delete(String id);
    AttendanceResponse markAttendance(String dailyHelpId);
    PaginatedResponse<AttendanceResponse> getAttendanceHistory(String dailyHelpId, int page, int size);
    AttendanceSummaryResponse getAttendanceSummary(String dailyHelpId, String yearMonth);
}
