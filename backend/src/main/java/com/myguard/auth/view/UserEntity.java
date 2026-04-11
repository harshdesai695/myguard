package com.myguard.auth.view;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

/**
 * Firestore collection: /users/{uid}
 * Document ID: Firebase UID
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserEntity {
    private String uid;
    private String name;
    private String email;
    private String phone;
    private String role;
    private String status;
    private String societyId;
    private String flatId;
    private String flatNumber;
    private String profilePhotoUrl;
    private Instant createdAt;
    private Instant updatedAt;
}
