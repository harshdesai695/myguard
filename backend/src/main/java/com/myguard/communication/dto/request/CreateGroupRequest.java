package com.myguard.communication.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class CreateGroupRequest {

    @NotBlank(message = "Group name is required")
    private String name;

    private String description;

    @NotBlank(message = "Group type is required")
    private String type;

    private List<String> memberUids;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
