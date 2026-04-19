package com.myguard.auth.repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import org.springframework.stereotype.Repository;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;
import com.myguard.auth.constants.AuthConstants;
import com.myguard.auth.view.UserEntity;
import com.myguard.common.exception.FirebaseOperationException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class AuthRepositoryImpl implements AuthRepository {

    private final Firestore firestore;

    private CollectionReference getUsersCollection() {
        return firestore.collection(AuthConstants.COLLECTION_USERS);
    }

    @Override
    public UserEntity save(UserEntity user) {
        try {
            DocumentReference docRef = getUsersCollection().document(user.getUid());
            ApiFuture<WriteResult> future = docRef.set(user);
            future.get();
            log.debug("[AUTH] User saved with UID: {}", user.getUid());
            return user;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save user", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save user", e);
        }
    }

    @Override
    public Optional<UserEntity> findByUid(String uid) {
        try {
            DocumentReference docRef = getUsersCollection().document(uid);
            ApiFuture<DocumentSnapshot> future = docRef.get();
            DocumentSnapshot document = future.get();
            if (document.exists()) {
                return Optional.ofNullable(document.toObject(UserEntity.class));
            }
            return Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find user", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find user", e);
        }
    }

    @Override
    public UserEntity update(UserEntity user) {
        try {
            DocumentReference docRef = getUsersCollection().document(user.getUid());
            ApiFuture<WriteResult> future = docRef.set(user);
            future.get();
            log.debug("[AUTH] User updated with UID: {}", user.getUid());
            return user;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update user", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update user", e);
        }
    }

    @Override
    public List<UserEntity> findAll(int page, int size, String roleFilter) {
        try {
            Query query = getUsersCollection();

            if (roleFilter != null && !roleFilter.isBlank()) {
                query = query.whereEqualTo(AuthConstants.FIELD_ROLE, roleFilter);
            }

            query = query.orderBy(AuthConstants.FIELD_NAME)
                         .offset(page * size)
                         .limit(size);

            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot snapshot = future.get();

            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(UserEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list users", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list users: " + e.getMessage(), e);
        }
    }

    @Override
    public long countAll(String roleFilter) {
        try {
            Query query = getUsersCollection();

            if (roleFilter != null && !roleFilter.isBlank()) {
                query = query.whereEqualTo(AuthConstants.FIELD_ROLE, roleFilter);
            }

            ApiFuture<QuerySnapshot> future = query.get();
            return future.get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count users", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count users", e);
        }
    }

    @Override
    public Optional<UserEntity> findByEmail(String email) {
        try {
            Query query = getUsersCollection()
                    .whereEqualTo(AuthConstants.FIELD_EMAIL, email)
                    .limit(1);

            ApiFuture<QuerySnapshot> future = query.get();
            QuerySnapshot snapshot = future.get();

            if (!snapshot.isEmpty()) {
                return Optional.ofNullable(snapshot.getDocuments().get(0).toObject(UserEntity.class));
            }
            return Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find user by email", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find user by email", e);
        }
    }
}
