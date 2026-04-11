package com.myguard.society.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class SocietyResponse {
    String id;
    String name;
    String address;
    String city;
    String state;
    String pincode;
    int totalBlocks;
    int totalFlats;
    String logoUrl;
    String status;
    Instant createdAt;
    Instant updatedAt;
}
