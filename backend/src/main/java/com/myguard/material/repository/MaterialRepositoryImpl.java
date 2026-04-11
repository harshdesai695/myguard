package com.myguard.material.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.material.constants.MaterialConstants;
import com.myguard.material.view.GatepassEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Slf4j
@Repository
@RequiredArgsConstructor
public class MaterialRepositoryImpl implements MaterialRepository {

    private final Firestore firestore;

    private CollectionReference getGatepassesCollection() {
        return firestore.collection(MaterialConstants.COLLECTION_GATEPASSES);
    }

    @Override
    public GatepassEntity saveGatepass(GatepassEntity gatepass) {
        try {
            DocumentReference docRef;
            if (gatepass.getId() != null) {
                docRef = getGatepassesCollection().document(gatepass.getId());
            } else {
                docRef = getGatepassesCollection().document();
                gatepass.setId(docRef.getId());
            }
            docRef.set(gatepass).get();
            log.debug("[MATERIAL] Gatepass saved with ID: {}", gatepass.getId());
            return gatepass;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save gatepass", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save gatepass", e);
        }
    }

    @Override
    public Optional<GatepassEntity> findGatepassById(String id) {
        try {
            DocumentSnapshot doc = getGatepassesCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(GatepassEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find gatepass", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find gatepass", e);
        }
    }

    @Override
    public GatepassEntity updateGatepass(GatepassEntity gatepass) {
        try {
            getGatepassesCollection().document(gatepass.getId()).set(gatepass).get();
            log.debug("[MATERIAL] Gatepass updated with ID: {}", gatepass.getId());
            return gatepass;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update gatepass", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update gatepass", e);
        }
    }

    @Override
    public List<GatepassEntity> findGatepassesByRequestedBy(String requestedBy, int page, int size) {
        try {
            Query query = getGatepassesCollection()
                    .whereEqualTo(MaterialConstants.FIELD_REQUESTED_BY, requestedBy)
                    .orderBy(MaterialConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size)
                    .limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(GatepassEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list gatepasses", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list gatepasses", e);
        }
    }

    @Override
    public long countGatepassesByRequestedBy(String requestedBy) {
        try {
            return getGatepassesCollection()
                    .whereEqualTo(MaterialConstants.FIELD_REQUESTED_BY, requestedBy)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count gatepasses", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count gatepasses", e);
        }
    }

    @Override
    public List<GatepassEntity> findAllGatepasses(String societyId, int page, int size, String status) {
        try {
            Query query = getGatepassesCollection()
                    .orderBy(MaterialConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) query = query.whereEqualTo(MaterialConstants.FIELD_SOCIETY_ID, societyId);
            if (status != null) query = query.whereEqualTo(MaterialConstants.FIELD_STATUS, status);
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(GatepassEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list all gatepasses", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list all gatepasses", e);
        }
    }

    @Override
    public long countAllGatepasses(String societyId, String status) {
        try {
            Query query = getGatepassesCollection();
            if (societyId != null) query = query.whereEqualTo(MaterialConstants.FIELD_SOCIETY_ID, societyId);
            if (status != null) query = query.whereEqualTo(MaterialConstants.FIELD_STATUS, status);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count all gatepasses", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count all gatepasses", e);
        }
    }
}
