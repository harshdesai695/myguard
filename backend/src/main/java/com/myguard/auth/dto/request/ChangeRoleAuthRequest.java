package com.myguard.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ChangeRoleAuthRequest {

    @NotBlank(message = "Role is required")
    private String role;
}
