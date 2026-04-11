package com.myguard.marketplace.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.marketplace.constants.MarketplaceConstants;
import com.myguard.marketplace.view.InterestEntity;
import com.myguard.marketplace.view.ListingEntity;
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
public class MarketplaceRepositoryImpl implements MarketplaceRepository {

    private final Firestore firestore;

    private CollectionReference getListingsCollection() {
        return firestore.collection(MarketplaceConstants.COLLECTION_LISTINGS);
    }

    private CollectionReference getInterestsCollection() {
        return firestore.collection(MarketplaceConstants.COLLECTION_INTERESTS);
    }

    @Override
    public ListingEntity saveListing(ListingEntity listing) {
        try {
            DocumentReference docRef;
            if (listing.getId() != null) {
                docRef = getListingsCollection().document(listing.getId());
            } else {
                docRef = getListingsCollection().document();
                listing.setId(docRef.getId());
            }
            docRef.set(listing).get();
            log.debug("[MARKETPLACE] Listing saved with ID: {}", listing.getId());
            return listing;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save listing", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save listing", e);
        }
    }

    @Override
    public Optional<ListingEntity> findListingById(String id) {
        try {
            DocumentSnapshot doc = getListingsCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(ListingEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find listing", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find listing", e);
        }
    }

    @Override
    public ListingEntity updateListing(ListingEntity listing) {
        try {
            getListingsCollection().document(listing.getId()).set(listing).get();
            log.debug("[MARKETPLACE] Listing updated with ID: {}", listing.getId());
            return listing;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update listing", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update listing", e);
        }
    }

    @Override
    public void deleteListing(String id) {
        try {
            getListingsCollection().document(id).delete().get();
            log.debug("[MARKETPLACE] Listing deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete listing", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete listing", e);
        }
    }

    @Override
    public List<ListingEntity> findListings(String societyId, String category, int page, int size) {
        try {
            Query query = getListingsCollection()
                    .whereEqualTo(MarketplaceConstants.FIELD_STATUS, MarketplaceConstants.STATUS_ACTIVE)
                    .orderBy(MarketplaceConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) query = query.whereEqualTo(MarketplaceConstants.FIELD_SOCIETY_ID, societyId);
            if (category != null) query = query.whereEqualTo(MarketplaceConstants.FIELD_CATEGORY, category);
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(ListingEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list listings", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list listings", e);
        }
    }

    @Override
    public long countListings(String societyId, String category) {
        try {
            Query query = getListingsCollection()
                    .whereEqualTo(MarketplaceConstants.FIELD_STATUS, MarketplaceConstants.STATUS_ACTIVE);
            if (societyId != null) query = query.whereEqualTo(MarketplaceConstants.FIELD_SOCIETY_ID, societyId);
            if (category != null) query = query.whereEqualTo(MarketplaceConstants.FIELD_CATEGORY, category);
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count listings", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count listings", e);
        }
    }

    @Override
    public InterestEntity saveInterest(InterestEntity interest) {
        try {
            DocumentReference docRef;
            if (interest.getId() != null) {
                docRef = getInterestsCollection().document(interest.getId());
            } else {
                docRef = getInterestsCollection().document();
                interest.setId(docRef.getId());
            }
            docRef.set(interest).get();
            log.debug("[MARKETPLACE] Interest saved with ID: {}", interest.getId());
            return interest;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save interest", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save interest", e);
        }
    }

    @Override
    public List<InterestEntity> findInterestsByListingId(String listingId) {
        try {
            QuerySnapshot snapshot = getInterestsCollection()
                    .whereEqualTo(MarketplaceConstants.FIELD_LISTING_ID, listingId)
                    .orderBy(MarketplaceConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(InterestEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list interests", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list interests", e);
        }
    }
}
