package com.myguard.amenity.constants;

public final class AmenityConstants {

    private AmenityConstants() {
    }

    public static final String COLLECTION_AMENITIES = "amenities";
    public static final String COLLECTION_BOOKINGS = "amenity_bookings";

    public static final String FIELD_SOCIETY_ID = "societyId";
    public static final String FIELD_STATUS = "status";
    public static final String FIELD_CREATED_AT = "createdAt";
    public static final String FIELD_AMENITY_ID = "amenityId";
    public static final String FIELD_RESIDENT_UID = "residentUid";
    public static final String FIELD_SLOT_DATE = "slotDate";

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_INACTIVE = "INACTIVE";

    public static final String BOOKING_PENDING = "PENDING";
    public static final String BOOKING_CONFIRMED = "CONFIRMED";
    public static final String BOOKING_CANCELLED = "CANCELLED";
    public static final String BOOKING_CHECKED_IN = "CHECKED_IN";
    public static final String BOOKING_CHECKED_OUT = "CHECKED_OUT";
}
