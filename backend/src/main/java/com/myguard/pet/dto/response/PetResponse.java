package com.myguard.pet.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class PetResponse {
    String id;
    String name;
    String breed;
    String type;
    int age;
    String photoUrl;
    String ownerUid;
    String flatId;
    String vaccinationStatus;
    String societyId;
    Instant createdAt;
}
