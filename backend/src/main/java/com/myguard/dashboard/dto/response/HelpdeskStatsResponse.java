package com.myguard.dashboard.dto.response;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class HelpdeskStatsResponse {
    long openTickets;
    long inProgressTickets;
    long resolvedTickets;
    long closedTickets;
    long escalatedTickets;
    long slaBreachCount;
}
