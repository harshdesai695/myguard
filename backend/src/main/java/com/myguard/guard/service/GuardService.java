package com.myguard.guard.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.guard.dto.request.CreateCheckpointRequest;
import com.myguard.guard.dto.request.CreateShiftRequest;
import com.myguard.guard.dto.request.LogPatrolRequest;
import com.myguard.guard.dto.request.SendIntercomRequest;
import com.myguard.guard.dto.response.*;

import java.time.Instant;

public interface GuardService {
    CheckpointResponse createCheckpoint(CreateCheckpointRequest request);
    PaginatedResponse<CheckpointResponse> listCheckpoints(int page, int size);
    PatrolResponse logPatrol(LogPatrolRequest request);
    PaginatedResponse<PatrolResponse> listPatrols(int page, int size, String guardUid, Instant from, Instant to);
    PatrolReportResponse getPatrolReport(Instant from, Instant to);
    ShiftResponse createShift(CreateShiftRequest request);
    PaginatedResponse<ShiftResponse> listShifts(int page, int size);
    IntercomResponse sendIntercom(String flatId, SendIntercomRequest request);
}
