package com.myguard.pet.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.pet.constants.PetConstants;
import com.myguard.pet.view.PetEntity;
import com.myguard.pet.view.VaccinationEntity;
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
public class PetRepositoryImpl implements PetRepository {

    private final Firestore firestore;

    private CollectionReference getPetsCollection() {
        return firestore.collection(PetConstants.COLLECTION_PETS);
    }

    private CollectionReference getVaccinationsCollection() {
        return firestore.collection(PetConstants.COLLECTION_VACCINATIONS);
    }

    @Override
    public PetEntity savePet(PetEntity pet) {
        try {
            DocumentReference docRef;
            if (pet.getId() != null) {
                docRef = getPetsCollection().document(pet.getId());
            } else {
                docRef = getPetsCollection().document();
                pet.setId(docRef.getId());
            }
            docRef.set(pet).get();
            log.debug("[PET] Pet saved with ID: {}", pet.getId());
            return pet;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save pet", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save pet", e);
        }
    }

    @Override
    public Optional<PetEntity> findPetById(String id) {
        try {
            DocumentSnapshot doc = getPetsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(PetEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find pet", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find pet", e);
        }
    }

    @Override
    public PetEntity updatePet(PetEntity pet) {
        try {
            getPetsCollection().document(pet.getId()).set(pet).get();
            log.debug("[PET] Pet updated with ID: {}", pet.getId());
            return pet;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update pet", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update pet", e);
        }
    }

    @Override
    public void deletePet(String id) {
        try {
            getPetsCollection().document(id).delete().get();
            log.debug("[PET] Pet deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete pet", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete pet", e);
        }
    }

    @Override
    public List<PetEntity> findPets(String societyId, int page, int size) {
        try {
            Query query = getPetsCollection()
                    .orderBy(PetConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(PetConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(PetEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list pets", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list pets", e);
        }
    }

    @Override
    public long countPets(String societyId) {
        try {
            Query query = getPetsCollection();
            if (societyId != null) {
                query = query.whereEqualTo(PetConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count pets", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count pets", e);
        }
    }

    @Override
    public VaccinationEntity saveVaccination(VaccinationEntity vaccination) {
        try {
            DocumentReference docRef;
            if (vaccination.getId() != null) {
                docRef = getVaccinationsCollection().document(vaccination.getId());
            } else {
                docRef = getVaccinationsCollection().document();
                vaccination.setId(docRef.getId());
            }
            docRef.set(vaccination).get();
            log.debug("[PET] Vaccination saved with ID: {}", vaccination.getId());
            return vaccination;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save vaccination", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save vaccination", e);
        }
    }

    @Override
    public List<VaccinationEntity> findVaccinationsByPetId(String petId) {
        try {
            QuerySnapshot snapshot = getVaccinationsCollection()
                    .whereEqualTo(PetConstants.FIELD_PET_ID, petId)
                    .orderBy(PetConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(VaccinationEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list vaccinations", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list vaccinations", e);
        }
    }
}
