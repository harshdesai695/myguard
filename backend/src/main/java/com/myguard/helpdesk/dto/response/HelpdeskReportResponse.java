package com.myguard.helpdesk.dto.response;

import lombok.Builder;
import lombok.Value;

import java.util.Map;

@Value
@Builder
public class HelpdeskReportResponse {
    long totalTickets;
    long openTickets;
    long resolvedTickets;
    long escalatedTickets;
    double averageResolutionTimeHours;
    double slaAdherencePercentage;
    Map<String, Long> ticketsByCategory;
    Map<String, Long> ticketsByPriority;
}
