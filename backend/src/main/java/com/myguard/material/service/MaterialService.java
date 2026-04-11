package com.myguard.material.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.material.dto.request.CreateGatepassRequest;
import com.myguard.material.dto.response.GatepassResponse;

public interface MaterialService {

    GatepassResponse createGatepass(CreateGatepassRequest request);
    PaginatedResponse<GatepassResponse> listMyGatepasses(int page, int size);
    GatepassResponse getGatepassById(String id);
    GatepassResponse approveGatepass(String id);
    GatepassResponse verifyGatepass(String id);
    PaginatedResponse<GatepassResponse> listAllGatepasses(int page, int size, String societyId, String status);
}
