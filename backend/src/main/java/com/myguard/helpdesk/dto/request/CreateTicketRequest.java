package com.myguard.helpdesk.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CreateTicketRequest {

    @NotBlank(message = "Title is required")
    private String title;

    @NotBlank(message = "Description is required")
    private String description;

    @NotBlank(message = "Category is required")
    private String category;

    private String subCategory;
    private List<String> attachments;

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    private String priority;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
