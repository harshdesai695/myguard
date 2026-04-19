package com.myguard.guard.repository;

import java.time.Instant;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import org.springframework.stereotype.Repository;

import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.guard.constants.GuardConstants;
import com.myguard.guard.view.CheckpointEntity;
import com.myguard.guard.view.IntercomEntity;
import com.myguard.guard.view.PatrolEntity;
import com.myguard.guard.view.ShiftEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class GuardRepositoryImpl implements GuardRepository {

    private final Firestore firestore;

    @Override
    public CheckpointEntity saveCheckpoint(CheckpointEntity checkpoint) {
        try {
            DocumentReference docRef = checkpoint.getId() != null
                    ? firestore.collection(GuardConstants.COLLECTION_CHECKPOINTS).document(checkpoint.getId())
                    : firestore.collection(GuardConstants.COLLECTION_CHECKPOINTS).document();
            if (checkpoint.getId() == null) checkpoint.setId(docRef.getId());
            docRef.set(checkpoint).get();
            return checkpoint;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save checkpoint", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save checkpoint", e);
        }
    }

    @Override
    public List<CheckpointEntity> findAllCheckpoints(int page, int size) {
        try {
            QuerySnapshot snapshot = firestore.collection(GuardConstants.COLLECTION_CHECKPOINTS)
                    .orderBy(GuardConstants.FIELD_NAME).offset(page * size).limit(size).get().get();
            return snapshot.getDocuments().stream().map(d -> d.toObject(CheckpointEntity.class)).collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list checkpoints", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list checkpoints", e);
        }
    }

    @Override
    public long countCheckpoints() {
        try {
            return firestore.collection(GuardConstants.COLLECTION_CHECKPOINTS).get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count checkpoints", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count checkpoints", e);
        }
    }

    @Override
    public PatrolEntity savePatrol(PatrolEntity patrol) {
        try {
            DocumentReference docRef = patrol.getId() != null
                    ? firestore.collection(GuardConstants.COLLECTION_PATROLS).document(patrol.getId())
                    : firestore.collection(GuardConstants.COLLECTION_PATROLS).document();
            if (patrol.getId() == null) patrol.setId(docRef.getId());
            docRef.set(patrol).get();
            return patrol;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save patrol", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save patrol", e);
        }
    }

    @Override
    public List<PatrolEntity> findPatrols(int page, int size, String guardUid, Instant from, Instant to) {
        try {
            Query query = firestore.collection(GuardConstants.COLLECTION_PATROLS);
            if (guardUid != null) query = query.whereEqualTo(GuardConstants.FIELD_GUARD_UID, guardUid);
            if (from != null) query = query.whereGreaterThanOrEqualTo(GuardConstants.FIELD_SCANNED_AT, from);
            if (to != null) query = query.whereLessThanOrEqualTo(GuardConstants.FIELD_SCANNED_AT, to);
            QuerySnapshot snapshot = query.offset(page * size).limit(size).get().get();
            List<PatrolEntity> result = snapshot.getDocuments().stream().map(d -> d.toObject(PatrolEntity.class)).collect(Collectors.toList());
            result.sort((a, b) -> {
                if (a.getScannedAt() == null || b.getScannedAt() == null) return 0;
                return String.valueOf(b.getScannedAt()).compareTo(String.valueOf(a.getScannedAt()));
            });
            return result;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list patrols", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list patrols", e);
        }
    }

    @Override
    public long countPatrols(String guardUid, Instant from, Instant to) {
        try {
            Query query = firestore.collection(GuardConstants.COLLECTION_PATROLS);
            if (guardUid != null) query = query.whereEqualTo(GuardConstants.FIELD_GUARD_UID, guardUid);
            if (from != null) query = query.whereGreaterThanOrEqualTo(GuardConstants.FIELD_SCANNED_AT, from);
            if (to != null) query = query.whereLessThanOrEqualTo(GuardConstants.FIELD_SCANNED_AT, to);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count patrols", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count patrols", e);
        }
    }

    @Override
    public ShiftEntity saveShift(ShiftEntity shift) {
        try {
            DocumentReference docRef = shift.getId() != null
                    ? firestore.collection(GuardConstants.COLLECTION_SHIFTS).document(shift.getId())
                    : firestore.collection(GuardConstants.COLLECTION_SHIFTS).document();
            if (shift.getId() == null) shift.setId(docRef.getId());
            docRef.set(shift).get();
            return shift;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save shift", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save shift", e);
        }
    }

    @Override
    public List<ShiftEntity> findShifts(int page, int size) {
        try {
            QuerySnapshot snapshot = firestore.collection(GuardConstants.COLLECTION_SHIFTS)
                    .orderBy(GuardConstants.FIELD_DATE, Query.Direction.DESCENDING)
                    .offset(page * size).limit(size).get().get();
            return snapshot.getDocuments().stream().map(d -> d.toObject(ShiftEntity.class)).collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list shifts", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list shifts", e);
        }
    }

    @Override
    public long countShifts() {
        try {
            return firestore.collection(GuardConstants.COLLECTION_SHIFTS).get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count shifts", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count shifts", e);
        }
    }

    @Override
    public IntercomEntity saveIntercom(IntercomEntity intercom) {
        try {
            DocumentReference docRef = intercom.getId() != null
                    ? firestore.collection(GuardConstants.COLLECTION_INTERCOMS).document(intercom.getId())
                    : firestore.collection(GuardConstants.COLLECTION_INTERCOMS).document();
            if (intercom.getId() == null) intercom.setId(docRef.getId());
            docRef.set(intercom).get();
            return intercom;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save intercom", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save intercom", e);
        }
    }
}
