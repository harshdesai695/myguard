package com.myguard.visitor.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.visitor.constants.VisitorConstants;
import com.myguard.visitor.view.PreApprovalEntity;
import com.myguard.visitor.view.RecurringInviteEntity;
import com.myguard.visitor.view.VisitorEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Slf4j
@Repository
@RequiredArgsConstructor
public class VisitorRepositoryImpl implements VisitorRepository {

    private final Firestore firestore;

    private CollectionReference getVisitorsCollection() {
        return firestore.collection(VisitorConstants.COLLECTION_VISITORS);
    }

    private CollectionReference getPreApprovalsCollection() {
        return firestore.collection(VisitorConstants.COLLECTION_PRE_APPROVALS);
    }

    private CollectionReference getRecurringInvitesCollection() {
        return firestore.collection(VisitorConstants.COLLECTION_RECURRING_INVITES);
    }

    // --- Visitors ---

    @Override
    public VisitorEntity saveVisitor(VisitorEntity visitor) {
        try {
            DocumentReference docRef;
            if (visitor.getId() != null) {
                docRef = getVisitorsCollection().document(visitor.getId());
            } else {
                docRef = getVisitorsCollection().document();
                visitor.setId(docRef.getId());
            }
            docRef.set(visitor).get();
            log.debug("[VISITOR] Visitor saved with ID: {}", visitor.getId());
            return visitor;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save visitor", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save visitor", e);
        }
    }

    @Override
    public Optional<VisitorEntity> findVisitorById(String id) {
        try {
            DocumentSnapshot doc = getVisitorsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(VisitorEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find visitor", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find visitor", e);
        }
    }

    @Override
    public VisitorEntity updateVisitor(VisitorEntity visitor) {
        try {
            getVisitorsCollection().document(visitor.getId()).set(visitor).get();
            log.debug("[VISITOR] Visitor updated with ID: {}", visitor.getId());
            return visitor;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update visitor", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update visitor", e);
        }
    }

    @Override
    public List<VisitorEntity> findVisitors(int page, int size, String flatId, String status, Instant from, Instant to) {
        try {
            Query query = getVisitorsCollection().orderBy(VisitorConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);

            if (flatId != null) query = query.whereEqualTo(VisitorConstants.FIELD_FLAT_ID, flatId);
            if (status != null) query = query.whereEqualTo(VisitorConstants.FIELD_STATUS, status);
            if (from != null) query = query.whereGreaterThanOrEqualTo(VisitorConstants.FIELD_ENTRY_TIME, from);
            if (to != null) query = query.whereLessThanOrEqualTo(VisitorConstants.FIELD_ENTRY_TIME, to);

            query = query.offset(page * size).limit(size);

            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(VisitorEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list visitors", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list visitors", e);
        }
    }

    @Override
    public long countVisitors(String flatId, String status, Instant from, Instant to) {
        try {
            Query query = getVisitorsCollection();
            if (flatId != null) query = query.whereEqualTo(VisitorConstants.FIELD_FLAT_ID, flatId);
            if (status != null) query = query.whereEqualTo(VisitorConstants.FIELD_STATUS, status);
            if (from != null) query = query.whereGreaterThanOrEqualTo(VisitorConstants.FIELD_ENTRY_TIME, from);
            if (to != null) query = query.whereLessThanOrEqualTo(VisitorConstants.FIELD_ENTRY_TIME, to);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count visitors", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count visitors", e);
        }
    }

    @Override
    public List<VisitorEntity> findOverstayingVisitors(Instant threshold, int page, int size) {
        try {
            Query query = getVisitorsCollection()
                    .whereEqualTo(VisitorConstants.FIELD_STATUS, VisitorConstants.STATUS_APPROVED)
                    .whereLessThan(VisitorConstants.FIELD_ENTRY_TIME, threshold)
                    .offset(page * size)
                    .limit(size);

            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(VisitorEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find overstaying visitors", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find overstaying visitors", e);
        }
    }

    @Override
    public long countOverstayingVisitors(Instant threshold) {
        try {
            Query query = getVisitorsCollection()
                    .whereEqualTo(VisitorConstants.FIELD_STATUS, VisitorConstants.STATUS_APPROVED)
                    .whereLessThan(VisitorConstants.FIELD_ENTRY_TIME, threshold);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count overstaying visitors", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count overstaying visitors", e);
        }
    }

    // --- Pre-approvals ---

    @Override
    public PreApprovalEntity savePreApproval(PreApprovalEntity preApproval) {
        try {
            DocumentReference docRef;
            if (preApproval.getId() != null) {
                docRef = getPreApprovalsCollection().document(preApproval.getId());
            } else {
                docRef = getPreApprovalsCollection().document();
                preApproval.setId(docRef.getId());
            }
            docRef.set(preApproval).get();
            log.debug("[VISITOR] Pre-approval saved with ID: {}", preApproval.getId());
            return preApproval;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save pre-approval", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save pre-approval", e);
        }
    }

    @Override
    public Optional<PreApprovalEntity> findPreApprovalById(String id) {
        try {
            DocumentSnapshot doc = getPreApprovalsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(PreApprovalEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find pre-approval", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find pre-approval", e);
        }
    }

    @Override
    public void deletePreApproval(String id) {
        try {
            getPreApprovalsCollection().document(id).delete().get();
            log.debug("[VISITOR] Pre-approval deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete pre-approval", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete pre-approval", e);
        }
    }

    @Override
    public List<PreApprovalEntity> findPreApprovalsByResident(String residentUid, int page, int size) {
        try {
            Query query = getPreApprovalsCollection()
                    .whereEqualTo(VisitorConstants.FIELD_RESIDENT_UID, residentUid)
                    .orderBy(VisitorConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size)
                    .limit(size);

            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(PreApprovalEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list pre-approvals", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list pre-approvals", e);
        }
    }

    @Override
    public long countPreApprovalsByResident(String residentUid) {
        try {
            Query query = getPreApprovalsCollection()
                    .whereEqualTo(VisitorConstants.FIELD_RESIDENT_UID, residentUid);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count pre-approvals", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count pre-approvals", e);
        }
    }

    @Override
    public Optional<PreApprovalEntity> findPreApprovalByCode(String inviteCode) {
        try {
            Query query = getPreApprovalsCollection()
                    .whereEqualTo(VisitorConstants.FIELD_INVITE_CODE, inviteCode)
                    .limit(1);

            QuerySnapshot snapshot = query.get().get();
            if (!snapshot.isEmpty()) {
                return Optional.ofNullable(snapshot.getDocuments().get(0).toObject(PreApprovalEntity.class));
            }
            return Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find pre-approval by code", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find pre-approval by code", e);
        }
    }

    // --- Recurring invites ---

    @Override
    public RecurringInviteEntity saveRecurringInvite(RecurringInviteEntity invite) {
        try {
            DocumentReference docRef;
            if (invite.getId() != null) {
                docRef = getRecurringInvitesCollection().document(invite.getId());
            } else {
                docRef = getRecurringInvitesCollection().document();
                invite.setId(docRef.getId());
            }
            docRef.set(invite).get();
            log.debug("[VISITOR] Recurring invite saved with ID: {}", invite.getId());
            return invite;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save recurring invite", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save recurring invite", e);
        }
    }

    @Override
    public Optional<RecurringInviteEntity> findRecurringInviteById(String id) {
        try {
            DocumentSnapshot doc = getRecurringInvitesCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(RecurringInviteEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find recurring invite", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find recurring invite", e);
        }
    }

    @Override
    public void deleteRecurringInvite(String id) {
        try {
            getRecurringInvitesCollection().document(id).delete().get();
            log.debug("[VISITOR] Recurring invite deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete recurring invite", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete recurring invite", e);
        }
    }

    @Override
    public List<RecurringInviteEntity> findRecurringInvitesByResident(String residentUid, int page, int size) {
        try {
            Query query = getRecurringInvitesCollection()
                    .whereEqualTo(VisitorConstants.FIELD_RESIDENT_UID, residentUid)
                    .orderBy(VisitorConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size)
                    .limit(size);

            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(RecurringInviteEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list recurring invites", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list recurring invites", e);
        }
    }

    @Override
    public long countRecurringInvitesByResident(String residentUid) {
        try {
            Query query = getRecurringInvitesCollection()
                    .whereEqualTo(VisitorConstants.FIELD_RESIDENT_UID, residentUid);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count recurring invites", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count recurring invites", e);
        }
    }
}
