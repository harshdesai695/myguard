package com.myguard.dashboard.dto.response;

import lombok.Builder;
import lombok.Value;

import java.util.Map;

@Value
@Builder
public class AmenityStatsResponse {
    long totalBookings;
    long confirmedBookings;
    long cancelledBookings;
    long checkedInCount;
    Map<String, Long> bookingsByAmenity;
}
