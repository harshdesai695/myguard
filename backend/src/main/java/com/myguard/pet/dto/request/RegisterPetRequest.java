package com.myguard.pet.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class RegisterPetRequest {

    @NotBlank(message = "Pet name is required")
    private String name;

    @NotBlank(message = "Breed is required")
    private String breed;

    @NotBlank(message = "Type is required")
    private String type;

    private int age;
    private String photoUrl;

    @NotBlank(message = "Flat ID is required")
    private String flatId;

    @NotBlank(message = "Society ID is required")
    private String societyId;
}
