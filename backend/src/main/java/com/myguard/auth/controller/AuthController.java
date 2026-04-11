package com.myguard.auth.controller;

import com.myguard.auth.dto.request.ChangeRoleAuthRequest;
import com.myguard.auth.dto.request.ChangeStatusAuthRequest;
import com.myguard.auth.dto.request.RegisterAuthRequest;
import com.myguard.auth.dto.request.UpdateProfileAuthRequest;
import com.myguard.auth.dto.response.UserAuthResponse;
import com.myguard.auth.service.AuthService;
import com.myguard.common.constants.GlobalConstants;
import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<ApiResponse<UserAuthResponse>> register(
            @Valid @RequestBody RegisterAuthRequest request) {
        UserAuthResponse response = authService.register(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "User registered successfully"));
    }

    @GetMapping("/profile")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<UserAuthResponse>> getProfile() {
        UserAuthResponse response = authService.getProfile();
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/profile")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<UserAuthResponse>> updateProfile(
            @Valid @RequestBody UpdateProfileAuthRequest request) {
        UserAuthResponse response = authService.updateProfile(request);
        return ResponseEntity.ok(ApiResponse.success(response, "Profile updated successfully"));
    }

    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<UserAuthResponse>>> listUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String role) {
        PaginatedResponse<UserAuthResponse> response = authService.listUsers(page, size, role);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/users/{uid}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<UserAuthResponse>> getUserByUid(@PathVariable String uid) {
        UserAuthResponse response = authService.getUserByUid(uid);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PatchMapping("/users/{uid}/role")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<UserAuthResponse>> changeRole(
            @PathVariable String uid,
            @Valid @RequestBody ChangeRoleAuthRequest request) {
        UserAuthResponse response = authService.changeRole(uid, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Role updated successfully"));
    }

    @PatchMapping("/users/{uid}/status")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<ApiResponse<UserAuthResponse>> changeStatus(
            @PathVariable String uid,
            @Valid @RequestBody ChangeStatusAuthRequest request) {
        UserAuthResponse response = authService.changeStatus(uid, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Status updated successfully"));
    }
}
