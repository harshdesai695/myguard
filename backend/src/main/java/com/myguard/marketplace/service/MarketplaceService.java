package com.myguard.marketplace.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.marketplace.dto.request.CreateListingRequest;
import com.myguard.marketplace.dto.request.ExpressInterestRequest;
import com.myguard.marketplace.dto.request.UpdateListingRequest;
import com.myguard.marketplace.dto.response.InterestResponse;
import com.myguard.marketplace.dto.response.ListingResponse;

public interface MarketplaceService {

    ListingResponse createListing(CreateListingRequest request);
    PaginatedResponse<ListingResponse> listListings(int page, int size, String societyId, String category);
    ListingResponse getListingById(String id);
    ListingResponse updateListing(String id, UpdateListingRequest request);
    void deleteListing(String id);
    InterestResponse expressInterest(String listingId, ExpressInterestRequest request);
    ListingResponse markAsSold(String id);
}
