package com.myguard.marketplace.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CreateListingRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    private List<String> photos;

    @NotBlank(message = "Category is required")
    private String category;

    @Min(value = 0, message = "Price cannot be negative")
    private double price;

    @NotBlank(message = "Condition is required")
    private String condition;

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
