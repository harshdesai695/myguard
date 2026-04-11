package com.myguard.auth.repository;

import com.myguard.auth.view.UserEntity;

import java.util.List;
import java.util.Optional;

public interface AuthRepository {
    UserEntity save(UserEntity user);
    Optional<UserEntity> findByUid(String uid);
    UserEntity update(UserEntity user);
    List<UserEntity> findAll(int page, int size, String roleFilter);
    long countAll(String roleFilter);
    Optional<UserEntity> findByEmail(String email);
}
