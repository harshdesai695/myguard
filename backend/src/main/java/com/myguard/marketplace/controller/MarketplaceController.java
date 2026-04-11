package com.myguard.marketplace.controller;

import com.myguard.common.response.ApiResponse;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.marketplace.dto.request.CreateListingRequest;
import com.myguard.marketplace.dto.request.ExpressInterestRequest;
import com.myguard.marketplace.dto.request.UpdateListingRequest;
import com.myguard.marketplace.dto.response.InterestResponse;
import com.myguard.marketplace.dto.response.ListingResponse;
import com.myguard.marketplace.service.MarketplaceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/v1/marketplace")
@RequiredArgsConstructor
public class MarketplaceController {

    private final MarketplaceService marketplaceService;

    @PostMapping("/listings")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<ListingResponse>> createListing(
            @Valid @RequestBody CreateListingRequest request) {
        ListingResponse response = marketplaceService.createListing(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Listing created"));
    }

    @GetMapping("/listings")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<PaginatedResponse<ListingResponse>>> listListings(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String societyId,
            @RequestParam(required = false) String category) {
        PaginatedResponse<ListingResponse> response = marketplaceService.listListings(page, size, societyId, category);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @GetMapping("/listings/{id}")
    @PreAuthorize("hasAnyRole('RESIDENT', 'GUARD', 'ADMIN')")
    public ResponseEntity<ApiResponse<ListingResponse>> getListing(@PathVariable String id) {
        ListingResponse response = marketplaceService.getListingById(id);
        return ResponseEntity.ok(ApiResponse.success(response));
    }

    @PutMapping("/listings/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<ListingResponse>> updateListing(
            @PathVariable String id,
            @Valid @RequestBody UpdateListingRequest request) {
        ListingResponse response = marketplaceService.updateListing(id, request);
        return ResponseEntity.ok(ApiResponse.success(response, "Listing updated"));
    }

    @DeleteMapping("/listings/{id}")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<Void>> deleteListing(@PathVariable String id) {
        marketplaceService.deleteListing(id);
        return ResponseEntity.ok(ApiResponse.success(null, "Listing deleted"));
    }

    @PostMapping("/listings/{id}/interest")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<InterestResponse>> expressInterest(
            @PathVariable String id,
            @Valid @RequestBody ExpressInterestRequest request) {
        InterestResponse response = marketplaceService.expressInterest(id, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(ApiResponse.success(response, "Interest expressed"));
    }

    @PatchMapping("/listings/{id}/mark-sold")
    @PreAuthorize("hasRole('RESIDENT')")
    public ResponseEntity<ApiResponse<ListingResponse>> markAsSold(@PathVariable String id) {
        ListingResponse response = marketplaceService.markAsSold(id);
        return ResponseEntity.ok(ApiResponse.success(response, "Listing marked as sold"));
    }
}
