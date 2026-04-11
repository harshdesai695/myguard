package com.myguard.communication.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UploadDocumentRequest {

    @NotBlank(message = "Title is required")
    private String title;

    private String description;

    @NotBlank(message = "Category is required")
    private String category;

    @NotBlank(message = "File URL is required")
    private String fileUrl;

    @NotBlank(message = "File name is required")
    private String fileName;

    private String fileType;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
