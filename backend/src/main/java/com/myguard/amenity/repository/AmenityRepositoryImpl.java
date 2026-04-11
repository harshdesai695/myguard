package com.myguard.amenity.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.amenity.constants.AmenityConstants;
import com.myguard.amenity.view.AmenityEntity;
import com.myguard.amenity.view.BookingEntity;
import com.myguard.common.exception.FirebaseOperationException;
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
public class AmenityRepositoryImpl implements AmenityRepository {

    private final Firestore firestore;

    private CollectionReference getAmenitiesCollection() {
        return firestore.collection(AmenityConstants.COLLECTION_AMENITIES);
    }

    private CollectionReference getBookingsCollection() {
        return firestore.collection(AmenityConstants.COLLECTION_BOOKINGS);
    }

    @Override
    public AmenityEntity saveAmenity(AmenityEntity amenity) {
        try {
            DocumentReference docRef;
            if (amenity.getId() != null) {
                docRef = getAmenitiesCollection().document(amenity.getId());
            } else {
                docRef = getAmenitiesCollection().document();
                amenity.setId(docRef.getId());
            }
            docRef.set(amenity).get();
            log.debug("[AMENITY] Amenity saved with ID: {}", amenity.getId());
            return amenity;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save amenity", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save amenity", e);
        }
    }

    @Override
    public Optional<AmenityEntity> findAmenityById(String id) {
        try {
            DocumentSnapshot doc = getAmenitiesCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(AmenityEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find amenity", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find amenity", e);
        }
    }

    @Override
    public AmenityEntity updateAmenity(AmenityEntity amenity) {
        try {
            getAmenitiesCollection().document(amenity.getId()).set(amenity).get();
            log.debug("[AMENITY] Amenity updated with ID: {}", amenity.getId());
            return amenity;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update amenity", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update amenity", e);
        }
    }

    @Override
    public List<AmenityEntity> findAmenities(String societyId, int page, int size) {
        try {
            Query query = getAmenitiesCollection()
                    .orderBy(AmenityConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(AmenityConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(AmenityEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list amenities", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list amenities", e);
        }
    }

    @Override
    public long countAmenities(String societyId) {
        try {
            Query query = getAmenitiesCollection();
            if (societyId != null) {
                query = query.whereEqualTo(AmenityConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count amenities", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count amenities", e);
        }
    }

    @Override
    public BookingEntity saveBooking(BookingEntity booking) {
        try {
            DocumentReference docRef;
            if (booking.getId() != null) {
                docRef = getBookingsCollection().document(booking.getId());
            } else {
                docRef = getBookingsCollection().document();
                booking.setId(docRef.getId());
            }
            docRef.set(booking).get();
            log.debug("[AMENITY] Booking saved with ID: {}", booking.getId());
            return booking;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save booking", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save booking", e);
        }
    }

    @Override
    public Optional<BookingEntity> findBookingById(String id) {
        try {
            DocumentSnapshot doc = getBookingsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(BookingEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find booking", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find booking", e);
        }
    }

    @Override
    public BookingEntity updateBooking(BookingEntity booking) {
        try {
            getBookingsCollection().document(booking.getId()).set(booking).get();
            log.debug("[AMENITY] Booking updated with ID: {}", booking.getId());
            return booking;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update booking", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update booking", e);
        }
    }

    @Override
    public List<BookingEntity> findBookingsByResident(String residentUid, int page, int size) {
        try {
            Query query = getBookingsCollection()
                    .whereEqualTo(AmenityConstants.FIELD_RESIDENT_UID, residentUid)
                    .orderBy(AmenityConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(BookingEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list bookings", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list bookings", e);
        }
    }

    @Override
    public long countBookingsByResident(String residentUid) {
        try {
            return getBookingsCollection()
                    .whereEqualTo(AmenityConstants.FIELD_RESIDENT_UID, residentUid)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count bookings", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count bookings", e);
        }
    }

    @Override
    public List<BookingEntity> findBookingsByAmenityAndDate(String amenityId, String date) {
        try {
            Query query = getBookingsCollection()
                    .whereEqualTo(AmenityConstants.FIELD_AMENITY_ID, amenityId)
                    .whereEqualTo(AmenityConstants.FIELD_SLOT_DATE, date);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(BookingEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find bookings by amenity and date", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find bookings by amenity and date", e);
        }
    }

    @Override
    public List<BookingEntity> findAllBookings(int page, int size) {
        try {
            Query query = getBookingsCollection()
                    .orderBy(AmenityConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(BookingEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list all bookings", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list all bookings", e);
        }
    }

    @Override
    public long countAllBookings() {
        try {
            return getBookingsCollection().get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count all bookings", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count all bookings", e);
        }
    }
}
