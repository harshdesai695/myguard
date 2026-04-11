package com.myguard.society.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class FlatResponse {
    String id;
    String societyId;
    String block;
    int floor;
    String flatNumber;
    String type;
    String status;
    String primaryResidentUid;
    Instant createdAt;
    Instant updatedAt;
}
