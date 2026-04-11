package com.myguard.marketplace.service;

import com.myguard.common.exception.ForbiddenException;
import com.myguard.common.exception.ResourceNotFoundException;
import com.myguard.common.response.PaginatedResponse;
import com.myguard.marketplace.constants.MarketplaceConstants;
import com.myguard.marketplace.dto.request.CreateListingRequest;
import com.myguard.marketplace.dto.request.ExpressInterestRequest;
import com.myguard.marketplace.dto.request.UpdateListingRequest;
import com.myguard.marketplace.dto.response.InterestResponse;
import com.myguard.marketplace.dto.response.ListingResponse;
import com.myguard.marketplace.repository.MarketplaceRepository;
import com.myguard.marketplace.view.InterestEntity;
import com.myguard.marketplace.view.ListingEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class MarketplaceServiceImpl implements MarketplaceService {

    private final MarketplaceRepository marketplaceRepository;

    private String getCurrentUid() {
        return SecurityContextHolder.getContext().getAuthentication().getName();
    }

    @Override
    public ListingResponse createListing(CreateListingRequest request) {
        String uid = getCurrentUid();
        log.info("[MARKETPLACE] Creating listing: {}", request.getTitle());

        ListingEntity entity = ListingEntity.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .photos(request.getPhotos())
                .category(request.getCategory())
                .price(request.getPrice())
                .condition(request.getCondition())
                .postedBy(uid)
                .flatId(request.getFlatId())
                .status(MarketplaceConstants.STATUS_ACTIVE)
                .societyId(request.getSocietyId())
                .createdAt(Instant.now())
                .build();

        ListingEntity saved = marketplaceRepository.saveListing(entity);
        log.info("[MARKETPLACE] Listing created with ID: {}", saved.getId());
        return mapToListingResponse(saved);
    }

    @Override
    public PaginatedResponse<ListingResponse> listListings(int page, int size, String societyId, String category) {
        List<ListingEntity> listings = marketplaceRepository.findListings(societyId, category, page, size);
        long total = marketplaceRepository.countListings(societyId, category);
        int totalPages = (int) Math.ceil((double) total / size);

        List<ListingResponse> content = listings.stream()
                .map(this::mapToListingResponse)
                .collect(Collectors.toList());

        return PaginatedResponse.<ListingResponse>builder()
                .content(content).page(page).size(size)
                .totalElements(total).totalPages(totalPages)
                .hasNext(page < totalPages - 1).hasPrevious(page > 0)
                .build();
    }

    @Override
    public ListingResponse getListingById(String id) {
        ListingEntity entity = marketplaceRepository.findListingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));
        return mapToListingResponse(entity);
    }

    @Override
    public ListingResponse updateListing(String id, UpdateListingRequest request) {
        String uid = getCurrentUid();
        ListingEntity entity = marketplaceRepository.findListingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        if (!entity.getPostedBy().equals(uid)) {
            throw new ForbiddenException("You can only update your own listings");
        }

        if (request.getTitle() != null) entity.setTitle(request.getTitle());
        if (request.getDescription() != null) entity.setDescription(request.getDescription());
        if (request.getPhotos() != null) entity.setPhotos(request.getPhotos());
        if (request.getCategory() != null) entity.setCategory(request.getCategory());
        if (request.getPrice() != null) entity.setPrice(request.getPrice());
        if (request.getCondition() != null) entity.setCondition(request.getCondition());

        ListingEntity updated = marketplaceRepository.updateListing(entity);
        log.info("[MARKETPLACE] Listing updated: {}", id);
        return mapToListingResponse(updated);
    }

    @Override
    public void deleteListing(String id) {
        String uid = getCurrentUid();
        ListingEntity entity = marketplaceRepository.findListingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        if (!entity.getPostedBy().equals(uid)) {
            throw new ForbiddenException("You can only delete your own listings");
        }

        marketplaceRepository.deleteListing(id);
        log.info("[MARKETPLACE] Listing deleted: {}", id);
    }

    @Override
    public InterestResponse expressInterest(String listingId, ExpressInterestRequest request) {
        String uid = getCurrentUid();
        marketplaceRepository.findListingById(listingId)
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        InterestEntity entity = InterestEntity.builder()
                .listingId(listingId)
                .interestedBy(uid)
                .message(request.getMessage())
                .createdAt(Instant.now())
                .build();

        InterestEntity saved = marketplaceRepository.saveInterest(entity);
        log.info("[MARKETPLACE] Interest expressed on listing: {}", listingId);
        return mapToInterestResponse(saved);
    }

    @Override
    public ListingResponse markAsSold(String id) {
        String uid = getCurrentUid();
        ListingEntity entity = marketplaceRepository.findListingById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Listing not found"));

        if (!entity.getPostedBy().equals(uid)) {
            throw new ForbiddenException("You can only mark your own listings as sold");
        }

        entity.setStatus(MarketplaceConstants.STATUS_SOLD);
        ListingEntity updated = marketplaceRepository.updateListing(entity);
        log.info("[MARKETPLACE] Listing marked as sold: {}", id);
        return mapToListingResponse(updated);
    }

    private ListingResponse mapToListingResponse(ListingEntity entity) {
        return ListingResponse.builder()
                .id(entity.getId()).title(entity.getTitle())
                .description(entity.getDescription()).photos(entity.getPhotos())
                .category(entity.getCategory()).price(entity.getPrice())
                .condition(entity.getCondition()).postedBy(entity.getPostedBy())
                .flatId(entity.getFlatId()).status(entity.getStatus())
                .societyId(entity.getSocietyId()).createdAt(entity.getCreatedAt())
                .build();
    }

    private InterestResponse mapToInterestResponse(InterestEntity entity) {
        return InterestResponse.builder()
                .id(entity.getId()).listingId(entity.getListingId())
                .interestedBy(entity.getInterestedBy())
                .message(entity.getMessage()).createdAt(entity.getCreatedAt())
                .build();
    }
}
