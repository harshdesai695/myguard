package com.myguard.dashboard.repository;

import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.dashboard.dto.response.AmenityStatsResponse;
import com.myguard.dashboard.dto.response.DashboardSummaryResponse;
import com.myguard.dashboard.dto.response.GuardPerformanceResponse;
import com.myguard.dashboard.dto.response.HelpdeskStatsResponse;
import com.myguard.dashboard.dto.response.MoveInOutResponse;
import com.myguard.dashboard.dto.response.VisitorStatsResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.concurrent.ExecutionException;

@Slf4j
@Repository
@RequiredArgsConstructor
public class DashboardRepositoryImpl implements DashboardRepository {

    private final Firestore firestore;

    @Override
    public DashboardSummaryResponse getSummary(String societyId) {
        try {
            long totalResidents = countDocuments("users", "role", "ROLE_RESIDENT", societyId);
            long totalGuards = countDocuments("users", "role", "ROLE_GUARD", societyId);
            long totalFlats = countCollectionBySociety("flats", societyId);
            long openTickets = countDocuments("helpdesk_tickets", "status", "OPEN", societyId);
            long activeVisitors = countDocuments("visitors", "status", "APPROVED", societyId);
            long totalVehicles = countCollectionBySociety("vehicles", societyId);
            long activePanicAlerts = countDocuments("panic_alerts", "status", "ACTIVE", societyId);
            long totalPets = countCollectionBySociety("pet_directory", societyId);
            long activeListings = countDocuments("marketplace_listings", "status", "ACTIVE", societyId);

            return DashboardSummaryResponse.builder()
                    .totalResidents(totalResidents).totalGuards(totalGuards)
                    .totalFlats(totalFlats).openTickets(openTickets)
                    .activeVisitors(activeVisitors).totalVehicles(totalVehicles)
                    .activePanicAlerts(activePanicAlerts).totalPets(totalPets)
                    .activeListings(activeListings)
                    .build();
        } catch (Exception e) {
            throw new FirebaseOperationException("Failed to get dashboard summary", e);
        }
    }

    @Override
    public VisitorStatsResponse getVisitorStats(String societyId, Instant from, Instant to) {
        try {
            Instant now = Instant.now();
            Instant dayAgo = now.minus(1, ChronoUnit.DAYS);
            Instant weekAgo = now.minus(7, ChronoUnit.DAYS);
            Instant monthAgo = now.minus(30, ChronoUnit.DAYS);

            long daily = countVisitorsSince(societyId, dayAgo);
            long weekly = countVisitorsSince(societyId, weekAgo);
            long monthly = countVisitorsSince(societyId, monthAgo);
            long pending = countDocuments("visitors", "status", "PENDING", societyId);
            long active = countDocuments("visitors", "status", "APPROVED", societyId);

            return VisitorStatsResponse.builder()
                    .dailyCount(daily).weeklyCount(weekly).monthlyCount(monthly)
                    .pendingApprovals(pending).activeVisitors(active)
                    .build();
        } catch (Exception e) {
            throw new FirebaseOperationException("Failed to get visitor stats", e);
        }
    }

    @Override
    public HelpdeskStatsResponse getHelpdeskStats(String societyId, Instant from, Instant to) {
        try {
            long open = countDocuments("helpdesk_tickets", "status", "OPEN", societyId);
            long inProgress = countDocuments("helpdesk_tickets", "status", "IN_PROGRESS", societyId);
            long resolved = countDocuments("helpdesk_tickets", "status", "RESOLVED", societyId);
            long closed = countDocuments("helpdesk_tickets", "status", "CLOSED", societyId);
            long escalated = countDocuments("helpdesk_tickets", "status", "ESCALATED", societyId);

            return HelpdeskStatsResponse.builder()
                    .openTickets(open).inProgressTickets(inProgress)
                    .resolvedTickets(resolved).closedTickets(closed)
                    .escalatedTickets(escalated).slaBreachCount(escalated)
                    .build();
        } catch (Exception e) {
            throw new FirebaseOperationException("Failed to get helpdesk stats", e);
        }
    }

    @Override
    public AmenityStatsResponse getAmenityStats(String societyId, Instant from, Instant to) {
        try {
            long total = countCollectionBySociety("amenity_bookings", societyId);
            long confirmed = countDocuments("amenity_bookings", "status", "CONFIRMED", societyId);
            long cancelled = countDocuments("amenity_bookings", "status", "CANCELLED", societyId);
            long checkedIn = countDocuments("amenity_bookings", "status", "CHECKED_IN", societyId);

            return AmenityStatsResponse.builder()
                    .totalBookings(total).confirmedBookings(confirmed)
                    .cancelledBookings(cancelled).checkedInCount(checkedIn)
                    .bookingsByAmenity(new HashMap<>())
                    .build();
        } catch (Exception e) {
            throw new FirebaseOperationException("Failed to get amenity stats", e);
        }
    }

    @Override
    public GuardPerformanceResponse getGuardPerformance(String societyId, Instant from, Instant to) {
        try {
            long totalPatrols = countCollectionBySociety("guard_patrols", societyId);
            return GuardPerformanceResponse.builder()
                    .totalPatrols(totalPatrols)
                    .completedPatrols(totalPatrols)
                    .missedCheckpoints(0)
                    .completionRate(totalPatrols > 0 ? 100.0 : 0.0)
                    .build();
        } catch (Exception e) {
            throw new FirebaseOperationException("Failed to get guard performance", e);
        }
    }

    @Override
    public MoveInOutResponse getMoveInOutStats(String societyId, Instant from, Instant to) {
        try {
            long occupied = countDocuments("flats", "status", "OCCUPIED", societyId);
            long vacant = countDocuments("flats", "status", "VACANT", societyId);

            return MoveInOutResponse.builder()
                    .moveInCount(0).moveOutCount(0)
                    .occupiedFlats(occupied).vacantFlats(vacant)
                    .build();
        } catch (Exception e) {
            throw new FirebaseOperationException("Failed to get move-in/out stats", e);
        }
    }

    // --- Helpers ---

    private long countDocuments(String collection, String field, String value, String societyId) throws ExecutionException, InterruptedException {
        Query query = firestore.collection(collection).whereEqualTo(field, value);
        if (societyId != null) {
            query = query.whereEqualTo("societyId", societyId);
        }
        return query.get().get().size();
    }

    private long countCollectionBySociety(String collection, String societyId) throws ExecutionException, InterruptedException {
        Query query = firestore.collection(collection);
        if (societyId != null) {
            query = query.whereEqualTo("societyId", societyId);
        }
        return query.get().get().size();
    }

    private long countVisitorsSince(String societyId, Instant since) throws ExecutionException, InterruptedException {
        Query query = firestore.collection("visitors")
                .whereGreaterThanOrEqualTo("createdAt", since);
        if (societyId != null) {
            query = query.whereEqualTo("societyId", societyId);
        }
        return query.get().get().size();
    }
}
