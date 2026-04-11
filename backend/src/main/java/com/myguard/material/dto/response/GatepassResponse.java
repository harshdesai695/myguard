package com.myguard.material.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class GatepassResponse {
    String id;
    String type;
    String description;
    List<String> items;
    String vehicleNumber;
    Instant expectedDate;
    String requestedBy;
    String flatId;
    String status;
    String approvedBy;
    String verifiedBy;
    Instant verifiedAt;
    String societyId;
    Instant createdAt;
}
