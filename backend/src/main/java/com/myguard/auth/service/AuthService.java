package com.myguard.auth.service;

import com.myguard.auth.dto.request.ChangeRoleAuthRequest;
import com.myguard.auth.dto.request.ChangeStatusAuthRequest;
import com.myguard.auth.dto.request.RegisterAuthRequest;
import com.myguard.auth.dto.request.UpdateProfileAuthRequest;
import com.myguard.auth.dto.response.UserAuthResponse;
import com.myguard.common.response.PaginatedResponse;

public interface AuthService {
    UserAuthResponse register(RegisterAuthRequest request);
    UserAuthResponse getProfile();
    UserAuthResponse updateProfile(UpdateProfileAuthRequest request);
    PaginatedResponse<UserAuthResponse> listUsers(int page, int size, String roleFilter);
    UserAuthResponse getUserByUid(String uid);
    UserAuthResponse changeRole(String uid, ChangeRoleAuthRequest request);
    UserAuthResponse changeStatus(String uid, ChangeStatusAuthRequest request);
}
