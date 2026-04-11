package com.myguard.emergency.constants;

public final class EmergencyConstants {

    private EmergencyConstants() {
    }

    public static final String COLLECTION_PANIC_ALERTS = "panic_alerts";
    public static final String COLLECTION_EMERGENCY_CONTACTS = "emergency_contacts";

    public static final String FIELD_SOCIETY_ID = "societyId";
    public static final String FIELD_STATUS = "status";
    public static final String FIELD_CREATED_AT = "createdAt";
    public static final String FIELD_TRIGGERED_BY = "triggeredBy";
    public static final String FIELD_FLAT_ID = "flatId";
    public static final String FIELD_TYPE = "type";

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_RESOLVED = "RESOLVED";
}
