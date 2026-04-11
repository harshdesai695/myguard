package com.myguard.communication.constants;

public final class CommunicationConstants {

    private CommunicationConstants() {
    }

    public static final String COLLECTION_NOTICES = "notices";
    public static final String COLLECTION_POLLS = "polls";
    public static final String COLLECTION_POLL_VOTES = "poll_votes";
    public static final String COLLECTION_GROUPS = "communication_groups";
    public static final String COLLECTION_MESSAGES = "group_messages";
    public static final String COLLECTION_DOCUMENTS = "documents";

    public static final String FIELD_SOCIETY_ID = "societyId";
    public static final String FIELD_STATUS = "status";
    public static final String FIELD_CREATED_AT = "createdAt";
    public static final String FIELD_GROUP_ID = "groupId";
    public static final String FIELD_POLL_ID = "pollId";
    public static final String FIELD_VOTER_UID = "voterUid";
    public static final String FIELD_POSTED_BY = "postedBy";
    public static final String FIELD_TYPE = "type";
    public static final String FIELD_EXPIRY_DATE = "expiryDate";

    public static final String STATUS_ACTIVE = "ACTIVE";
    public static final String STATUS_EXPIRED = "EXPIRED";
    public static final String STATUS_CLOSED = "CLOSED";

    public static final String NOTICE_TYPE_GENERAL = "GENERAL";
    public static final String NOTICE_TYPE_URGENT = "URGENT";
    public static final String NOTICE_TYPE_MAINTENANCE = "MAINTENANCE";
}
