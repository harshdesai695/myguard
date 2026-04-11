package com.myguard.helpdesk.constants;

public final class HelpdeskConstants {

    private HelpdeskConstants() {
    }

    public static final String COLLECTION_TICKETS = "helpdesk_tickets";
    public static final String COLLECTION_CATEGORIES = "helpdesk_categories";
    public static final String COLLECTION_COMMENTS = "ticket_comments";

    public static final String FIELD_SOCIETY_ID = "societyId";
    public static final String FIELD_STATUS = "status";
    public static final String FIELD_CREATED_AT = "createdAt";
    public static final String FIELD_RAISED_BY = "raisedBy";
    public static final String FIELD_FLAT_ID = "flatId";
    public static final String FIELD_CATEGORY = "category";
    public static final String FIELD_PRIORITY = "priority";
    public static final String FIELD_ASSIGNED_TO = "assignedTo";
    public static final String FIELD_TICKET_ID = "ticketId";

    public static final String STATUS_OPEN = "OPEN";
    public static final String STATUS_IN_PROGRESS = "IN_PROGRESS";
    public static final String STATUS_RESOLVED = "RESOLVED";
    public static final String STATUS_CLOSED = "CLOSED";
    public static final String STATUS_ESCALATED = "ESCALATED";

    public static final String PRIORITY_LOW = "LOW";
    public static final String PRIORITY_MEDIUM = "MEDIUM";
    public static final String PRIORITY_HIGH = "HIGH";
    public static final String PRIORITY_CRITICAL = "CRITICAL";
}
