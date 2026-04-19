package com.myguard.auth.service;

import java.time.Instant;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.myguard.auth.constants.AuthConstants;
import com.myguard.auth.dto.request.ChangeRoleAuthRequest;
import com.myguard.auth.dto.request.ChangeStatusAuthRequest;
import com.myguard.auth.dto.request.RegisterAuthRequest;
import com.myguard.auth.dto.request.UpdateProfileAuthRequest;
import com.myguard.auth.dto.response.UserAuthResponse;
import com.myguard.auth.repository.AuthRepository;
import com.myguard.auth.view.UserEntity;
import com.myguard.common.constants.GlobalConstants;
import com.myguard.common.exception.ConflictException;
import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.exception.ValidationException;
import com.myguard.common.response.PaginatedResponse;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthRepository authRepository;

    private static final Set<String> VALID_ROLES = Set.of(
            GlobalConstants.ROLE_RESIDENT,
            GlobalConstants.ROLE_GUARD,
            GlobalConstants.ROLE_ADMIN
    );

    private static final Set<String> VALID_STATUSES = Set.of(
            AuthConstants.STATUS_ACTIVE,
            AuthConstants.STATUS_DEACTIVATED,
            AuthConstants.STATUS_PENDING
    );

    @Override
    public UserAuthResponse register(RegisterAuthRequest request) {
        String uid = getCurrentUid();
        log.info("[AUTH] Registration attempt for user");

        authRepository.findByUid(uid).ifPresent(existing -> {
            throw new ConflictException("User already registered");
        });

        String role = request.getRole() != null ? request.getRole() : GlobalConstants.ROLE_RESIDENT;
        if (!VALID_ROLES.contains(role)) {
            throw new ValidationException("Invalid role: " + role);
        }

        if ((GlobalConstants.ROLE_GUARD.equals(role) || GlobalConstants.ROLE_ADMIN.equals(role))
                && !isCurrentUserAdmin()) {
            throw new ValidationException("Only admins can assign GUARD or ADMIN roles");
        }

        UserEntity user = UserEntity.builder()
                .uid(uid)
                .name(request.getName())
                .email(request.getEmail())
                .phone(request.getPhone())
                .role(role)
                .status(AuthConstants.STATUS_ACTIVE)
                .societyId(request.getSocietyId())
                .flatId(request.getFlatId())
                .flatNumber(request.getFlatNumber())
                .profilePhotoUrl(request.getProfilePhotoUrl())
                .createdAt(Instant.now().toString())
                .updatedAt(Instant.now().toString())
                .build();

        UserEntity saved = authRepository.save(user);
        log.info("[AUTH] User registered successfully");
        return mapToResponse(saved);
    }

    @Override
    public UserAuthResponse getProfile() {
        String uid = getCurrentUid();
        UserEntity user = authRepository.findByUid(uid)
                .orElseThrow(() -> new ResourceNotFoundException("User profile not found"));
        return mapToResponse(user);
    }

    @Override
    public UserAuthResponse updateProfile(UpdateProfileAuthRequest request) {
        String uid = getCurrentUid();
        UserEntity user = authRepository.findByUid(uid)
                .orElseThrow(() -> new ResourceNotFoundException("User profile not found"));

        if (request.getName() != null) {
            user.setName(request.getName());
        }
        if (request.getEmail() != null) {
            user.setEmail(request.getEmail());
        }
        if (request.getPhone() != null) {
            user.setPhone(request.getPhone());
        }
        if (request.getProfilePhotoUrl() != null) {
            user.setProfilePhotoUrl(request.getProfilePhotoUrl());
        }
        user.setUpdatedAt(Instant.now().toString());

        UserEntity updated = authRepository.update(user);
        log.info("[AUTH] Profile updated successfully");
        return mapToResponse(updated);
    }

    @Override
    public PaginatedResponse<UserAuthResponse> listUsers(int page, int size, String roleFilter) {
        log.info("[AUTH] Listing users - page: {}, size: {}", page, size);

        List<UserEntity> users = authRepository.findAll(page, size, roleFilter);
        long totalElements = authRepository.countAll(roleFilter);
        int totalPages = (int) Math.ceil((double) totalElements / size);

        List<UserAuthResponse> content = users.stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<UserAuthResponse>builder()
                .content(content)
                .page(page)
                .size(size)
                .totalElements(totalElements)
                .totalPages(totalPages)
                .hasNext(page < totalPages - 1)
                .hasPrevious(page > 0)
                .build();
    }

    @Override
    public UserAuthResponse getUserByUid(String uid) {
        UserEntity user = authRepository.findByUid(uid)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with UID: " + uid));
        return mapToResponse(user);
    }

    @Override
    public UserAuthResponse changeRole(String uid, ChangeRoleAuthRequest request) {
        if (!VALID_ROLES.contains(request.getRole())) {
            throw new ValidationException("Invalid role: " + request.getRole());
        }

        UserEntity user = authRepository.findByUid(uid)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with UID: " + uid));

        user.setRole(request.getRole());
        user.setUpdatedAt(Instant.now().toString());

        UserEntity updated = authRepository.update(user);
        log.info("[AUTH] Role changed for user to: {}", request.getRole());
        return mapToResponse(updated);
    }

    @Override
    public UserAuthResponse changeStatus(String uid, ChangeStatusAuthRequest request) {
        if (!VALID_STATUSES.contains(request.getStatus())) {
            throw new ValidationException("Invalid status: " + request.getStatus());
        }

        UserEntity user = authRepository.findByUid(uid)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with UID: " + uid));

        user.setStatus(request.getStatus());
        user.setUpdatedAt(Instant.now().toString());

        UserEntity updated = authRepository.update(user);
        log.info("[AUTH] Status changed for user to: {}", request.getStatus());
        return mapToResponse(updated);
    }

    private String getCurrentUid() {
        return (String) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
    }

    private boolean isCurrentUserAdmin() {
        return SecurityContextHolder.getContext().getAuthentication().getAuthorities().stream()
                .anyMatch(auth -> GlobalConstants.ROLE_ADMIN.equals(auth.getAuthority()));
    }

    private UserAuthResponse mapToResponse(UserEntity entity) {
        return UserAuthResponse.builder()
                .uid(entity.getUid())
                .name(entity.getName())
                .email(entity.getEmail())
                .phone(entity.getPhone())
                .role(entity.getRole())
                .status(entity.getStatus())
                .societyId(entity.getSocietyId())
                .flatId(entity.getFlatId())
                .flatNumber(entity.getFlatNumber())
                .profilePhotoUrl(entity.getProfilePhotoUrl())
                .createdAt(parseInstant(entity.getCreatedAt()))
                .updatedAt(parseInstant(entity.getUpdatedAt()))
                .build();
    }

    private Instant parseInstant(Object v) {
        if (v == null) return null;
        if (v instanceof com.google.cloud.Timestamp t) return t.toDate().toInstant();
        try { return Instant.parse(v.toString()); } catch (Exception e) { return null; }
    }
}
