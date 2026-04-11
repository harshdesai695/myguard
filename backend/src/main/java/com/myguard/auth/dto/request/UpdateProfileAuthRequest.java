package com.myguard.auth.dto.request;

import jakarta.validation.constraints.Email;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateProfileAuthRequest {

    private String name;

    @Email(message = "Invalid email format")
    private String email;

    private String phone;

    private String profilePhotoUrl;
}
