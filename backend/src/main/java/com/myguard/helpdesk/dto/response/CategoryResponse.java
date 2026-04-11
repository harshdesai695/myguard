package com.myguard.helpdesk.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;
import java.util.List;

@Value
@Builder
public class CategoryResponse {
    String id;
    String name;
    String description;
    List<String> subCategories;
    String societyId;
    Instant createdAt;
}
