package com.myguard.vehicle.constants;

public final class VehicleConstants {

    private VehicleConstants() {
    }

    public static final String COLLECTION_VEHICLES = "vehicles";
    public static final String COLLECTION_PARKING = "parking_slots";
    public static final String COLLECTION_VISITOR_VEHICLE_LOG = "visitor_vehicle_logs";

    public static final String FIELD_SOCIETY_ID = "societyId";
    public static final String FIELD_STATUS = "status";
    public static final String FIELD_CREATED_AT = "createdAt";
    public static final String FIELD_OWNER_UID = "ownerUid";
    public static final String FIELD_FLAT_ID = "flatId";
    public static final String FIELD_PLATE_NUMBER = "plateNumber";
    public static final String FIELD_VEHICLE_ID = "vehicleId";
    public static final String FIELD_ENTRY_TIME = "entryTime";

    public static final String TYPE_CAR = "CAR";
    public static final String TYPE_BIKE = "BIKE";
    public static final String TYPE_OTHER = "OTHER";

    public static final String PARKING_COVERED = "COVERED";
    public static final String PARKING_OPEN = "OPEN";
    public static final String PARKING_RESERVED = "RESERVED";
}
