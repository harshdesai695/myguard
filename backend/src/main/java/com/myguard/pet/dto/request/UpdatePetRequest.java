package com.myguard.pet.dto.request;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdatePetRequest {
    private String name;
    private String breed;
    private String type;
    private Integer age;
    private String photoUrl;
    private String vaccinationStatus;
}
