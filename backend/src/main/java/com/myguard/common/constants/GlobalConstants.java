package com.myguard.common.constants;

public final class GlobalConstants {

    private GlobalConstants() {
    }

    // Roles
    public static final String ROLE_RESIDENT = "ROLE_RESIDENT";
    public static final String ROLE_GUARD = "ROLE_GUARD";
    public static final String ROLE_ADMIN = "ROLE_ADMIN";

    // Pagination defaults
    public static final int DEFAULT_PAGE = 0;
    public static final int DEFAULT_PAGE_SIZE = 20;
    public static final int MAX_PAGE_SIZE = 100;

    // API version prefix
    public static final String API_V1 = "/api/v1";

    // Status
    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_INACTIVE = "INACTIVE";

    // Timestamp fields
    public static final String FIELD_CREATED_AT = "createdAt";
    public static final String FIELD_UPDATED_AT = "updatedAt";
}
