package com.myguard.marketplace.repository;

import com.myguard.marketplace.view.InterestEntity;
import com.myguard.marketplace.view.ListingEntity;

import java.util.List;
import java.util.Optional;

public interface MarketplaceRepository {

    ListingEntity saveListing(ListingEntity listing);
    Optional<ListingEntity> findListingById(String id);
    ListingEntity updateListing(ListingEntity listing);
    void deleteListing(String id);
    List<ListingEntity> findListings(String societyId, String category, int page, int size);
    long countListings(String societyId, String category);

    InterestEntity saveInterest(InterestEntity interest);
    List<InterestEntity> findInterestsByListingId(String listingId);
}
