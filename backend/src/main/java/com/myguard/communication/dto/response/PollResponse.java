package com.myguard.communication.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;
import java.util.Map;

@Value
@Builder
public class PollResponse {
    String id;
    String question;
    List<String> options;
    Instant startDate;
    Instant endDate;
    boolean isSecret;
    boolean allowMultipleVotes;
    String createdBy;
    String societyId;
    Map<String, Long> results;
    long totalVotes;
    Instant createdAt;
}
