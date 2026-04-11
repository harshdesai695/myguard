package com.myguard.emergency.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class EmergencyContactResponse {
    String id;
    String name;
    String phone;
    String type;
    String address;
    String societyId;
    Instant createdAt;
}
