package com.myguard.dashboard.dto.response;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class DashboardSummaryResponse {
    long totalResidents;
    long totalGuards;
    long totalFlats;
    long openTickets;
    long activeVisitors;
    long totalVehicles;
    long activePanicAlerts;
    long totalPets;
    long activeListings;
}
