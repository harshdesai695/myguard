package com.myguard.auth.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RegisterAuthRequest {

    @NotBlank(message = "Name is required")
    private String name;

    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Phone number is required")
    private String phone;

    @NotBlank(message = "Society ID is required")
    private String societyId;

    @NotBlank(message = "Flat number is required")
    private String flatNumber;

    private String flatId;

    private String role;

    private String profilePhotoUrl;
}
