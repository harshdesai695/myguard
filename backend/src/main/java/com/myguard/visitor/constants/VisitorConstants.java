package com.myguard.visitor.constants;

public final class VisitorConstants {

    private VisitorConstants() {
    }

    public static final String COLLECTION_VISITORS = "visitors";
    public static final String COLLECTION_PRE_APPROVALS = "pre_approvals";
    public static final String COLLECTION_RECURRING_INVITES = "recurring_invites";

    public static final String FIELD_RESIDENT_UID = "residentUid";
    public static final String FIELD_FLAT_ID = "flatId";
    public static final String FIELD_STATUS = "status";
    public static final String FIELD_ENTRY_TIME = "entryTime";
    public static final String FIELD_EXIT_TIME = "exitTime";
    public static final String FIELD_INVITE_CODE = "inviteCode";
    public static final String FIELD_VALID_UNTIL = "validUntil";
    public static final String FIELD_SOCIETY_ID = "societyId";
    public static final String FIELD_CREATED_AT = "createdAt";

    public static final String STATUS_PENDING = "PENDING";
    public static final String STATUS_APPROVED = "APPROVED";
    public static final String STATUS_REJECTED = "REJECTED";
    public static final String STATUS_COMPLETED = "COMPLETED";
    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_CANCELLED = "CANCELLED";
    public static final String STATUS_EXPIRED = "EXPIRED";

    public static final long DEFAULT_PRE_APPROVAL_HOURS = 24;
    public static final long DEFAULT_OVERSTAY_THRESHOLD_HOURS = 8;
}
