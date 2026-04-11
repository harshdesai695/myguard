package com.myguard.dailyhelp.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.dailyhelp.constants.DailyHelpConstants;
import com.myguard.dailyhelp.view.AttendanceEntity;
import com.myguard.dailyhelp.view.DailyHelpEntity;
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
public class DailyHelpRepositoryImpl implements DailyHelpRepository {

    private final Firestore firestore;

    private CollectionReference getDailyHelpsCollection() {
        return firestore.collection(DailyHelpConstants.COLLECTION_DAILY_HELPS);
    }

    private CollectionReference getAttendanceCollection() {
        return firestore.collection(DailyHelpConstants.COLLECTION_ATTENDANCE);
    }

    @Override
    public DailyHelpEntity save(DailyHelpEntity dailyHelp) {
        try {
            DocumentReference docRef = dailyHelp.getId() != null
                    ? getDailyHelpsCollection().document(dailyHelp.getId())
                    : getDailyHelpsCollection().document();
            if (dailyHelp.getId() == null) dailyHelp.setId(docRef.getId());
            docRef.set(dailyHelp).get();
            return dailyHelp;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save daily help", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save daily help", e);
        }
    }

    @Override
    public Optional<DailyHelpEntity> findById(String id) {
        try {
            DocumentSnapshot doc = getDailyHelpsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(DailyHelpEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find daily help", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find daily help", e);
        }
    }

    @Override
    public DailyHelpEntity update(DailyHelpEntity dailyHelp) {
        return save(dailyHelp);
    }

    @Override
    public void delete(String id) {
        try {
            getDailyHelpsCollection().document(id).delete().get();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete daily help", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete daily help", e);
        }
    }

    @Override
    public List<DailyHelpEntity> findByResidentUid(String residentUid, int page, int size) {
        try {
            Query query = getDailyHelpsCollection()
                    .whereEqualTo(DailyHelpConstants.FIELD_RESIDENT_UID, residentUid)
                    .orderBy(DailyHelpConstants.FIELD_NAME)
                    .offset(page * size).limit(size);
            return query.get().get().getDocuments().stream()
                    .map(doc -> doc.toObject(DailyHelpEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list daily helps", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list daily helps", e);
        }
    }

    @Override
    public long countByResidentUid(String residentUid) {
        try {
            return getDailyHelpsCollection()
                    .whereEqualTo(DailyHelpConstants.FIELD_RESIDENT_UID, residentUid)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count daily helps", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count daily helps", e);
        }
    }

    @Override
    public AttendanceEntity saveAttendance(AttendanceEntity attendance) {
        try {
            DocumentReference docRef = attendance.getId() != null
                    ? getAttendanceCollection().document(attendance.getId())
                    : getAttendanceCollection().document();
            if (attendance.getId() == null) attendance.setId(docRef.getId());
            docRef.set(attendance).get();
            return attendance;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save attendance", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save attendance", e);
        }
    }

    @Override
    public List<AttendanceEntity> findAttendanceByDailyHelpId(String dailyHelpId, int page, int size) {
        try {
            Query query = getAttendanceCollection()
                    .whereEqualTo(DailyHelpConstants.FIELD_DAILY_HELP_ID, dailyHelpId)
                    .orderBy(DailyHelpConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size).limit(size);
            return query.get().get().getDocuments().stream()
                    .map(doc -> doc.toObject(AttendanceEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list attendance", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list attendance", e);
        }
    }

    @Override
    public long countAttendanceByDailyHelpId(String dailyHelpId) {
        try {
            return getAttendanceCollection()
                    .whereEqualTo(DailyHelpConstants.FIELD_DAILY_HELP_ID, dailyHelpId)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count attendance", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count attendance", e);
        }
    }

    @Override
    public List<AttendanceEntity> findAttendanceByMonth(String dailyHelpId, String yearMonth) {
        try {
            Query query = getAttendanceCollection()
                    .whereEqualTo(DailyHelpConstants.FIELD_DAILY_HELP_ID, dailyHelpId)
                    .whereGreaterThanOrEqualTo(DailyHelpConstants.FIELD_DATE, yearMonth + "-01")
                    .whereLessThanOrEqualTo(DailyHelpConstants.FIELD_DATE, yearMonth + "-31");
            return query.get().get().getDocuments().stream()
                    .map(doc -> doc.toObject(AttendanceEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find attendance by month", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find attendance by month", e);
        }
    }
}
