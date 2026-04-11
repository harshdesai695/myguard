package com.myguard.communication.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class GroupResponse {
    String id;
    String name;
    String description;
    String type;
    List<String> memberUids;
    String createdBy;
    String societyId;
    Instant createdAt;
}
