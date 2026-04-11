package com.myguard.marketplace.dto.request;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class UpdateListingRequest {
    private String title;
    private String description;
    private List<String> photos;
    private String category;
    private Double price;
    private String condition;
}
