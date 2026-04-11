package com.myguard.auth.dto.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class UserAuthResponse {
    String uid;
    String name;
    String email;
    String phone;
    String role;
    String status;
    String societyId;
    String flatId;
    String flatNumber;
    String profilePhotoUrl;
    Instant createdAt;
    Instant updatedAt;
}
