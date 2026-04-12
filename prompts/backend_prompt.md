# MyGuard — Backend Prompt

> **You are an expert Senior Java / Spring Boot engineer** with 10+ years of production experience building enterprise-grade monolithic applications. You specialise in Spring Boot, Firebase (Authentication + Firestore), REST API design, and secure multi-role SaaS platforms. You write clean, maintainable, production-ready code that strictly follows an architectural ruleset provided to you.

---

## 🎯 Objective

Build the **complete backend** for **MyGuard** — a gated-community management platform (similar to MyGate). The backend is a **single Spring Boot monolith** that exposes a RESTful API consumed by a Flutter mobile application. Firebase is used as **both the database (Firestore)** and the **authentication provider (Firebase Auth)**.

---

## 📂 Project Location & Initialisation

| Item | Value |
|---|---|
| **Output folder** | `backend/` (relative to workspace root) |
| **Build tool** | Maven (`pom.xml`) |
| **Java version** | 17+ |
| **Spring Boot version** | 3.x (latest stable) |
| **Base package** | `com.myguard` |
| **Main class** | `com.myguard.MyGuardApplication` |

Generate the project with the following Spring Boot starters / dependencies at minimum:

- `spring-boot-starter-web`
- `spring-boot-starter-security`
- `spring-boot-starter-validation`
- `firebase-admin` (Google Firebase Admin SDK)
- `lombok`
- `spring-boot-starter-test`
- `springdoc-openapi` (for Swagger / OpenAPI docs)
- Any other dependency required by backend_rules.md

---

## 📜 Mandatory Rules — `backend_rules.md`

**You MUST read and internalise every rule defined in `backend_rules.md` before writing a single line of code.** That file is the absolute authority on:

1. **Project structure** — feature-based packages under `com.myguard.<feature>`, shared code in `com.myguard.common`.
2. **Naming conventions** — class names, package names, constants, DTOs.
3. **Layered architecture** — `Controller → Service (Interface) → ServiceImpl → Repository (Interface) → RepositoryImpl → Firebase`. No layer may skip another.
4. **Controller rules** — `@RestController`, `ResponseEntity<ApiResponse<T>>`, no business logic, no try-catch, `@Valid` on request bodies.
5. **Service rules** — interface + implementation, `@Service`, all business logic here, authenticated user via `SecurityContextHolder`.
6. **Repository rules** — interface + implementation, `@Repository`, all Firestore SDK calls exclusively here, async `ApiFuture`, pagination on all list queries.
7. **Entity & DTO rules** — entities in `view/` package with Lombok annotations, request DTOs with Bean Validation, response DTOs immutable, entities never leave the service layer.
8. **Firebase rules** — token verification only in `OncePerRequestFilter`, `Firestore` bean in config, collection constants, no full-collection scans.
9. **Security rules** — `@PreAuthorize` for RBAC, Firebase token filter, explicit public routes, no hardcoded credentials, no wildcard CORS.
10. **Error handling** — `MyGuardException` hierarchy, single `@ControllerAdvice` `GlobalExceptionHandler`, standard `ErrorResponse` DTO, no stack traces in responses.
11. **API design** — `/api/v1/<feature>/<resource>`, `ApiResponse<T>` wrapper, mandatory pagination, nouns not verbs, idempotent PUT/PATCH.
12. **Logging** — `@Slf4j`, contextual log messages (`[FEATURE]`), request/response logging filter, no `System.out.println`, no sensitive data in logs.
13. **Configuration** — `application.yml` + profile-specific files (`dev`, `staging`, `prod`), secrets via env vars, `@ConfigurationProperties` for complex configs.
14. **Code quality** — as specified.

**If any instruction in this prompt conflicts with `backend_rules.md`, the rules file wins.**

---

## 👥 Roles & Permissions

The platform has exactly **three roles**. Every endpoint must be gated to one or more of these roles via `@PreAuthorize`.

| Role | Enum Value | Description |
|---|---|---|
| **Resident** | `ROLE_RESIDENT` | Flat owners / tenants living in the community |
| **Security Guard** | `ROLE_GUARD` | Security personnel stationed at community gates |
| **Admin** | `ROLE_ADMIN` | Society management committee / administrators |

### Role Hierarchy

```
ADMIN > GUARD > RESIDENT   (Admins inherit all lower-role permissions)
```

### Auth Flow

1. User signs up / logs in via **Firebase Authentication** on the Flutter app (email+password, phone OTP, or Google Sign-In).
2. Flutter app sends the **Firebase ID Token** in the `Authorization: Bearer <token>` header with every API request.
3. The Spring Boot `FirebaseTokenFilter` (a `OncePerRequestFilter`):
   a. Extracts and verifies the token using **Firebase Admin SDK**.
   b. Retrieves the user's role from Firestore (or from custom claims if set).
   c. Sets an `Authentication` object in `SecurityContextHolder` with the user's UID, role, and authorities.
4. `@PreAuthorize("hasRole('ROLE_ADMIN')")` (or similar) on controller methods controls access.
5. Services retrieve the current user's UID from `SecurityContextHolder` — **never** passed as a controller parameter.

---

## 🔥 Firebase Configuration

### Firestore Collections (Top-Level Design)

Design Firestore collections following these principles:
- Each feature's entities map to their own top-level collection (or sub-collection where a parent-child relationship exists).
- Collection names are defined as constants in `<Feature>Constants.java`.
- Every document ID strategy must be documented (auto-generated vs. UID-based vs. composite).
- All queries must use indexed fields — no full-collection scans.

#### Suggested Core Collections

| Collection | Document ID | Purpose |
|---|---|---|
| `users` | Firebase UID | User profiles (all roles) |
| `societies` | Auto-generated | Society/community master data |
| `flats` | Auto-generated | Flat/unit records within a society |
| `visitors` | Auto-generated | Visitor entry logs |
| `pre_approvals` | Auto-generated | Pre-approved visitor passes |
| `daily_helps` | Auto-generated | Domestic worker profiles & attendance |
| `guard_patrols` | Auto-generated | Guard patrol checkpoints & logs |
| `notices` | Auto-generated | Community notice board posts |
| `polls` | Auto-generated | Opinion polls / surveys |
| `amenities` | Auto-generated | Amenity master list |
| `amenity_bookings` | Auto-generated | Booking records |
| `helpdesk_tickets` | Auto-generated | Service request / complaint tickets |
| `vehicles` | Auto-generated | Registered resident vehicles |
| `material_gatepasses` | Auto-generated | Material in/out passes |
| `emergency_contacts` | Auto-generated | Emergency contact directory |
| `pet_directory` | Auto-generated | Pet profiles |
| `marketplace_listings` | Auto-generated | Buy/sell classifieds |
| `communications` | Auto-generated | Group messages, emails, SMS campaigns |
| `documents` | Auto-generated | Society / personal documents |

> Adjust, add, or restructure collections as needed per feature requirements — but **document every collection path** in the entity class Javadoc as mandated by `backend_rules.md`.

### Firebase Auth Custom Claims (Optional Enhancement)

If using custom claims for roles:
```json
{ "role": "ROLE_ADMIN" }
```
Set via Firebase Admin SDK during user registration or role change.

---

## ✅ Features to Implement

**All features listed in `features.md` must be implemented.** Below is the feature-by-feature breakdown with backend-specific guidance. For each feature, you must produce:

1. **Entity classes** (in `view/` package) with Firestore collection path documented.
2. **Request & Response DTOs** (in `dto/request/` and `dto/response/`).
3. **Repository interface + implementation** (Firestore operations).
4. **Service interface + implementation** (business logic, validation, RBAC).
5. **Controller** (REST endpoints following API design rules).
6. **Constants class** (collection names, status enums, etc.).

---

### Feature 1 — Authentication & User Management (`auth`)

**Package:** `com.myguard.auth`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/auth/register` | POST | Public | Register new user (creates Firestore user doc + sets role) |
| `/api/v1/auth/profile` | GET | All Roles | Get current user profile |
| `/api/v1/auth/profile` | PUT | All Roles | Update own profile |
| `/api/v1/auth/users` | GET | ADMIN | List all users (paginated, filterable by role) |
| `/api/v1/auth/users/{uid}` | GET | ADMIN | Get any user's profile |
| `/api/v1/auth/users/{uid}/role` | PATCH | ADMIN | Change a user's role |
| `/api/v1/auth/users/{uid}/status` | PATCH | ADMIN | Activate / deactivate a user |

**Business Rules:**
- Registration requires: name, email, phone, flat number, society ID, role (default `ROLE_RESIDENT`).
- Only Admins can assign `ROLE_GUARD` or `ROLE_ADMIN`.
- Deactivated users should be rejected at the filter level.

---

### Feature 2 — Society & Flat Management (`society`)

**Package:** `com.myguard.society`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/societies` | POST | ADMIN | Create a new society |
| `/api/v1/societies` | GET | All Roles | List societies (paginated) |
| `/api/v1/societies/{id}` | GET | All Roles | Get society details |
| `/api/v1/societies/{id}` | PUT | ADMIN | Update society details |
| `/api/v1/societies/{id}/flats` | POST | ADMIN | Add flat(s) to society |
| `/api/v1/societies/{id}/flats` | GET | All Roles | List flats in society (paginated) |
| `/api/v1/societies/{id}/flats/{flatId}` | GET | All Roles | Get flat details |
| `/api/v1/societies/{id}/flats/{flatId}` | PUT | ADMIN | Update flat details |
| `/api/v1/societies/{id}/flats/{flatId}/residents` | GET | ADMIN, GUARD | List residents in a flat |

**Business Rules:**
- A society has: name, address, city, state, pincode, total blocks/towers, total flats count, logo, status.
- A flat belongs to a society and has: block/tower, floor, flat number, type (1BHK/2BHK/3BHK etc.), status (occupied/vacant), primary resident UID.
- Digital move-in / move-out: changing flat status and resident assignment.

---

### Feature 3 — Gate & Visitor Management (`visitor`)

**Package:** `com.myguard.visitor`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/visitors/pre-approve` | POST | RESIDENT | Pre-approve an expected visitor |
| `/api/v1/visitors/pre-approvals` | GET | RESIDENT | List my pre-approvals (paginated) |
| `/api/v1/visitors/pre-approvals/{id}` | DELETE | RESIDENT | Cancel a pre-approval |
| `/api/v1/visitors/entry` | POST | GUARD | Log a visitor entry (with photo URL) |
| `/api/v1/visitors/entry/{id}/approve` | PATCH | RESIDENT | Approve a spot-entry visitor |
| `/api/v1/visitors/entry/{id}/reject` | PATCH | RESIDENT | Reject a spot-entry visitor |
| `/api/v1/visitors/entry/{id}/exit` | PATCH | GUARD | Log visitor exit |
| `/api/v1/visitors` | GET | ADMIN, GUARD | List visitor logs (paginated, filterable by date, flat, status) |
| `/api/v1/visitors/{id}` | GET | All Roles | Get visitor entry detail |
| `/api/v1/visitors/recurring` | POST | RESIDENT | Create recurring invite |
| `/api/v1/visitors/recurring` | GET | RESIDENT | List my recurring invites |
| `/api/v1/visitors/recurring/{id}` | DELETE | RESIDENT | Revoke recurring invite |
| `/api/v1/visitors/guest-invite` | POST | RESIDENT | Generate guest invitation with QR/code |
| `/api/v1/visitors/verify/{code}` | GET | GUARD | Verify a guest invite code |
| `/api/v1/visitors/overstay` | GET | ADMIN, RESIDENT | List overstaying visitors |
| `/api/v1/visitors/group-entry` | POST | GUARD | Log group visitor entry |

**Business Rules:**
- Pre-approval generates a unique code valid for a configurable time window.
- Guest invitation generates a QR code / short code shareable via link.
- Recurring invites have: visitor name, phone, purpose, validity period.
- Visitor entry records: visitor name, phone, photo URL, purpose, flat/resident visited, entry time, exit time, status (pending/approved/rejected/completed), vehicle number (optional).
- Overstay alert: if a visitor hasn't exited within a configurable threshold, flag it.
- Group entry: log multiple visitors at once for event scenarios.

---

### Feature 4 — Daily Help Management (`dailyhelp`)

**Package:** `com.myguard.dailyhelp`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/daily-helps` | POST | RESIDENT | Register a daily help worker |
| `/api/v1/daily-helps` | GET | RESIDENT | List my daily help workers |
| `/api/v1/daily-helps/{id}` | GET | RESIDENT | Get daily help details |
| `/api/v1/daily-helps/{id}` | PUT | RESIDENT | Update daily help details |
| `/api/v1/daily-helps/{id}` | DELETE | RESIDENT | Remove daily help |
| `/api/v1/daily-helps/{id}/attendance` | POST | GUARD | Mark entry (attendance) |
| `/api/v1/daily-helps/{id}/attendance` | GET | RESIDENT | Get attendance history (paginated) |
| `/api/v1/daily-helps/{id}/attendance/summary` | GET | RESIDENT | Monthly attendance summary |

**Business Rules:**
- Daily help profile: name, phone, photo, type (maid/cook/driver/nanny/etc.), assigned flat(s), schedule (days & time).
- Guard marks entry/exit; resident can view attendance calendar.
- Monthly summary: total days present, absent, late arrivals.

---

### Feature 5 — Guard Management & Patrolling (`guard`)

**Package:** `com.myguard.guard`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/guards/patrols/checkpoints` | POST | ADMIN | Create patrol checkpoint |
| `/api/v1/guards/patrols/checkpoints` | GET | ADMIN, GUARD | List checkpoints |
| `/api/v1/guards/patrols` | POST | GUARD | Log patrol checkpoint scan |
| `/api/v1/guards/patrols` | GET | ADMIN | Get patrol logs (paginated, filterable by guard, date) |
| `/api/v1/guards/patrols/report` | GET | ADMIN | Patrol summary report |
| `/api/v1/guards/shifts` | POST | ADMIN | Create/assign guard shift |
| `/api/v1/guards/shifts` | GET | ADMIN, GUARD | List shifts |
| `/api/v1/guards/e-intercom/{flatId}` | POST | GUARD | Send intercom notification to resident |

**Business Rules:**
- Checkpoints are geolocated or QR-tagged positions in the society.
- Guards scan checkpoints during patrol rounds; the system records timestamp and checkpoint.
- Patrol report: missed checkpoints, on-time vs. late scans, guard performance.
- E-intercom: fires a push notification to the flat's resident(s) — the backend stores the intercom log.

---

### Feature 6 — Community Communications (`communication`)

**Package:** `com.myguard.communication`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/communications/notices` | POST | ADMIN | Post a notice |
| `/api/v1/communications/notices` | GET | All Roles | List notices (paginated) |
| `/api/v1/communications/notices/{id}` | GET | All Roles | Get notice detail |
| `/api/v1/communications/notices/{id}` | PUT | ADMIN | Update notice |
| `/api/v1/communications/notices/{id}` | DELETE | ADMIN | Delete notice |
| `/api/v1/communications/polls` | POST | ADMIN | Create a poll |
| `/api/v1/communications/polls` | GET | All Roles | List polls |
| `/api/v1/communications/polls/{id}` | GET | All Roles | Get poll details with results |
| `/api/v1/communications/polls/{id}/vote` | POST | RESIDENT | Cast a vote |
| `/api/v1/communications/groups` | POST | ADMIN | Create communication group |
| `/api/v1/communications/groups` | GET | All Roles | List groups |
| `/api/v1/communications/groups/{id}/messages` | POST | All Roles | Send message to group |
| `/api/v1/communications/groups/{id}/messages` | GET | All Roles | List group messages (paginated) |
| `/api/v1/communications/documents` | POST | ADMIN | Upload society document |
| `/api/v1/communications/documents` | GET | All Roles | List documents |
| `/api/v1/communications/documents/{id}` | GET | All Roles | Download/view document |

**Business Rules:**
- Notices have: title, body, type (general/urgent/maintenance), attachments, posted by, posted at, expiry date.
- Polls have: question, options, start/end date, is_secret (boolean), allow_multiple_votes (boolean).
- Secret polls: votes are stored without linking to the voter UID.
- Groups: can be tower-wise, interest-based, or custom; admin-created.
- Documents: society bylaws, meeting minutes, financial reports — stored as Firebase Storage URLs.

---

### Feature 7 — Amenity Booking (`amenity`)

**Package:** `com.myguard.amenity`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/amenities` | POST | ADMIN | Create amenity |
| `/api/v1/amenities` | GET | All Roles | List amenities |
| `/api/v1/amenities/{id}` | GET | All Roles | Get amenity details (with slots) |
| `/api/v1/amenities/{id}` | PUT | ADMIN | Update amenity |
| `/api/v1/amenities/{id}/slots` | GET | All Roles | Get available slots for a date |
| `/api/v1/amenities/bookings` | POST | RESIDENT | Book an amenity slot |
| `/api/v1/amenities/bookings` | GET | RESIDENT | List my bookings |
| `/api/v1/amenities/bookings/{id}` | GET | All Roles | Get booking details |
| `/api/v1/amenities/bookings/{id}/cancel` | PATCH | RESIDENT | Cancel booking |
| `/api/v1/amenities/bookings/{id}/check-in` | PATCH | GUARD, ADMIN | Check-in for booking |
| `/api/v1/amenities/bookings/{id}/check-out` | PATCH | GUARD, ADMIN | Check-out for booking |
| `/api/v1/amenities/bookings/admin` | GET | ADMIN | List all bookings (paginated, filterable) |

**Business Rules:**
- Amenity: name, type (clubhouse/gym/pool/tennis/party-hall/etc.), capacity, pricing, operating hours, cool-down period between slots, maintenance closure dates.
- Slot management: configurable start times, duration, cool-down between bookings.
- Differential pricing: per amenity category.
- Cancellation: allowed before X hours of slot time with configurable cancellation charges.
- Defaulter blocking: residents with unpaid maintenance dues cannot book amenities (check via a flag on user/flat).
- Companion management: booking includes number of companions.
- Capacity control: no overbooking — check current bookings count vs. amenity capacity.

---

### Feature 8 — Digital Helpdesk (`helpdesk`)

**Package:** `com.myguard.helpdesk`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/helpdesk/tickets` | POST | RESIDENT | Create a new ticket/complaint |
| `/api/v1/helpdesk/tickets` | GET | RESIDENT | List my tickets (paginated) |
| `/api/v1/helpdesk/tickets/{id}` | GET | All Roles | Get ticket details |
| `/api/v1/helpdesk/tickets/{id}/status` | PATCH | ADMIN | Update ticket status |
| `/api/v1/helpdesk/tickets/{id}/assign` | PATCH | ADMIN | Assign ticket to staff |
| `/api/v1/helpdesk/tickets/{id}/comment` | POST | All Roles | Add comment to ticket |
| `/api/v1/helpdesk/tickets/{id}/rate` | POST | RESIDENT | Rate resolved ticket |
| `/api/v1/helpdesk/tickets/admin` | GET | ADMIN | List all tickets (paginated, filterable by status, category, tower) |
| `/api/v1/helpdesk/categories` | POST | ADMIN | Create ticket category |
| `/api/v1/helpdesk/categories` | GET | All Roles | List categories |
| `/api/v1/helpdesk/reports` | GET | ADMIN | Helpdesk summary report |

**Business Rules:**
- Ticket: title, description, category, sub-category, attachments, flat, raised-by, status (open/in-progress/resolved/closed/escalated), priority (low/medium/high/critical), assigned-to, SLA deadline.
- Auto escalation: if a ticket isn't resolved within the SLA, auto-escalate to the next level (update status + notify admin).
- Rating: 1–5 stars + optional comment, only on resolved/closed tickets, only by the ticket creator.
- Reports: tickets by category, by tower, average resolution time, SLA adherence %.

---

### Feature 9 — Vehicle & Parking Management (`vehicle`)

**Package:** `com.myguard.vehicle`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/vehicles` | POST | RESIDENT | Register a vehicle |
| `/api/v1/vehicles` | GET | RESIDENT | List my vehicles |
| `/api/v1/vehicles/{id}` | GET | All Roles | Get vehicle details |
| `/api/v1/vehicles/{id}` | PUT | RESIDENT | Update vehicle |
| `/api/v1/vehicles/{id}` | DELETE | RESIDENT | Deregister vehicle |
| `/api/v1/vehicles/lookup/{plateNumber}` | GET | GUARD, ADMIN | Look up vehicle owner by plate number |
| `/api/v1/vehicles/parking` | POST | ADMIN | Allocate parking slot |
| `/api/v1/vehicles/parking` | GET | All Roles | List parking allocations |
| `/api/v1/vehicles/visitor-log` | POST | GUARD | Log visitor vehicle at gate |
| `/api/v1/vehicles/visitor-log` | GET | ADMIN | List visitor vehicle logs |

**Business Rules:**
- Vehicle: plate number (unique), make, model, colour, type (car/bike/other), owner UID, flat, parking slot.
- Parking: slot number, block/zone, type (covered/open/reserved), allocated vehicle ID.
- Visitor vehicle log: plate number, entry time, exit time, associated visitor entry ID.

---

### Feature 10 — Material Gatepass (`material`)

**Package:** `com.myguard.material`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/material-gatepasses` | POST | RESIDENT, ADMIN | Request material gatepass (in or out) |
| `/api/v1/material-gatepasses` | GET | RESIDENT | List my gatepasses (paginated) |
| `/api/v1/material-gatepasses/{id}` | GET | All Roles | Get gatepass details |
| `/api/v1/material-gatepasses/{id}/approve` | PATCH | ADMIN | Approve gatepass |
| `/api/v1/material-gatepasses/{id}/verify` | PATCH | GUARD | Verify at gate (mark as completed) |
| `/api/v1/material-gatepasses/admin` | GET | ADMIN | List all gatepasses (paginated, filterable) |

**Business Rules:**
- Gatepass: type (inward/outward), description, items list, vehicle number (optional), expected date, requested by, flat, status (pending/approved/verified/rejected), approved by, verified by, verified at (timestamp).

---

### Feature 11 — Emergency & Panic (`emergency`)

**Package:** `com.myguard.emergency`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/emergency/panic` | POST | RESIDENT | Trigger panic alert |
| `/api/v1/emergency/panic` | GET | ADMIN, GUARD | List active panic alerts |
| `/api/v1/emergency/panic/{id}/resolve` | PATCH | ADMIN, GUARD | Resolve panic alert |
| `/api/v1/emergency/contacts` | POST | ADMIN | Add emergency contact |
| `/api/v1/emergency/contacts` | GET | All Roles | List emergency contacts |
| `/api/v1/emergency/contacts/{id}` | PUT | ADMIN | Update emergency contact |
| `/api/v1/emergency/contacts/{id}` | DELETE | ADMIN | Delete emergency contact |
| `/api/v1/emergency/child-alerts` | GET | RESIDENT | Get child entry/exit alerts |

**Business Rules:**
- Panic: flat, triggered by, timestamp, location (optional), status (active/resolved), resolved by, resolved at.
- Panic alert should notify all guards on duty and all admins.
- Emergency contacts: name, phone, type (police/fire/ambulance/hospital/other), address.
- Child alerts: linked to configured child profiles under a resident's flat, triggered on gate entry/exit.

---

### Feature 12 — Pet Directory (`pet`)

**Package:** `com.myguard.pet`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/pets` | POST | RESIDENT | Register a pet |
| `/api/v1/pets` | GET | All Roles | List pets in society (paginated) |
| `/api/v1/pets/{id}` | GET | All Roles | Get pet profile |
| `/api/v1/pets/{id}` | PUT | RESIDENT | Update pet profile |
| `/api/v1/pets/{id}` | DELETE | RESIDENT | Remove pet |
| `/api/v1/pets/{id}/vaccinations` | POST | RESIDENT | Add vaccination record |
| `/api/v1/pets/{id}/vaccinations` | GET | All Roles | List vaccination records |

**Business Rules:**
- Pet: name, breed, type (dog/cat/bird/other), age, photo, owner UID, flat, vaccination status.
- Vaccination: vaccine name, date administered, next due date, vet name, certificate URL.
- Vaccination reminders: queryable — return pets with upcoming due dates.

---

### Feature 13 — Peer-to-Peer Marketplace (`marketplace`)

**Package:** `com.myguard.marketplace`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/marketplace/listings` | POST | RESIDENT | Create a listing (sell/giveaway) |
| `/api/v1/marketplace/listings` | GET | All Roles | Browse listings (paginated, filterable by category) |
| `/api/v1/marketplace/listings/{id}` | GET | All Roles | Get listing detail |
| `/api/v1/marketplace/listings/{id}` | PUT | RESIDENT | Update own listing |
| `/api/v1/marketplace/listings/{id}` | DELETE | RESIDENT | Delete own listing |
| `/api/v1/marketplace/listings/{id}/interest` | POST | RESIDENT | Express interest / contact seller |
| `/api/v1/marketplace/listings/{id}/mark-sold` | PATCH | RESIDENT | Mark as sold |

**Business Rules:**
- Listing: title, description, photos (multiple), category (furniture/electronics/books/clothing/other), price (0 for giveaway), condition (new/like-new/good/fair), posted by, flat, status (active/sold/expired), created at.
- Only the listing owner can update/delete/mark-sold.
- Interest: creates a record linking interested buyer UID to the listing, notifies the seller.

---

### Feature 14 — Admin Dashboard Data (`dashboard`)

**Package:** `com.myguard.dashboard`

| Endpoint | Method | Access | Description |
|---|---|---|---|
| `/api/v1/dashboard/summary` | GET | ADMIN | Overview stats (total residents, guards, flats, open tickets, active visitors, etc.) |
| `/api/v1/dashboard/visitor-stats` | GET | ADMIN | Visitor statistics (daily/weekly/monthly counts) |
| `/api/v1/dashboard/helpdesk-stats` | GET | ADMIN | Helpdesk KPIs (open, resolved, SLA breach count) |
| `/api/v1/dashboard/amenity-stats` | GET | ADMIN | Amenity booking utilisation stats |
| `/api/v1/dashboard/guard-performance` | GET | ADMIN | Guard patrol completion rates |
| `/api/v1/dashboard/move-in-out` | GET | ADMIN | Move-in/move-out log |

**Business Rules:**
- All stats endpoints accept date-range query params (`from`, `to`).
- Summary: aggregate counts, can be cached for short TTL.
- These endpoints aggregate data from other feature collections — use service-layer composition (call other feature services via their interfaces if absolutely needed, or query Firestore directly in dashboard repositories).

---

## 📦 API Collection Export (Postman / ApiDog)

**After implementing all features, generate a complete API collection JSON file** that can be imported directly into **Postman** or **ApiDog**.

### Requirements for the collection:

| Requirement | Detail |
|---|---|
| **File location** | `backend/api-collection/MyGuard_API_Collection.json` |
| **Format** | Postman Collection v2.1 (`application/json`) |
| **Organisation** | Separate **folder per feature** (Auth, Society, Visitor, DailyHelp, Guard, Communication, Amenity, Helpdesk, Vehicle, Material, Emergency, Pet, Marketplace, Dashboard) |
| **Each request must include** | Method, URL (`{{baseUrl}}/api/v1/...`), headers (`Authorization: Bearer {{token}}`), request body (JSON example with realistic sample data), description |
| **Variables** | Define `baseUrl` (default `http://localhost:8080`) and `token` as collection-level variables |
| **Auth** | Set `Bearer Token` auth at the collection level inheriting to all requests |
| **Response examples** | Include at least one example response body per request showing the `ApiResponse<T>` wrapper |
| **Pagination params** | All list endpoints must include `page`, `size`, `sort` query params with defaults |

### Collection Structure Example

```json
{
  "info": {
    "name": "MyGuard API Collection",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    { "key": "baseUrl", "value": "http://localhost:8080" },
    { "key": "token", "value": "" }
  ],
  "auth": {
    "type": "bearer",
    "bearer": [{ "key": "token", "value": "{{token}}" }]
  },
  "item": [
    {
      "name": "01 — Auth & User Management",
      "item": [ /* ...individual requests... */ ]
    },
    {
      "name": "02 — Society & Flat Management",
      "item": [ /* ... */ ]
    }
    // ... one folder per feature
  ]
}
```

---

## 🏗️ Implementation Order

Build features in this sequence to manage dependencies correctly:

| Phase | Features | Reason |
|---|---|---|
| **Phase 0** | Project setup, Firebase config, Security config, common package (ApiResponse, ErrorResponse, GlobalExceptionHandler, FirebaseTokenFilter, constants) | Foundation |
| **Phase 1** | Auth & User Management, Society & Flat Management | Core entities that all other features depend on |
| **Phase 2** | Gate & Visitor Management, Daily Help Management | Flagship gate module |
| **Phase 3** | Guard Management & Patrolling, Emergency & Panic | Security layer |
| **Phase 4** | Community Communications | Community engagement |
| **Phase 5** | Amenity Booking, Digital Helpdesk | Facility management |
| **Phase 6** | Vehicle & Parking, Material Gatepass | Ancillary gate features |
| **Phase 7** | Pet Directory, Marketplace | Community lifestyle |
| **Phase 8** | Admin Dashboard | Aggregates data from all features |
| **Phase 9** | Postman / ApiDog JSON Collection | Export after all APIs are stable |

---

## 🔒 Cross-Cutting Concerns Checklist

Before marking any feature as complete, verify:

- [ ] All endpoints return `ResponseEntity<ApiResponse<T>>`.
- [ ] All request DTOs have Bean Validation annotations.
- [ ] All list endpoints support pagination (`page`, `size`, `sort`).
- [ ] All endpoints have `@PreAuthorize` with the correct role(s).
- [ ] Entities are never returned directly from controllers — always map to response DTOs.
- [ ] Firestore calls only exist in `RepositoryImpl` classes.
- [ ] Business logic only exists in `ServiceImpl` classes.
- [ ] No `try-catch` in controllers.
- [ ] Logging uses `@Slf4j` with `[FEATURE]` prefix in messages.
- [ ] No hardcoded credentials, collection names, or environment-specific values (use constants and config).
- [ ] The Firebase token filter correctly populates `SecurityContextHolder`.
- [ ] CORS is explicitly configured (not wildcard `*`).
- [ ] The corresponding Postman collection folder is updated with the new endpoints.

---

## 📝 Output Summary

When you finish, the `backend/` folder must contain:

```
backend/
├── pom.xml
├── src/main/java/com/myguard/
│   ├── MyGuardApplication.java
│   ├── common/
│   │   ├── config/          (FirebaseConfig, SecurityConfig, CorsConfig, SwaggerConfig)
│   │   ├── exception/       (MyGuardException hierarchy + GlobalExceptionHandler)
│   │   ├── filter/          (FirebaseTokenFilter, RequestLoggingFilter)
│   │   ├── response/        (ApiResponse, ErrorResponse)
│   │   └── constants/       (GlobalConstants)
│   ├── auth/                (controller, service, repository, view, dto)
│   ├── society/             (controller, service, repository, view, dto)
│   ├── visitor/             (controller, service, repository, view, dto)
│   ├── dailyhelp/           (controller, service, repository, view, dto)
│   ├── guard/               (controller, service, repository, view, dto)
│   ├── communication/       (controller, service, repository, view, dto)
│   ├── amenity/             (controller, service, repository, view, dto)
│   ├── helpdesk/            (controller, service, repository, view, dto)
│   ├── vehicle/             (controller, service, repository, view, dto)
│   ├── material/            (controller, service, repository, view, dto)
│   ├── emergency/           (controller, service, repository, view, dto)
│   ├── pet/                 (controller, service, repository, view, dto)
│   ├── marketplace/         (controller, service, repository, view, dto)
│   └── dashboard/           (controller, service, repository, dto)
├── src/main/resources/
│   ├── application.yml
│   ├── application-dev.yml
│   ├── application-staging.yml
│   └── application-prod.yml
├── src/test/java/com/myguard/   (mirrors source)
└── api-collection/
    └── MyGuard_API_Collection.json
```

---

## ⚠️ Critical Reminders

1. **Read `backend_rules.md` first** — it is the non-negotiable architectural law.
2. **Read `features.md`** — it defines every feature to be built.
3. **Never skip layers** — Controller → Service → Repository. No shortcuts.
4. **Never expose entities** — always return DTOs.
5. **Never put Firebase calls outside repositories.**
6. **Never hardcode secrets** — use environment variables.
7. **Always paginate list endpoints** — no unbounded queries.
8. **Always validate inputs** — Bean Validation on every request DTO.
9. **Always authorize** — `@PreAuthorize` on every protected endpoint.
10. **Generate the Postman/ApiDog JSON collection** — it must be importable with zero manual changes.
