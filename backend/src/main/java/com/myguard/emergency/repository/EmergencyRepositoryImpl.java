package com.myguard.emergency.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.emergency.constants.EmergencyConstants;
import com.myguard.emergency.view.EmergencyContactEntity;
import com.myguard.emergency.view.PanicAlertEntity;
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
public class EmergencyRepositoryImpl implements EmergencyRepository {

    private final Firestore firestore;

    private CollectionReference getPanicAlertsCollection() {
        return firestore.collection(EmergencyConstants.COLLECTION_PANIC_ALERTS);
    }

    private CollectionReference getEmergencyContactsCollection() {
        return firestore.collection(EmergencyConstants.COLLECTION_EMERGENCY_CONTACTS);
    }

    // --- Panic Alerts ---

    @Override
    public PanicAlertEntity savePanicAlert(PanicAlertEntity alert) {
        try {
            DocumentReference docRef;
            if (alert.getId() != null) {
                docRef = getPanicAlertsCollection().document(alert.getId());
            } else {
                docRef = getPanicAlertsCollection().document();
                alert.setId(docRef.getId());
            }
            docRef.set(alert).get();
            log.debug("[EMERGENCY] Panic alert saved with ID: {}", alert.getId());
            return alert;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save panic alert", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save panic alert", e);
        }
    }

    @Override
    public Optional<PanicAlertEntity> findPanicAlertById(String id) {
        try {
            DocumentSnapshot doc = getPanicAlertsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(PanicAlertEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find panic alert", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find panic alert", e);
        }
    }

    @Override
    public PanicAlertEntity updatePanicAlert(PanicAlertEntity alert) {
        try {
            getPanicAlertsCollection().document(alert.getId()).set(alert).get();
            log.debug("[EMERGENCY] Panic alert updated with ID: {}", alert.getId());
            return alert;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update panic alert", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update panic alert", e);
        }
    }

    @Override
    public List<PanicAlertEntity> findActivePanicAlerts(String societyId, int page, int size) {
        try {
            Query query = getPanicAlertsCollection()
                    .whereEqualTo(EmergencyConstants.FIELD_STATUS, EmergencyConstants.STATUS_ACTIVE)
                    .orderBy(EmergencyConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);

            if (societyId != null) {
                query = query.whereEqualTo(EmergencyConstants.FIELD_SOCIETY_ID, societyId);
            }

            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(PanicAlertEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list active panic alerts", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list active panic alerts", e);
        }
    }

    @Override
    public long countActivePanicAlerts(String societyId) {
        try {
            Query query = getPanicAlertsCollection()
                    .whereEqualTo(EmergencyConstants.FIELD_STATUS, EmergencyConstants.STATUS_ACTIVE);
            if (societyId != null) {
                query = query.whereEqualTo(EmergencyConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count active panic alerts", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count active panic alerts", e);
        }
    }

    // --- Emergency Contacts ---

    @Override
    public EmergencyContactEntity saveEmergencyContact(EmergencyContactEntity contact) {
        try {
            DocumentReference docRef;
            if (contact.getId() != null) {
                docRef = getEmergencyContactsCollection().document(contact.getId());
            } else {
                docRef = getEmergencyContactsCollection().document();
                contact.setId(docRef.getId());
            }
            docRef.set(contact).get();
            log.debug("[EMERGENCY] Emergency contact saved with ID: {}", contact.getId());
            return contact;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save emergency contact", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save emergency contact", e);
        }
    }

    @Override
    public Optional<EmergencyContactEntity> findEmergencyContactById(String id) {
        try {
            DocumentSnapshot doc = getEmergencyContactsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(EmergencyContactEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find emergency contact", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find emergency contact", e);
        }
    }

    @Override
    public EmergencyContactEntity updateEmergencyContact(EmergencyContactEntity contact) {
        try {
            getEmergencyContactsCollection().document(contact.getId()).set(contact).get();
            log.debug("[EMERGENCY] Emergency contact updated with ID: {}", contact.getId());
            return contact;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update emergency contact", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update emergency contact", e);
        }
    }

    @Override
    public void deleteEmergencyContact(String id) {
        try {
            getEmergencyContactsCollection().document(id).delete().get();
            log.debug("[EMERGENCY] Emergency contact deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete emergency contact", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete emergency contact", e);
        }
    }

    @Override
    public List<EmergencyContactEntity> findEmergencyContacts(String societyId, int page, int size) {
        try {
            Query query = getEmergencyContactsCollection()
                    .orderBy(EmergencyConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);

            if (societyId != null) {
                query = query.whereEqualTo(EmergencyConstants.FIELD_SOCIETY_ID, societyId);
            }

            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(EmergencyContactEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list emergency contacts", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list emergency contacts", e);
        }
    }

    @Override
    public long countEmergencyContacts(String societyId) {
        try {
            Query query = getEmergencyContactsCollection();
            if (societyId != null) {
                query = query.whereEqualTo(EmergencyConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count emergency contacts", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count emergency contacts", e);
        }
    }
}
