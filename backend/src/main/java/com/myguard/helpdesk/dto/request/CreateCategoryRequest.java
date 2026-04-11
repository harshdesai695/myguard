package com.myguard.helpdesk.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CreateCategoryRequest {

    @NotBlank(message = "Name is required")
    private String name;

    private String description;
    private List<String> subCategories;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
