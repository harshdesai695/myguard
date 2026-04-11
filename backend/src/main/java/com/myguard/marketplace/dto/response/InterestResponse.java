package com.myguard.marketplace.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class InterestResponse {
    String id;
    String listingId;
    String interestedBy;
    String message;
    Instant createdAt;
}
