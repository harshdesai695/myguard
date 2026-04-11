package com.myguard.common.config;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.auth.FirebaseAuth;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import com.google.cloud.Timestamp;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Slf4j
@Component
@Profile("dev")
@RequiredArgsConstructor
public class DevDataSeeder implements CommandLineRunner {

	private final Firestore firestore;
	private final FirebaseAuth firebaseAuth;

	// ── Users ──
	private static final String ADMIN_UID = "aDiZsoTkLlVXL3djFPlWlJHVkDl1";
	private static final String ADMIN_EMAIL = "harshdesai9081322133@gmail.com";

	private static final String GUARD_UID = "9BWVkwTZGGfnmvH053rwYyKQz243";
	private static final String GUARD_EMAIL = "harsh@gmail.com";

	private static final String RESIDENT_UID = "d56YMXj3KHZyvV2AtVKXKNh3QbQ2";
	private static final String RESIDENT_EMAIL = "harsh2@gmail.com";

	// ── IDs ──
	private static final String SOCIETY_ID = "society_001";
	private static final String FLAT_A101 = "flat_a101";
	private static final String FLAT_A201 = "flat_a201";
	private static final String FLAT_B101 = "flat_b101";
	private static final String FLAT_B201 = "flat_b201";
	private static final String FLAT_C101 = "flat_c101";

	// ── All collections to clear ──
	private static final List<String> ALL_COLLECTIONS = List.of("users", "societies", "flats", "visitors",
			"pre_approvals", "recurring_invites", "daily_helps", "daily_help_attendance", "guard_checkpoints",
			"guard_patrols", "guard_shifts", "guard_intercoms", "notices", "polls", "poll_votes",
			"communication_groups", "group_messages", "documents", "amenities", "amenity_bookings", "helpdesk_tickets",
			"helpdesk_categories", "ticket_comments", "vehicles", "parking_slots", "visitor_vehicle_logs",
			"material_gatepasses", "panic_alerts", "emergency_contacts", "pet_directory", "pet_vaccinations",
			"marketplace_listings", "marketplace_interests");

	@Override
	public void run(String... args) throws Exception {
		log.info("[SEED] ============================================");
		log.info("[SEED] Clearing ALL Firestore data...");
		log.info("[SEED] ============================================");

		for (String collection : ALL_COLLECTIONS) {
			clearCollection(collection);
		}
		log.info("[SEED] All collections cleared.");

		// ── Set Firebase Auth custom claims for roles ──
		log.info("[SEED] Setting Firebase Auth custom claims...");
		firebaseAuth.setCustomUserClaims(ADMIN_UID, Map.of("role", "ROLE_ADMIN"));
		firebaseAuth.setCustomUserClaims(GUARD_UID, Map.of("role", "ROLE_GUARD"));
		firebaseAuth.setCustomUserClaims(RESIDENT_UID, Map.of("role", "ROLE_RESIDENT"));
		log.info("[SEED] Custom claims set for all 3 users.");

		// ══════════════════════════════════════════════
		// 1. SOCIETY
		// ══════════════════════════════════════════════
		putDoc("societies", SOCIETY_ID,
				mapOf("id", SOCIETY_ID, "name", "Green Valley Residency", "address", "Plot 45, Sector 12, Whitefield",
						"city", "Bangalore", "state", "Karnataka", "pincode", "560100", "totalBlocks", 4, "totalFlats",
						120, "logoUrl", "", "status", "ACTIVE", "createdAt", now(), "updatedAt", now()));

		// ══════════════════════════════════════════════
		// 2. FLATS
		// ══════════════════════════════════════════════
		putDoc("flats", FLAT_A101, flat(FLAT_A101, "A", 1, "A-101", "2BHK", RESIDENT_UID));
		putDoc("flats", FLAT_A201, flat(FLAT_A201, "A", 2, "A-201", "3BHK", ADMIN_UID));
		putDoc("flats", FLAT_B101, flat(FLAT_B101, "B", 1, "B-101", "2BHK", null));
		putDoc("flats", FLAT_B201, flat(FLAT_B201, "B", 2, "B-201", "3BHK", null));
		putDoc("flats", FLAT_C101, flat(FLAT_C101, "C", 1, "C-101", "1BHK", null));

		// ══════════════════════════════════════════════
		// 3. USERS
		// ══════════════════════════════════════════════
		putDoc("users", ADMIN_UID,
				user(ADMIN_UID, "Harsh Desai", ADMIN_EMAIL, "+919081322133", "ROLE_ADMIN", FLAT_A201, "A-201"));
		putDoc("users", GUARD_UID,
				user(GUARD_UID, "Guard Harsh", GUARD_EMAIL, "+919876543210", "ROLE_GUARD", null, null));
		putDoc("users", RESIDENT_UID, user(RESIDENT_UID, "Resident Harsh", RESIDENT_EMAIL, "+919876543211",
				"ROLE_RESIDENT", FLAT_A101, "A-101"));

		// ══════════════════════════════════════════════
		// 4. VISITORS & PRE-APPROVALS
		// ══════════════════════════════════════════════
		putDoc("visitors", "visitor_001",
				mapOf("id", "visitor_001", "visitorName", "Amit Kumar", "visitorPhone", "+919800000001", "photoUrl", "",
						"purpose", "Delivery", "flatId", FLAT_A101, "residentUid", RESIDENT_UID, "societyId",
						SOCIETY_ID, "entryTime", hoursAgo(2), "exitTime", "", "status", "APPROVED", "vehicleNumber",
						"KA-01-AB-1234", "guardUid", GUARD_UID, "preApprovalId", "", "inviteCode", "", "isGroupEntry",
						false, "groupSize", 1, "createdAt", hoursAgo(2), "updatedAt", hoursAgo(2)));
		putDoc("visitors", "visitor_002",
				mapOf("id", "visitor_002", "visitorName", "Priya Patel", "visitorPhone", "+919800000002", "photoUrl",
						"", "purpose", "Guest", "flatId", FLAT_A101, "residentUid", RESIDENT_UID, "societyId",
						SOCIETY_ID, "entryTime", hoursAgo(5), "exitTime", hoursAgo(3), "status", "COMPLETED",
						"vehicleNumber", "", "guardUid", GUARD_UID, "preApprovalId", "", "inviteCode", "",
						"isGroupEntry", false, "groupSize", 1, "createdAt", hoursAgo(5), "updatedAt", hoursAgo(3)));
		putDoc("visitors", "visitor_003",
				mapOf("id", "visitor_003", "visitorName", "Delivery Person", "visitorPhone", "+919800000003",
						"photoUrl", "", "purpose", "Parcel Delivery", "flatId", FLAT_A101, "residentUid", "",
						"societyId", SOCIETY_ID, "entryTime", "", "exitTime", "", "status", "PENDING", "vehicleNumber",
						"KA-03-CD-5678", "guardUid", GUARD_UID, "preApprovalId", "", "inviteCode", "", "isGroupEntry",
						false, "groupSize", 1, "createdAt", now(), "updatedAt", now()));

		putDoc("pre_approvals", "pa_001",
				mapOf("id", "pa_001", "visitorName", "Ravi Electrician", "visitorPhone", "+919800000010", "purpose",
						"Electrical repair", "flatId", FLAT_A101, "residentUid", RESIDENT_UID, "societyId", SOCIETY_ID,
						"inviteCode", "ELEC2026", "status", "ACTIVE", "validFrom", now(), "validUntil",
						hoursFromNow(24), "createdAt", now()));

		putDoc("recurring_invites", "ri_001",
				mapOf("id", "ri_001", "visitorName", "Ram Milkman", "visitorPhone", "+919800000020", "purpose",
						"Daily milk delivery", "flatId", FLAT_A101, "residentUid", RESIDENT_UID, "societyId",
						SOCIETY_ID, "status", "ACTIVE", "validFrom", daysAgo(30), "validUntil", daysFromNow(60),
						"createdAt", daysAgo(30)));

		// ══════════════════════════════════════════════
		// 5. DAILY HELPS
		// ══════════════════════════════════════════════
		putDoc("daily_helps", "dh_001",
				mapOf("id", "dh_001", "name", "Lakshmi", "phone", "+919800000030", "photoUrl", "", "type", "maid",
						"residentUid", RESIDENT_UID, "flatIds", List.of(FLAT_A101), "societyId", SOCIETY_ID, "schedule",
						"Mon-Sat 7:00-9:00", "createdAt", now(), "updatedAt", now()));
		putDoc("daily_helps", "dh_002",
				mapOf("id", "dh_002", "name", "Raju", "phone", "+919800000031", "photoUrl", "", "type", "cook",
						"residentUid", RESIDENT_UID, "flatIds", List.of(FLAT_A101), "societyId", SOCIETY_ID, "schedule",
						"Mon-Sun 11:00-13:00", "createdAt", now(), "updatedAt", now()));

		for (int i = 1; i <= 5; i++) {
			putDoc("daily_help_attendance", "att_" + i,
					mapOf("id", "att_" + i, "dailyHelpId", "dh_001", "guardUid", GUARD_UID, "entryTime", daysAgo(i),
							"exitTime", "", "date", "2026-04-" + String.format("%02d", 11 - i), "status", "PRESENT",
							"createdAt", daysAgo(i)));
		}

		// ══════════════════════════════════════════════
		// 6. GUARD CHECKPOINTS & PATROLS
		// ══════════════════════════════════════════════
		putDoc("guard_checkpoints", "chk_001",
				mapOf("id", "chk_001", "name", "Main Gate", "description", "Primary entry/exit", "societyId",
						SOCIETY_ID, "latitude", 12.9716, "longitude", 77.5946, "qrCode", "QR_MAIN_GATE", "createdAt",
						now()));
		putDoc("guard_checkpoints", "chk_002",
				mapOf("id", "chk_002", "name", "Block A Entrance", "description", "Block A lobby", "societyId",
						SOCIETY_ID, "latitude", 12.9720, "longitude", 77.5950, "qrCode", "QR_BLOCK_A", "createdAt",
						now()));
		putDoc("guard_checkpoints", "chk_003",
				mapOf("id", "chk_003", "name", "Parking Area", "description", "Basement parking", "societyId",
						SOCIETY_ID, "latitude", 12.9712, "longitude", 77.5942, "qrCode", "QR_PARKING", "createdAt",
						now()));

		for (int i = 1; i <= 3; i++) {
			putDoc("guard_patrols", "patrol_00" + i,
					mapOf("id", "patrol_00" + i, "guardUid", GUARD_UID, "checkpointId", "chk_00" + i, "societyId",
							SOCIETY_ID, "scannedAt", hoursAgo(i), "notes", "All clear", "createdAt", hoursAgo(i)));
		}

		putDoc("guard_shifts", "shift_001",
				mapOf("id", "shift_001", "guardUid", GUARD_UID, "societyId", SOCIETY_ID, "shiftName", "Morning",
						"startTime", "06:00", "endTime", "14:00", "date", "2026-04-11", "status", "ASSIGNED",
						"createdAt", now()));

		// ══════════════════════════════════════════════
		// 7. NOTICES
		// ══════════════════════════════════════════════
		putDoc("notices", "notice_001",
				mapOf("id", "notice_001", "title", "Water Supply Disruption", "body",
						"Water supply will be interrupted on April 15 from 10 AM to 2 PM for tank cleaning.", "type",
						"maintenance", "attachments", List.of(), "postedBy", ADMIN_UID, "societyId", SOCIETY_ID,
						"expiryDate", daysFromNow(5), "createdAt", now(), "updatedAt", now()));
		putDoc("notices", "notice_002",
				mapOf("id", "notice_002", "title", "Annual General Meeting", "body",
						"AGM will be held on April 20 at 6 PM in the clubhouse. All residents are requested to attend.",
						"type", "general", "attachments", List.of(), "postedBy", ADMIN_UID, "societyId", SOCIETY_ID,
						"expiryDate", daysFromNow(10), "createdAt", daysAgo(1), "updatedAt", daysAgo(1)));
		putDoc("notices", "notice_003",
				mapOf("id", "notice_003", "title", "Security Alert", "body",
						"Please ensure main doors are locked after 10 PM. Suspicious activity reported near Block C.",
						"type", "urgent", "attachments", List.of(), "postedBy", ADMIN_UID, "societyId", SOCIETY_ID,
						"expiryDate", daysFromNow(3), "createdAt", hoursAgo(6), "updatedAt", hoursAgo(6)));

		// ══════════════════════════════════════════════
		// 8. POLLS
		// ══════════════════════════════════════════════
		putDoc("polls", "poll_001",
				mapOf("id", "poll_001", "question", "Should we install EV charging stations in the parking area?",
						"options", List.of("Yes", "No", "Need more info"), "startDate", daysAgo(2), "endDate",
						daysFromNow(5), "isSecret", false, "allowMultipleVotes", false, "postedBy", ADMIN_UID,
						"societyId", SOCIETY_ID, "createdAt", daysAgo(2)));
		putDoc("poll_votes", "vote_001", mapOf("id", "vote_001", "pollId", "poll_001", "voterUid", RESIDENT_UID,
				"selectedOption", "Yes", "createdAt", daysAgo(1)));

		// ══════════════════════════════════════════════
		// 9. COMMUNICATION GROUPS & MESSAGES
		// ══════════════════════════════════════════════
		putDoc("communication_groups", "grp_001",
				mapOf("id", "grp_001", "name", "Block A Residents", "description", "Communication group for Block A",
						"type", "tower", "createdBy", ADMIN_UID, "societyId", SOCIETY_ID, "createdAt", daysAgo(10)));
		putDoc("group_messages", "msg_001", mapOf("id", "msg_001", "groupId", "grp_001", "senderUid", ADMIN_UID,
				"content", "Welcome to the Block A group!", "createdAt", daysAgo(10)));
		putDoc("group_messages", "msg_002", mapOf("id", "msg_002", "groupId", "grp_001", "senderUid", RESIDENT_UID,
				"content", "Thanks! Looking forward to connecting with everyone.", "createdAt", daysAgo(9)));

		// ══════════════════════════════════════════════
		// 10. DOCUMENTS
		// ══════════════════════════════════════════════
		putDoc("documents", "doc_001",
				mapOf("id", "doc_001", "title", "Society Bylaws 2026", "description",
						"Updated society bylaws and regulations", "fileUrl", "https://example.com/docs/bylaws2026.pdf",
						"type", "bylaws", "uploadedBy", ADMIN_UID, "societyId", SOCIETY_ID, "createdAt", daysAgo(30)));

		// ══════════════════════════════════════════════
		// 11. AMENITIES & BOOKINGS
		// ══════════════════════════════════════════════
		putDoc("amenities", "amenity_pool",
				mapOf("id", "amenity_pool", "name", "Swimming Pool", "type", "pool", "capacity", 30, "pricing", 200.0,
						"operatingHours", "06:00-20:00", "coolDownMinutes", 30, "maintenanceClosureDates", List.of(),
						"societyId", SOCIETY_ID, "status", "ACTIVE", "createdAt", now(), "updatedAt", now()));
		putDoc("amenities", "amenity_gym",
				mapOf("id", "amenity_gym", "name", "Fitness Center", "type", "gym", "capacity", 20, "pricing", 0.0,
						"operatingHours", "05:00-22:00", "coolDownMinutes", 15, "maintenanceClosureDates", List.of(),
						"societyId", SOCIETY_ID, "status", "ACTIVE", "createdAt", now(), "updatedAt", now()));
		putDoc("amenities", "amenity_clubhouse",
				mapOf("id", "amenity_clubhouse", "name", "Clubhouse", "type", "clubhouse", "capacity", 50, "pricing",
						500.0, "operatingHours", "08:00-22:00", "coolDownMinutes", 60, "maintenanceClosureDates",
						List.of(), "societyId", SOCIETY_ID, "status", "ACTIVE", "createdAt", now(), "updatedAt",
						now()));
		putDoc("amenity_bookings", "booking_001",
				mapOf("id", "booking_001", "amenityId", "amenity_pool", "residentUid", RESIDENT_UID, "flatId",
						FLAT_A101, "slotDate", "2026-04-12", "slotStartTime", "10:00", "slotEndTime", "11:00",
						"companions", 2, "status", "CONFIRMED", "societyId", SOCIETY_ID, "createdAt", now(),
						"updatedAt", now()));

		// ══════════════════════════════════════════════
		// 12. HELPDESK
		// ══════════════════════════════════════════════
		for (String[] cat : new String[][] { { "cat_plumbing", "Plumbing", "Water and plumbing issues" },
				{ "cat_electrical", "Electrical", "Electrical and wiring issues" },
				{ "cat_cleaning", "Cleaning", "Common area cleaning" },
				{ "cat_security", "Security", "Security related concerns" },
				{ "cat_other", "Other", "General complaints" } }) {
			putDoc("helpdesk_categories", cat[0], mapOf("id", cat[0], "name", cat[1], "description", cat[2],
					"societyId", SOCIETY_ID, "createdAt", now()));
		}

		putDoc("helpdesk_tickets", "ticket_001",
				mapOf("id", "ticket_001", "title", "Leaking pipe in bathroom", "description",
						"Water leak from the pipe in master bathroom, causing water damage to the wall.", "category",
						"Plumbing", "subCategory", "", "attachments", List.of(), "flatId", FLAT_A101, "raisedBy",
						RESIDENT_UID, "status", "OPEN", "priority", "HIGH", "assignedTo", "", "slaDeadline",
						daysFromNow(2), "rating", 0, "ratingComment", "", "societyId", SOCIETY_ID, "createdAt",
						daysAgo(1), "updatedAt", daysAgo(1)));
		putDoc("helpdesk_tickets", "ticket_002",
				mapOf("id", "ticket_002", "title", "Streetlight not working near Block B", "description",
						"The streetlight near Block B entrance has been off for 3 days.", "category", "Electrical",
						"subCategory", "", "attachments", List.of(), "flatId", FLAT_A101, "raisedBy", RESIDENT_UID,
						"status", "IN_PROGRESS", "priority", "MEDIUM", "assignedTo", ADMIN_UID, "slaDeadline",
						daysFromNow(3), "rating", 0, "ratingComment", "", "societyId", SOCIETY_ID, "createdAt",
						daysAgo(3), "updatedAt", daysAgo(1)));
		putDoc("helpdesk_tickets", "ticket_003", mapOf("id", "ticket_003", "title", "Gym treadmill broken",
				"description", "The treadmill #2 in gym has stopped working.", "category", "Other", "subCategory", "",
				"attachments", List.of(), "flatId", FLAT_A101, "raisedBy", RESIDENT_UID, "status", "RESOLVED",
				"priority", "LOW", "assignedTo", ADMIN_UID, "slaDeadline", daysAgo(1), "rating", 4, "ratingComment",
				"Fixed quickly, thanks!", "societyId", SOCIETY_ID, "createdAt", daysAgo(7), "updatedAt", daysAgo(2)));
		putDoc("ticket_comments", "comment_001", mapOf("id", "comment_001", "ticketId", "ticket_002", "authorUid",
				ADMIN_UID, "content", "Electrician has been notified. Will fix by tomorrow.", "createdAt", daysAgo(1)));

		// ══════════════════════════════════════════════
		// 13. VEHICLES & PARKING
		// ══════════════════════════════════════════════
		putDoc("vehicles", "veh_001",
				mapOf("id", "veh_001", "plateNumber", "KA-01-AB-1234", "make", "Hyundai", "model", "Creta", "colour",
						"White", "type", "car", "ownerUid", RESIDENT_UID, "flatId", FLAT_A101, "societyId", SOCIETY_ID,
						"createdAt", now(), "updatedAt", now()));
		putDoc("vehicles", "veh_002",
				mapOf("id", "veh_002", "plateNumber", "KA-01-CD-5678", "make", "Honda", "model", "Activa", "colour",
						"Black", "type", "bike", "ownerUid", RESIDENT_UID, "flatId", FLAT_A101, "societyId", SOCIETY_ID,
						"createdAt", now(), "updatedAt", now()));
		putDoc("parking_slots", "park_001", mapOf("id", "park_001", "slotNumber", "A-P12", "zone", "Block A Basement",
				"type", "covered", "vehicleId", "veh_001", "societyId", SOCIETY_ID, "createdAt", now()));

		// ══════════════════════════════════════════════
		// 14. MATERIAL GATEPASSES
		// ══════════════════════════════════════════════
		putDoc("material_gatepasses", "gp_001",
				mapOf("id", "gp_001", "type", "OUTWARD", "description", "Old sofa set for disposal", "items",
						List.of("3-seater sofa", "2 cushions"), "vehicleNumber", "KA-01-XY-9999", "expectedDate",
						"2026-04-13", "requestedBy", RESIDENT_UID, "flatId", FLAT_A101, "status", "PENDING",
						"approvedBy", "", "verifiedBy", "", "verifiedAt", "", "societyId", SOCIETY_ID, "createdAt",
						now()));
		putDoc("material_gatepasses", "gp_002",
				mapOf("id", "gp_002", "type", "INWARD", "description", "New washing machine delivery", "items",
						List.of("Samsung washing machine", "Installation kit"), "vehicleNumber", "", "expectedDate",
						"2026-04-12", "requestedBy", RESIDENT_UID, "flatId", FLAT_A101, "status", "APPROVED",
						"approvedBy", ADMIN_UID, "verifiedBy", "", "verifiedAt", "", "societyId", SOCIETY_ID,
						"createdAt", daysAgo(1)));

		// ══════════════════════════════════════════════
		// 15. EMERGENCY CONTACTS
		// ══════════════════════════════════════════════
		putDoc("emergency_contacts", "ec_police", mapOf("id", "ec_police", "name", "Bangalore Police", "phone", "100",
				"type", "police", "address", "Whitefield Station", "societyId", SOCIETY_ID, "createdAt", now()));
		putDoc("emergency_contacts", "ec_fire", mapOf("id", "ec_fire", "name", "Fire Department", "phone", "101",
				"type", "fire", "address", "Whitefield Fire Station", "societyId", SOCIETY_ID, "createdAt", now()));
		putDoc("emergency_contacts", "ec_ambulance", mapOf("id", "ec_ambulance", "name", "Ambulance", "phone", "108",
				"type", "ambulance", "address", "Manipal Hospital", "societyId", SOCIETY_ID, "createdAt", now()));
		putDoc("emergency_contacts", "ec_hospital",
				mapOf("id", "ec_hospital", "name", "Manipal Hospital", "phone", "080-25021111", "type", "hospital",
						"address", "Old Airport Road, Bangalore", "societyId", SOCIETY_ID, "createdAt", now()));

		// ══════════════════════════════════════════════
		// 16. PETS
		// ══════════════════════════════════════════════
		putDoc("pet_directory", "pet_001",
				mapOf("id", "pet_001", "name", "Bruno", "breed", "Golden Retriever", "type", "dog", "age", 3,
						"photoUrl", "", "ownerUid", RESIDENT_UID, "flatId", FLAT_A101, "vaccinationStatus",
						"up-to-date", "societyId", SOCIETY_ID, "createdAt", now(), "updatedAt", now()));
		putDoc("pet_vaccinations", "vacc_001",
				mapOf("id", "vacc_001", "petId", "pet_001", "vaccineName", "Rabies", "dateAdministered", "2026-03-01",
						"nextDueDate", "2027-03-01", "vetName", "Dr. Rao", "certificateUrl", "", "createdAt",
						daysAgo(40)));

		// ══════════════════════════════════════════════
		// 17. MARKETPLACE
		// ══════════════════════════════════════════════
		putDoc("marketplace_listings", "listing_001",
				mapOf("id", "listing_001", "title", "Study Table - Wooden", "description",
						"Solid wood study table in excellent condition. 4ft x 2ft.", "photos", List.of(), "category",
						"furniture", "price", 3500.0, "condition", "like-new", "postedBy", RESIDENT_UID, "flatId",
						FLAT_A101, "status", "ACTIVE", "societyId", SOCIETY_ID, "createdAt", daysAgo(2), "updatedAt",
						daysAgo(2)));
		putDoc("marketplace_listings", "listing_002",
				mapOf("id", "listing_002", "title", "Kids Bicycle", "description",
						"Hercules kids bicycle for 5-8 year olds. Barely used.", "photos", List.of(), "category",
						"sports", "price", 0.0, "condition", "good", "postedBy", RESIDENT_UID, "flatId", FLAT_A101,
						"status", "ACTIVE", "societyId", SOCIETY_ID, "createdAt", daysAgo(5), "updatedAt", daysAgo(5)));

		// ══════════════════════════════════════════════
		log.info("[SEED] ============================================");
		log.info("[SEED] ALL SEED DATA CREATED SUCCESSFULLY!");
		log.info("[SEED] ============================================");
		log.info("[SEED] Society: {} (Green Valley Residency)", SOCIETY_ID);
		log.info("[SEED] Admin:    {} -> {} (ROLE_ADMIN)", ADMIN_EMAIL, ADMIN_UID);
		log.info("[SEED] Guard:    {} -> {} (ROLE_GUARD)", GUARD_EMAIL, GUARD_UID);
		log.info("[SEED] Resident: {} -> {} (ROLE_RESIDENT)", RESIDENT_EMAIL, RESIDENT_UID);
		log.info("[SEED] Flats: A-101(resident), A-201(admin), B-101, B-201, C-101");
		log.info("[SEED] ============================================");
		log.info("[SEED] >>> IMPORTANT: Users must LOGOUT and LOGIN  <<<");
		log.info("[SEED] >>> again for role claims to take effect!   <<<");
		log.info("[SEED] ============================================");
	}

	// ── Helpers ──

	private void putDoc(String collection, String docId, Map<String, Object> data) throws Exception {
		firestore.collection(collection).document(docId).set(data).get();
		log.debug("[SEED] {} -> {}", collection, docId);
	}

	private void clearCollection(String collectionName) throws Exception {
		CollectionReference collection = firestore.collection(collectionName);
		ApiFuture<QuerySnapshot> future = collection.get();
		List<QueryDocumentSnapshot> docs = future.get().getDocuments();
		if (docs.isEmpty())
			return;
		for (QueryDocumentSnapshot doc : docs) {
			doc.getReference().delete().get();
		}
		log.info("[SEED] Cleared {} ({} docs)", collectionName, docs.size());
	}

	private Map<String, Object> user(String uid, String name, String email, String phone, String role, String flatId,
			String flatNumber) {
		Map<String, Object> u = new HashMap<>();
		u.put("uid", uid);
		u.put("name", name);
		u.put("email", email);
		u.put("phone", phone);
		u.put("role", role);
		u.put("status", "ACTIVE");
		u.put("societyId", SOCIETY_ID);
		u.put("flatId", flatId != null ? flatId : "");
		u.put("flatNumber", flatNumber != null ? flatNumber : "");
		u.put("profilePhotoUrl", "");
		u.put("createdAt", now());
		u.put("updatedAt", now());
		return u;
	}

	private Map<String, Object> flat(String id, String block, int floor, String flatNumber, String type,
			String residentUid) {
		Map<String, Object> f = new HashMap<>();
		f.put("id", id);
		f.put("societyId", SOCIETY_ID);
		f.put("block", block);
		f.put("floor", floor);
		f.put("flatNumber", flatNumber);
		f.put("type", type);
		f.put("status", residentUid != null ? "OCCUPIED" : "VACANT");
		f.put("primaryResidentUid", residentUid != null ? residentUid : "");
		f.put("createdAt", now());
		f.put("updatedAt", now());
		return f;
	}

	/**
	 * Utility to create a mutable HashMap from varargs key-value pairs. Supports
	 * null values unlike Map.of().
	 */
	private Map<String, Object> mapOf(Object... keyValues) {
		Map<String, Object> map = new HashMap<>();
		for (int i = 0; i < keyValues.length; i += 2) {
			map.put((String) keyValues[i], keyValues[i + 1]);
		}
		return map;
	}

	private Timestamp now() {
		return Timestamp.now();
	}

	private Timestamp hoursAgo(int h) {
		return Timestamp.ofTimeSecondsAndNanos(Instant.now().minus(h, ChronoUnit.HOURS).getEpochSecond(), 0);
	}

	private Timestamp hoursFromNow(int h) {
		return Timestamp.ofTimeSecondsAndNanos(Instant.now().plus(h, ChronoUnit.HOURS).getEpochSecond(), 0);
	}

	private Timestamp daysAgo(int d) {
		return Timestamp.ofTimeSecondsAndNanos(Instant.now().minus(d, ChronoUnit.DAYS).getEpochSecond(), 0);
	}

	private Timestamp daysFromNow(int d) {
		return Timestamp.ofTimeSecondsAndNanos(Instant.now().plus(d, ChronoUnit.DAYS).getEpochSecond(), 0);
	}
}
