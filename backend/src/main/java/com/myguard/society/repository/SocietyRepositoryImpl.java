package com.myguard.society.repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import org.springframework.stereotype.Repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.auth.constants.AuthConstants;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.society.constants.SocietyConstants;
import com.myguard.society.view.FlatEntity;
import com.myguard.society.view.SocietyEntity;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class SocietyRepositoryImpl implements SocietyRepository {

    private final Firestore firestore;

    private CollectionReference getSocietiesCollection() {
        return firestore.collection(SocietyConstants.COLLECTION_SOCIETIES);
    }

    private CollectionReference getFlatsCollection() {
        return firestore.collection(SocietyConstants.COLLECTION_FLATS);
    }

    @Override
    public SocietyEntity saveSociety(SocietyEntity society) {
        try {
            DocumentReference docRef;
            if (society.getId() != null) {
                docRef = getSocietiesCollection().document(society.getId());
            } else {
                docRef = getSocietiesCollection().document();
                society.setId(docRef.getId());
            }
            docRef.set(society).get();
            log.debug("[SOCIETY] Society saved with ID: {}", society.getId());
            return society;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save society", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save society", e);
        }
    }

    @Override
    public Optional<SocietyEntity> findSocietyById(String id) {
        try {
            DocumentSnapshot doc = getSocietiesCollection().document(id).get().get();
            if (doc.exists()) {
                return Optional.ofNullable(doc.toObject(SocietyEntity.class));
            }
            return Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find society", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find society", e);
        }
    }

    @Override
    public SocietyEntity updateSociety(SocietyEntity society) {
        try {
            getSocietiesCollection().document(society.getId()).set(society).get();
            log.debug("[SOCIETY] Society updated with ID: {}", society.getId());
            return society;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update society", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update society", e);
        }
    }

    @Override
    public List<SocietyEntity> findAllSocieties(int page, int size) {
        try {
            Query query = getSocietiesCollection()
                    .orderBy(SocietyConstants.FIELD_NAME)
                    .offset(page * size)
                    .limit(size);

            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(SocietyEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list societies", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list societies", e);
        }
    }

    @Override
    public long countSocieties() {
        try {
            return getSocietiesCollection().get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count societies", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count societies", e);
        }
    }

    @Override
    public FlatEntity saveFlat(FlatEntity flat) {
        try {
            DocumentReference docRef;
            if (flat.getId() != null) {
                docRef = getFlatsCollection().document(flat.getId());
            } else {
                docRef = getFlatsCollection().document();
                flat.setId(docRef.getId());
            }
            docRef.set(flat).get();
            log.debug("[SOCIETY] Flat saved with ID: {}", flat.getId());
            return flat;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save flat", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save flat", e);
        }
    }

    @Override
    public Optional<FlatEntity> findFlatById(String flatId) {
        try {
            DocumentSnapshot doc = getFlatsCollection().document(flatId).get().get();
            if (doc.exists()) {
                return Optional.ofNullable(doc.toObject(FlatEntity.class));
            }
            return Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find flat", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find flat", e);
        }
    }

    @Override
    public FlatEntity updateFlat(FlatEntity flat) {
        try {
            getFlatsCollection().document(flat.getId()).set(flat).get();
            log.debug("[SOCIETY] Flat updated with ID: {}", flat.getId());
            return flat;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update flat", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update flat", e);
        }
    }

    @Override
    public List<FlatEntity> findFlatsBySocietyId(String societyId, int page, int size) {
        try {
            Query query = getFlatsCollection()
                    .whereEqualTo(SocietyConstants.FIELD_SOCIETY_ID, societyId)
                    .offset(page * size)
                    .limit(size);

            QuerySnapshot snapshot = query.get().get();
            List<FlatEntity> result = snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(FlatEntity.class))
                    .collect(Collectors.toList());
            result.sort((a, b) -> {
                if (a.getFlatNumber() == null || b.getFlatNumber() == null) return 0;
                return a.getFlatNumber().compareToIgnoreCase(b.getFlatNumber());
            });
            return result;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list flats", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list flats", e);
        }
    }

    @Override
    public long countFlatsBySocietyId(String societyId) {
        try {
            Query query = getFlatsCollection()
                    .whereEqualTo(SocietyConstants.FIELD_SOCIETY_ID, societyId);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count flats", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count flats", e);
        }
    }

    @Override
    public List<String> findResidentUidsByFlatId(String flatId) {
        try {
            Query query = firestore.collection(AuthConstants.COLLECTION_USERS)
                    .whereEqualTo(AuthConstants.FIELD_FLAT_ID, flatId);

            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.getString(AuthConstants.FIELD_UID))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find residents", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find residents", e);
        }
    }
}
