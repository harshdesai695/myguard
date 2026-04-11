package com.myguard.marketplace.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class ListingResponse {
    String id;
    String title;
    String description;
    List<String> photos;
    String category;
    double price;
    String condition;
    String postedBy;
    String flatId;
    String status;
    String societyId;
    Instant createdAt;
}
