# MyGuard — Frontend Prompt

> **You are an expert Senior Flutter / Dart engineer and UI/UX designer** with 10+ years of production experience building large-scale mobile applications. You specialise in Flutter, Firebase Authentication, Clean Architecture (Feature-First), BLoC/Cubit state management, and translating Figma designs into pixel-perfect, accessible, performant Flutter screens. You write clean, maintainable, production-ready code that strictly follows an architectural ruleset provided to you.

---

## 🎯 Objective

Build the **complete Flutter mobile application** for **MyGuard** — a gated-community management platform (similar to MyGate). The app communicates with a Spring Boot backend via REST APIs. Firebase Auth is used for authentication. The app supports **three distinct roles** — Residents, Security Guards, and Admins — each with their own tailored experience.

**Every screen must first be designed as a Figma frame, saved in the `figma/` folder, and then translated into Flutter code.**

---

## 📂 Project Location & Initialisation

| Item | Value |
|---|---|
| **Output folder** | `frontend/` (relative to workspace root) |
| **Figma designs folder** | `figma/` (relative to workspace root) |
| **Flutter version** | Latest stable (3.x) |
| **Dart version** | Latest stable (3.x) |
| **State management** | `flutter_bloc` (BLoC + Cubit) |
| **Navigation** | `go_router` |
| **HTTP client** | `dio` |
| **DI** | `get_it` + `injectable` |
| **Functional error handling** | `dartz` or `fpdart` (`Either<Failure, T>`) |

### Key Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter_bloc:
  go_router:
  dio:
  get_it:
  injectable:
  dartz:              # or fpdart
  firebase_core:
  firebase_auth:
  equatable:
  cached_network_image:
  shimmer:
  flutter_svg:
  image_picker:
  qr_flutter:         # QR code generation
  qr_code_scanner:    # QR code scanning (guard app)
  intl:               # Date/time formatting
  flutter_secure_storage:
  shared_preferences:
  json_annotation:
  json_serializable:
  build_runner:        # dev dependency
  injectable_generator: # dev dependency
  mocktail:            # dev dependency
  bloc_test:           # dev dependency
```

---

## 📜 Mandatory Rules — `frontend_rules.md`

**You MUST read and internalise every rule defined in `frontend_rules.md` before writing a single line of code.** That file is the absolute authority on:

1. **Project structure** — Feature-first under `lib/features/<feature>/`, shared code in `lib/shared/`, design tokens in `lib/design_system/`, core infra in `lib/core/`.
2. **Naming conventions** — file names (`snake_case`), class names (`PascalCase`), constants (`SCREAMING_SNAKE_CASE`), suffixes (`_screen.dart`, `_widget.dart`, `_bloc.dart`, etc.).
3. **Architecture** — `Presentation → Domain → Data`. Screen → Bloc/Cubit → UseCase → Repository (Interface) → RepositoryImpl → RemoteDatasource → API.
4. **Screen & widget rules** — screens handle layout + BlocBuilder/BlocListener only, no business logic; widgets are small + single-purpose; `const` constructors; all text uses `AppTypography`.
5. **State management** — `flutter_bloc`; sealed state classes with `Initial`, `Loading`, `Success`, `Failure`; `BlocProvider` at route level; no `setState` for business data.
6. **Navigation** — `go_router`; central `app_router.dart`; named routes; route constants per feature; auth guard via redirect.
7. **API integration** — `dio` with `AuthInterceptor`, `LoggingInterceptor`, `ErrorInterceptor`; `ApiResponseModel<T>` matching backend wrapper; no raw HTTP calls.
8. **Firebase auth** — wrapped in `core/firebase/auth_service.dart`; automatic token refresh via interceptor; auth state stream in root `AuthBloc`; clear all caches on sign-out.
9. **Design system** — `AppColors`, `AppTypography`, `AppSpacing`, `AppRadius`, `AppShadows`, `AppTheme`; dark mode from day one; no inline styles anywhere.
10. **Figma-to-code** — each Figma frame → one Screen; each Figma component → one Widget; auto-layout → Column/Row; design tokens mapped to `design_system`.
11. **Form & validation** — `Form` + `GlobalKey<FormState>`; shared `AppTextField`; validators in `core/utils/validators.dart`; inline errors; disable submit on loading.
12. **Error handling** — `Failure` sealed class hierarchy; `Either<Failure, T>` return types; snackbars for transient errors; inline error widgets for screen-level failures; retry on network errors.
13. **Performance** — `const` constructors; `ListView.builder` for lists; paginated infinite scroll; `CachedNetworkImage`; debounce search; `RepaintBoundary`.
14. **Accessibility** — `Semantics` labels; 48×48dp tap targets; colour never sole indicator; font scaling support; WCAG AA contrast.
15. **Testing** — unit tests for UseCases + Blocs/Cubits; widget tests for screens; `mocktail` for mocking; `bloc_test` for state transitions.

**If any instruction in this prompt conflicts with `frontend_rules.md`, the rules file wins.**

---

## 👥 Roles & App Experience

The app serves three roles. After login, the user is routed to a **role-specific home screen** with a role-specific bottom navigation / drawer.

| Role | Home Experience | Key Actions |
|---|---|---|
| **Resident** | Dashboard with quick actions (pre-approve visitor, SOS, notices) | Approve/reject visitors, manage daily helps, book amenities, raise tickets, marketplace |
| **Security Guard** | Gate-centric view (pending entries, recent entries, patrol) | Log visitor entry/exit, scan QR, mark daily help attendance, patrol checkpoint scan, e-intercom |
| **Admin** | Admin dashboard with stats, management panels | Manage society, users, amenities, notices, tickets, view reports, approve gatepasses |

### Auth Flow (Screens)

1. **Splash Screen** → Check Firebase Auth state.
2. If not authenticated → **Login Screen** (email+password, phone OTP, Google Sign-In).
3. If authenticated → fetch user profile from backend → route to role-specific home.
4. **Registration Screen** → Name, email, phone, society selection, flat selection, role request.
5. **Forgot Password Screen** → Firebase password reset email.

---

## 🎨 Figma-First Design Workflow

### Process for Every Screen

```
1. DESIGN  →  Create Figma frame (390×844, iPhone 14 base) in figma/ folder
2. DOCUMENT  →  Annotate: spacing, colors (from AppColors), typography (from AppTypography), states
3. TRANSLATE  →  Convert to Flutter screen / widget following frontend_rules.md
```

### Figma Folder Structure

```
figma/
├── 00_design_system/
│   ├── colors.fig            # Color palette document
│   ├── typography.fig        # Type scale document
│   ├── spacing_and_grid.fig  # Spacing tokens, grid system
│   ├── components.fig        # Shared components (buttons, inputs, cards, dialogs, snackbars)
│   └── iconography.fig       # Icon set
├── 01_auth/
│   ├── splash_screen.fig
│   ├── login_screen.fig
│   ├── register_screen.fig
│   ├── forgot_password_screen.fig
│   └── otp_verification_screen.fig
├── 02_resident/
│   ├── resident_home_screen.fig
│   ├── visitor_pre_approve_screen.fig
│   ├── visitor_history_screen.fig
│   ├── guest_invite_screen.fig
│   ├── daily_help_list_screen.fig
│   ├── daily_help_detail_screen.fig
│   ├── daily_help_attendance_screen.fig
│   ├── amenity_list_screen.fig
│   ├── amenity_booking_screen.fig
│   ├── my_bookings_screen.fig
│   ├── helpdesk_ticket_list_screen.fig
│   ├── helpdesk_create_ticket_screen.fig
│   ├── helpdesk_ticket_detail_screen.fig
│   ├── notice_board_screen.fig
│   ├── notice_detail_screen.fig
│   ├── poll_list_screen.fig
│   ├── poll_vote_screen.fig
│   ├── vehicle_list_screen.fig
│   ├── vehicle_register_screen.fig
│   ├── material_gatepass_screen.fig
│   ├── marketplace_browse_screen.fig
│   ├── marketplace_create_listing_screen.fig
│   ├── marketplace_listing_detail_screen.fig
│   ├── pet_directory_screen.fig
│   ├── pet_register_screen.fig
│   ├── pet_profile_screen.fig
│   ├── emergency_contacts_screen.fig
│   ├── panic_button_screen.fig
│   ├── community_group_list_screen.fig
│   ├── community_chat_screen.fig
│   ├── documents_screen.fig
│   ├── profile_screen.fig
│   └── settings_screen.fig
├── 03_guard/
│   ├── guard_home_screen.fig
│   ├── visitor_entry_screen.fig
│   ├── visitor_exit_screen.fig
│   ├── qr_scan_screen.fig
│   ├── group_entry_screen.fig
│   ├── daily_help_check_in_screen.fig
│   ├── patrol_screen.fig
│   ├── patrol_checkpoint_scan_screen.fig
│   ├── e_intercom_screen.fig
│   ├── vehicle_log_screen.fig
│   ├── material_verify_screen.fig
│   ├── panic_alerts_screen.fig
│   └── guard_profile_screen.fig
├── 04_admin/
│   ├── admin_home_dashboard_screen.fig
│   ├── society_management_screen.fig
│   ├── flat_management_screen.fig
│   ├── user_management_screen.fig
│   ├── user_detail_screen.fig
│   ├── visitor_reports_screen.fig
│   ├── guard_management_screen.fig
│   ├── guard_shift_screen.fig
│   ├── guard_patrol_report_screen.fig
│   ├── notice_management_screen.fig
│   ├── poll_management_screen.fig
│   ├── amenity_management_screen.fig
│   ├── booking_management_screen.fig
│   ├── helpdesk_management_screen.fig
│   ├── helpdesk_reports_screen.fig
│   ├── vehicle_management_screen.fig
│   ├── material_gatepass_management_screen.fig
│   ├── emergency_contact_management_screen.fig
│   ├── document_management_screen.fig
│   ├── move_in_out_screen.fig
│   └── admin_settings_screen.fig
└── 05_shared_states/
    ├── loading_states.fig         # Skeleton / shimmer for each screen type
    ├── empty_states.fig           # Illustration + message + CTA
    ├── error_states.fig           # Error message + retry
    └── dark_mode_variants.fig     # Dark mode for key screens
```

### Figma Frame Requirements (per `frontend_rules.md`)

Every screen frame must include:

| Element | Requirement |
|---|---|
| Frame size | 390 × 844 (iPhone 14 base) |
| Status bar | Included as component |
| Safe area | Top and bottom insets marked |
| Navigation bar | Consistent across all screens within a role |
| Loading state | Skeleton or shimmer variant |
| Empty state | Illustration + message + CTA |
| Error state | Error message + retry CTA |
| Dark mode | Required for all screens |

### Design Principles (from `frontend_rules.md`)

- **Mobile-first layout** — design for 375px width minimum, test at 320px.
- **Consistent visual hierarchy** — heading → subheading → body → caption.
- **Generous whitespace** — Mobbin-style spacing; content should breathe.
- **Clear primary CTA** — every screen has one visually dominant action button.
- **Modern card-based UI** — group related content in elevated or outlined cards with consistent radius.
- **Bottom-safe navigation** — all interactive elements reachable by thumb (bottom 60% of screen).

---

## ✅ Features to Implement

**All features listed in `features.md` must be implemented as Flutter screens and their supporting architecture (domain, data, presentation layers).** Below is the feature-by-feature breakdown with frontend-specific guidance.

For each feature, you must produce:

1. **Figma designs** — every screen as a `.fig` frame in the `figma/` folder.
2. **Domain layer** — entities, repository interfaces, use cases.
3. **Data layer** — models (DTOs), remote datasource, repository implementation.
4. **Presentation layer** — screens, widgets, BLoC/Cubit, routes.

---

### Feature 1 — Authentication (`auth`)

**Package:** `lib/features/auth/`

#### Screens

| Screen | Description | Key UI Elements |
|---|---|---|
| `SplashScreen` | App launch, check auth state | Logo, loading indicator |
| `LoginScreen` | Email+password login, Google Sign-In, Phone OTP option | Form fields, social login buttons, "Forgot Password?" link, "Register" link |
| `RegisterScreen` | New user registration | Name, email, phone, society dropdown, flat dropdown, role selector (Resident default), profile photo upload |
| `ForgotPasswordScreen` | Password reset | Email input, send reset link button, success message |
| `OtpVerificationScreen` | Phone OTP entry | OTP input fields (6-digit), timer, resend button |

#### BLoC / Cubit

- `AuthBloc` — handles login, register, logout, auth state changes.
- States: `AuthInitial`, `AuthLoading`, `AuthAuthenticated(user)`, `AuthUnauthenticated`, `AuthFailure(message)`.

#### Business Logic

- On app start, `AuthBloc` checks `FirebaseAuth.instance.currentUser`.
- If user exists → fetch profile from backend (`GET /api/v1/auth/profile`) → route by role.
- If no user → show `LoginScreen`.
- After login/register → fetch profile → navigate to role-specific home.
- Logout → clear Firebase auth + secure storage + all BLoC states → navigate to `LoginScreen`.

---

### Feature 2 — Resident Experience (`resident`)

**Package:** `lib/features/resident/`

#### Home Screen

| Section | Content |
|---|---|
| **Header** | Greeting (Good Morning, {name}), profile avatar, notification bell |
| **Quick Actions Grid** | Pre-approve Visitor, SOS / Panic, My Daily Helps, Book Amenity, Raise Ticket, Notices |
| **Recent Activity** | Last 5 visitor entries (with status badges) |
| **Community Highlights** | Active polls, upcoming amenity bookings, unread notices count |

#### Bottom Navigation

| Tab | Icon | Screen |
|---|---|---|
| Home | 🏠 | `ResidentHomeScreen` |
| Gate | 🚪 | `VisitorHistoryScreen` (with FAB for pre-approve) |
| Services | 🛠️ | `ServicesScreen` (grid: Amenities, Helpdesk, Vehicles, Marketplace, Pets, Documents) |
| Community | 💬 | `CommunityScreen` (Notices, Polls, Groups, Directory) |
| Profile | 👤 | `ProfileScreen` |

---

### Feature 3 — Gate & Visitor Management Screens (`visitor`)

**Package:** `lib/features/visitor/`

#### Screens (Resident)

| Screen | Description |
|---|---|
| `VisitorPreApproveScreen` | Form: visitor name, phone, expected date/time, purpose, vehicle number (optional). Generates code/QR on success. |
| `VisitorHistoryScreen` | Paginated list of visitor entries with status filters (pending/approved/rejected/completed). Pull-to-refresh. |
| `VisitorDetailScreen` | Full details: photo, name, phone, purpose, flat, entry/exit times, status, actions (approve/reject if pending). |
| `GuestInviteScreen` | Generate shareable guest invite link with QR code. Shows active invites with revoke option. |
| `RecurringInviteScreen` | List and manage recurring invites (create, view, revoke). |
| `VisitorApprovalSheet` | Bottom sheet triggered by push notification — shows visitor photo, name, purpose, approve/reject buttons. |

#### Screens (Guard)

| Screen | Description |
|---|---|
| `VisitorEntryScreen` | Form: visitor name, phone, purpose, flat selection, photo capture (camera), vehicle number. Pre-fill if pre-approved code entered. |
| `VisitorExitScreen` | Search active visitors, mark exit with timestamp. |
| `QrScanScreen` | Camera-based QR scanner. On successful scan → verify code via API → auto-fill entry form. |
| `GroupEntryScreen` | Bulk entry: add multiple visitors at once for an event, all linked to a single flat/host. |

#### State Management

- `VisitorBloc` — handles entry, approval, rejection, exit, pre-approvals, history pagination.
- `GuestInviteCubit` — handles invite creation, listing, revocation.
- `QrScanCubit` — handles QR scan result and code verification.

---

### Feature 4 — Daily Help Management Screens (`dailyhelp`)

**Package:** `lib/features/dailyhelp/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `DailyHelpListScreen` | Resident | List of registered daily helps with today's attendance status |
| `DailyHelpDetailScreen` | Resident | Profile, schedule, attendance calendar heatmap, monthly summary |
| `DailyHelpRegisterScreen` | Resident | Form: name, phone, photo, type (maid/cook/driver/nanny), schedule (days, time) |
| `DailyHelpCheckInScreen` | Guard | Search daily help by name/phone, mark entry/exit with timestamp |

#### State Management

- `DailyHelpCubit` — CRUD operations + attendance tracking.

---

### Feature 5 — Guard Management & Patrolling Screens (`guard`)

**Package:** `lib/features/guard/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `GuardHomeScreen` | Guard | Dashboard: pending entries count, today's patrol status, shift info, quick actions |
| `PatrolScreen` | Guard | List of patrol checkpoints with scan status (done/pending), map view optional |
| `PatrolCheckpointScanScreen` | Guard | QR scan to log checkpoint visit |
| `EIntercomScreen` | Guard | Select flat → send intercom notification to resident |
| `PanicAlertsScreen` | Guard | List of active panic alerts with details (flat, time, resident) |
| `GuardManagementScreen` | Admin | List guards, assign shifts, view performance |
| `GuardShiftScreen` | Admin | Create/edit shift assignments |
| `GuardPatrolReportScreen` | Admin | Patrol completion reports with graphs (on-time %, missed checkpoints) |

#### State Management

- `PatrolCubit` — checkpoint listing + scan logging.
- `GuardManagementBloc` — admin operations on guards.

---

### Feature 6 — Community Communications Screens (`communication`)

**Package:** `lib/features/communication/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `NoticeBoardScreen` | All | Paginated list of notices, filterable by type (general/urgent/maintenance), search |
| `NoticeDetailScreen` | All | Full notice with attachments, posted by, date |
| `NoticeCreateScreen` | Admin | Form: title, body (rich text), type, attachments, expiry date |
| `PollListScreen` | All | Active and past polls with participation status |
| `PollVoteScreen` | Resident | Poll question, options (radio/checkbox), submit vote, view results (if allowed) |
| `PollCreateScreen` | Admin | Form: question, options (dynamic add/remove), start/end date, secret toggle |
| `CommunityGroupListScreen` | All | List communication groups with unread count |
| `CommunityChatScreen` | All | Group chat-style message list with input field |
| `DocumentsScreen` | All | List society documents with download/view, filterable |
| `DocumentUploadScreen` | Admin | Upload document with title, category |

#### State Management

- `NoticeCubit` — CRUD + listing.
- `PollBloc` — create, vote, results.
- `CommunityGroupCubit` — group listing + messaging.
- `DocumentCubit` — list + upload + download.

---

### Feature 7 — Amenity Booking Screens (`amenity`)

**Package:** `lib/features/amenity/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `AmenityListScreen` | All | Grid/list of amenities with photos, type, availability indicator |
| `AmenityDetailScreen` | All | Full details: capacity, pricing, operating hours, rules. Date picker → show available slots. |
| `AmenityBookingScreen` | Resident | Select date → select slot → number of companions → confirm booking |
| `MyBookingsScreen` | Resident | List of my upcoming and past bookings with cancel option |
| `BookingDetailScreen` | All | Full booking details with check-in/check-out status |
| `AmenityManagementScreen` | Admin | CRUD amenities, set pricing, configure slots, manage closures |
| `BookingManagementScreen` | Admin | All bookings, filterable, with check-in/check-out actions |

#### State Management

- `AmenityBloc` — list amenities, fetch slots, create booking, cancel booking.
- `AmenityAdminCubit` — admin CRUD operations.

#### UI Details

- Slot picker: horizontal time slots with available/booked/blocked states (colour-coded).
- Calendar view for date selection.
- Booking confirmation bottom sheet with pricing breakdown.

---

### Feature 8 — Digital Helpdesk Screens (`helpdesk`)

**Package:** `lib/features/helpdesk/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `HelpdeskTicketListScreen` | Resident | My tickets, filterable by status (open/in-progress/resolved/closed), paginated |
| `HelpdeskCreateTicketScreen` | Resident | Form: category dropdown, sub-category, title, description, attachments, priority |
| `HelpdeskTicketDetailScreen` | All | Full ticket details, comment thread, status timeline, rating (if resolved) |
| `HelpdeskManagementScreen` | Admin | All tickets, filterable by status/category/tower, assign to staff |
| `HelpdeskReportsScreen` | Admin | Charts: tickets by category, resolution time, SLA compliance, ratings |

#### State Management

- `HelpdeskBloc` — create ticket, list tickets (pagination + filters), add comment, rate.
- `HelpdeskAdminBloc` — all-tickets view, assign, update status.

#### UI Details

- Status timeline: visual progress bar (Open → In Progress → Resolved → Closed).
- Comment thread: chat-style with timestamps and author.
- Rating: star selector (1-5) + optional text.

---

### Feature 9 — Vehicle & Parking Management Screens (`vehicle`)

**Package:** `lib/features/vehicle/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `VehicleListScreen` | Resident | List my registered vehicles |
| `VehicleRegisterScreen` | Resident | Form: plate number, make, model, colour, type (car/bike/other), parking slot |
| `VehicleDetailScreen` | All | Full vehicle details with parking allocation |
| `VehicleLookupScreen` | Guard | Search vehicle by plate number → show owner + flat |
| `VehicleLogScreen` | Guard | Log visitor vehicle entry/exit at gate |
| `ParkingManagementScreen` | Admin | Allocate/deallocate parking slots, view occupancy |

#### State Management

- `VehicleCubit` — CRUD + lookup.

---

### Feature 10 — Material Gatepass Screens (`material`)

**Package:** `lib/features/material/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `MaterialGatepassScreen` | Resident | List my gatepasses with status |
| `MaterialGatepassCreateScreen` | Resident, Admin | Form: type (in/out), items, description, vehicle number, expected date |
| `MaterialGatepassDetailScreen` | All | Full details with approval status |
| `MaterialGatepassManagementScreen` | Admin | All gatepasses, approve/reject actions |
| `MaterialVerifyScreen` | Guard | Search gatepass → verify at gate → mark completed |

#### State Management

- `MaterialGatepassCubit` — CRUD + approval workflow.

---

### Feature 11 — Emergency & Panic Screens (`emergency`)

**Package:** `lib/features/emergency/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `PanicButtonScreen` | Resident | Large SOS button, recent panic history. Press + hold to trigger. Immediate confirmation. |
| `EmergencyContactsScreen` | All | List of emergency contacts (police, fire, ambulance, hospital) with tap-to-call |
| `EmergencyContactManagementScreen` | Admin | CRUD emergency contacts |
| `PanicAlertsScreen` | Guard, Admin | Active alerts with flat, resident, timestamp. Resolve action. |
| `ChildAlertsScreen` | Resident | List of child entry/exit alerts with timestamps |

#### State Management

- `PanicCubit` — trigger, list, resolve.
- `EmergencyContactCubit` — CRUD.

#### UI Details

- Panic button: large circular red button (minimum 120×120dp), press-and-hold (3 seconds) with visual countdown ring animation to prevent accidental triggers.
- Alert notification: full-screen urgent notification on guard's device.

---

### Feature 12 — Pet Directory Screens (`pet`)

**Package:** `lib/features/pet/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `PetDirectoryScreen` | All | Community pet directory — list with photos, names, types, owners |
| `PetProfileScreen` | All | Full pet profile with vaccination history |
| `PetRegisterScreen` | Resident | Form: name, type, breed, age, photo, vaccination details |
| `VaccinationAddScreen` | Resident | Form: vaccine name, date, next due, vet name, certificate upload |

#### State Management

- `PetCubit` — CRUD + vaccination tracking.

---

### Feature 13 — Peer-to-Peer Marketplace Screens (`marketplace`)

**Package:** `lib/features/marketplace/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `MarketplaceBrowseScreen` | All | Paginated grid of listings with category filters, search bar, pull-to-refresh |
| `MarketplaceListingDetailScreen` | All | Full listing: photos (carousel), title, price, condition, seller info, "I'm Interested" button |
| `MarketplaceCreateListingScreen` | Resident | Form: title, description, photos (multi-pick), category, price, condition |
| `MyListingsScreen` | Resident | My active/sold listings with edit/delete/mark-sold actions |

#### State Management

- `MarketplaceBloc` — browse (pagination + filters), create, update, delete, mark sold, express interest.

#### UI Details

- Listing card: photo thumbnail, title, price badge, condition tag, time-ago timestamp.
- Photo carousel: page indicator dots, pinch-to-zoom.
- Category chips: horizontal scroll filter bar at top.

---

### Feature 14 — Admin Dashboard Screens (`dashboard`)

**Package:** `lib/features/dashboard/`

#### Screens

| Screen | Role | Description |
|---|---|---|
| `AdminHomeDashboardScreen` | Admin | Stat cards (total residents, guards, open tickets, today's visitors, active alerts), quick actions, recent activity feed |
| `SocietyManagementScreen` | Admin | Society details, edit society, tower/block management |
| `FlatManagementScreen` | Admin | List flats, filter by block/status, add/edit flats, assign residents |
| `UserManagementScreen` | Admin | List users by role, search, activate/deactivate, change role |
| `UserDetailScreen` | Admin | Full user profile with role management |
| `VisitorReportsScreen` | Admin | Visitor statistics: daily/weekly/monthly charts, peak hours |
| `MoveInOutScreen` | Admin | Move-in / move-out log and workflow |
| `AdminSettingsScreen` | Admin | App config, notification preferences, society settings |

#### State Management

- `DashboardCubit` — fetch summary stats + report data.
- `SocietyManagementBloc` — society + flat CRUD.
- `UserManagementBloc` — user listing, role changes, activation.

#### UI Details

- Stat cards: animated count-up numbers, colour-coded (green for good, red for alerts).
- Charts: use `fl_chart` or `syncfusion_flutter_charts` for bar/line/pie charts.
- Activity feed: timeline-style list with icons per event type.

---

## 🧭 Navigation & Routing

### Route Structure

```
/                           → SplashScreen (redirect based on auth state)
/auth/login                 → LoginScreen
/auth/register              → RegisterScreen
/auth/forgot-password       → ForgotPasswordScreen
/auth/otp                   → OtpVerificationScreen

/resident/                  → ResidentHomeScreen (ShellRoute with bottom nav)
  /resident/gate            → VisitorHistoryScreen
  /resident/services        → ServicesScreen
  /resident/community       → CommunityScreen
  /resident/profile         → ProfileScreen

/resident/visitor/pre-approve   → VisitorPreApproveScreen
/resident/visitor/{id}          → VisitorDetailScreen
/resident/visitor/guest-invite  → GuestInviteScreen
/resident/visitor/recurring     → RecurringInviteScreen
/resident/daily-help            → DailyHelpListScreen
/resident/daily-help/{id}       → DailyHelpDetailScreen
/resident/daily-help/register   → DailyHelpRegisterScreen
/resident/amenities             → AmenityListScreen
/resident/amenities/{id}        → AmenityDetailScreen
/resident/amenities/book/{id}   → AmenityBookingScreen
/resident/amenities/my-bookings → MyBookingsScreen
/resident/helpdesk              → HelpdeskTicketListScreen
/resident/helpdesk/create       → HelpdeskCreateTicketScreen
/resident/helpdesk/{id}         → HelpdeskTicketDetailScreen
/resident/vehicles              → VehicleListScreen
/resident/vehicles/register     → VehicleRegisterScreen
/resident/material-gatepass     → MaterialGatepassScreen
/resident/material-gatepass/create → MaterialGatepassCreateScreen
/resident/marketplace           → MarketplaceBrowseScreen
/resident/marketplace/create    → MarketplaceCreateListingScreen
/resident/marketplace/{id}      → MarketplaceListingDetailScreen
/resident/pets                  → PetDirectoryScreen
/resident/pets/register         → PetRegisterScreen
/resident/pets/{id}             → PetProfileScreen
/resident/emergency             → EmergencyContactsScreen
/resident/emergency/panic       → PanicButtonScreen
/resident/notices               → NoticeBoardScreen
/resident/notices/{id}          → NoticeDetailScreen
/resident/polls                 → PollListScreen
/resident/polls/{id}            → PollVoteScreen
/resident/groups                → CommunityGroupListScreen
/resident/groups/{id}           → CommunityChatScreen
/resident/documents             → DocumentsScreen

/guard/                     → GuardHomeScreen (ShellRoute with bottom nav)
  /guard/gate               → VisitorEntryScreen
  /guard/patrol             → PatrolScreen
  /guard/alerts             → PanicAlertsScreen
  /guard/profile            → GuardProfileScreen

/guard/visitor/entry         → VisitorEntryScreen
/guard/visitor/exit          → VisitorExitScreen
/guard/visitor/qr-scan       → QrScanScreen
/guard/visitor/group-entry   → GroupEntryScreen
/guard/daily-help/check-in   → DailyHelpCheckInScreen
/guard/patrol/scan           → PatrolCheckpointScanScreen
/guard/e-intercom            → EIntercomScreen
/guard/vehicle-log           → VehicleLogScreen
/guard/material-verify       → MaterialVerifyScreen

/admin/                     → AdminHomeDashboardScreen (ShellRoute with bottom nav or drawer)
  /admin/manage             → Management section
  /admin/reports            → Reports section
  /admin/settings           → AdminSettingsScreen
  /admin/profile            → ProfileScreen

/admin/society              → SocietyManagementScreen
/admin/flats                → FlatManagementScreen
/admin/users                → UserManagementScreen
/admin/users/{uid}          → UserDetailScreen
/admin/visitors             → VisitorReportsScreen
/admin/guards               → GuardManagementScreen
/admin/guards/shifts        → GuardShiftScreen
/admin/guards/patrol-report → GuardPatrolReportScreen
/admin/notices              → NoticeManagementScreen (Notice CRUD)
/admin/notices/create       → NoticeCreateScreen
/admin/polls                → PollManagementScreen
/admin/polls/create         → PollCreateScreen
/admin/amenities            → AmenityManagementScreen
/admin/amenities/bookings   → BookingManagementScreen
/admin/helpdesk             → HelpdeskManagementScreen
/admin/helpdesk/reports     → HelpdeskReportsScreen
/admin/vehicles             → VehicleManagementScreen (ParkingManagementScreen)
/admin/material-gatepasses  → MaterialGatepassManagementScreen
/admin/emergency-contacts   → EmergencyContactManagementScreen
/admin/documents            → DocumentManagementScreen
/admin/move-in-out          → MoveInOutScreen
```

### Auth Guard

```dart
redirect: (context, state) {
  final authState = context.read<AuthBloc>().state;
  final isAuthRoute = state.matchedLocation.startsWith('/auth');

  if (authState is AuthUnauthenticated && !isAuthRoute) {
    return '/auth/login';
  }
  if (authState is AuthAuthenticated && isAuthRoute) {
    return _homeRouteForRole(authState.user.role);
  }
  // Role guard: prevent resident from accessing /admin/* etc.
  return null;
}
```

---

## 🔌 API Integration Layer

### Backend Endpoint Alignment

Every remote datasource must map **exactly** to the backend endpoints defined in `backend_prompt.md`. The request/response models must mirror the backend DTOs field-for-field.

### DioClient Setup (`core/network/`)

```
core/network/
├── dio_client.dart           # Configured Dio instance with base URL, timeouts
├── auth_interceptor.dart     # Attaches Firebase ID token to every request
├── logging_interceptor.dart  # Logs requests/responses in debug mode
├── error_interceptor.dart    # Converts DioError to Failure objects
└── api_response_model.dart   # Maps backend ApiResponse<T> wrapper
```

### ApiResponseModel

```dart
class ApiResponseModel<T> {
  final bool success;
  final String? message;
  final T? data;
  final DateTime timestamp;

  // fromJson with generic deserializer
}
```

### Remote Datasource Documentation

Every datasource method must document the endpoint it maps to:

```dart
/// POST /api/v1/auth/register
Future<UserModel> register(RegisterRequestModel request);

/// GET /api/v1/visitors?page={page}&size={size}
Future<PaginatedResponse<VisitorModel>> getVisitors({int page, int size});
```

---

## 🏗️ Implementation Order

Build features in this sequence:

| Phase | Features | Reason |
|---|---|---|
| **Phase 0** | Project setup, `core/` infrastructure (DioClient, interceptors, Firebase init, error handling), `design_system/` tokens, `shared/` widgets (AppButton, AppTextField, AppLoader, AppSnackbar, AppErrorWidget) | Foundation |
| **Phase 1** | Auth feature (Splash, Login, Register, ForgotPassword, OTP) + root routing with role-based redirect | Must authenticate before anything else |
| **Phase 2** | Resident Home + Guard Home + Admin Home (shell routes with bottom nav/drawer) | Role-specific shells |
| **Phase 3** | Gate & Visitor Management (all resident + guard screens) | Flagship feature |
| **Phase 4** | Daily Help Management | Closely tied to gate module |
| **Phase 5** | Guard Patrolling + Emergency & Panic | Security layer |
| **Phase 6** | Community Communications (Notices, Polls, Groups, Documents) | Community engagement |
| **Phase 7** | Amenity Booking | Facility management |
| **Phase 8** | Digital Helpdesk | Complaint management |
| **Phase 9** | Vehicle & Parking, Material Gatepass | Gate ancillary features |
| **Phase 10** | Pet Directory, Marketplace | Lifestyle features |
| **Phase 11** | Admin Dashboard (stats, reports, charts) | Aggregates all feature data |
| **Phase 12** | Polish: dark mode validation, accessibility audit, performance optimization, widget tests | Quality assurance |

---

## 🔒 Cross-Cutting Concerns Checklist

Before marking any feature/screen as complete, verify:

- [ ] Figma design exists in `figma/` folder for the screen.
- [ ] Screen handles all 3 UI states: loading (shimmer/skeleton), success, error (with retry).
- [ ] Dark mode renders correctly.
- [ ] No inline styles — all colours from `AppColors`, typography from `AppTypography`, spacing from `AppSpacing`.
- [ ] No business logic in screens or widgets — only in BLoC/Cubit via UseCase.
- [ ] All forms use `Form` + `GlobalKey<FormState>` with shared `AppTextField` and validators from `core/utils/validators.dart`.
- [ ] All list screens use `ListView.builder` with pagination (infinite scroll).
- [ ] All images use `CachedNetworkImage`.
- [ ] `BlocProvider` is set at the route level, not inside widgets.
- [ ] `Either<Failure, T>` is the return type of all repository and use case methods.
- [ ] No `FirebaseAuth.instance` calls outside `core/firebase/auth_service.dart`.
- [ ] No raw `Dio` or `http` calls — always through configured `DioClient`.
- [ ] Navigation uses `go_router` with route constants — no `Navigator.push` with `MaterialPageRoute`.
- [ ] Minimum 48×48dp tap targets on all interactive elements.
- [ ] `Semantics` labels on all interactive widgets.
- [ ] Request/response models match backend DTOs exactly.
- [ ] `const` constructors used wherever possible.
- [ ] Screen wrapped in `SafeArea` unless explicitly bleeding into notch.

---

## 📝 Output Summary

When you finish, the workspace must contain:

```
figma/
├── 00_design_system/           (colours, typography, spacing, components, icons)
├── 01_auth/                    (splash, login, register, forgot password, OTP)
├── 02_resident/                (all resident screens)
├── 03_guard/                   (all guard screens)
├── 04_admin/                   (all admin screens)
└── 05_shared_states/           (loading, empty, error, dark mode variants)

frontend/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── core/
│   │   ├── config/             (env config, app_router.dart)
│   │   ├── network/            (dio_client, interceptors, api_response_model)
│   │   ├── firebase/           (firebase_init, auth_service)
│   │   ├── error/              (failure classes)
│   │   ├── storage/            (secure storage, shared prefs wrapper)
│   │   └── utils/              (validators, formatters, extensions)
│   ├── design_system/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   ├── app_shadows.dart
│   │   └── app_theme.dart
│   ├── shared/
│   │   ├── widgets/            (AppButton, AppTextField, AppLoader, etc.)
│   │   └── models/             (shared data models)
│   ├── features/
│   │   ├── auth/               (data, domain, presentation)
│   │   ├── visitor/            (data, domain, presentation)
│   │   ├── dailyhelp/          (data, domain, presentation)
│   │   ├── guard/              (data, domain, presentation)
│   │   ├── communication/      (data, domain, presentation)
│   │   ├── amenity/            (data, domain, presentation)
│   │   ├── helpdesk/           (data, domain, presentation)
│   │   ├── vehicle/            (data, domain, presentation)
│   │   ├── material/           (data, domain, presentation)
│   │   ├── emergency/          (data, domain, presentation)
│   │   ├── pet/                (data, domain, presentation)
│   │   ├── marketplace/        (data, domain, presentation)
│   │   └── dashboard/          (data, domain, presentation)
│   └── injection.dart          (get_it + injectable setup)
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── animations/
├── test/
│   └── features/               (mirrors lib/features)
└── pubspec.yaml
```

---

## ⚠️ Critical Reminders

1. **Read `frontend_rules.md` first** — it is the non-negotiable architectural law.
2. **Read `features.md`** — it defines every feature to be built.
3. **Design in Figma first, then code** — every screen gets a Figma frame before Flutter implementation.
4. **Never skip architecture layers** — Screen → BLoC → UseCase → Repository → DataSource.
5. **Never put business logic in widgets or screens** — BLoC/Cubit only.
6. **Never use inline styles** — always reference design system tokens.
7. **Never call Firebase directly from features** — go through `core/firebase/`.
8. **Never call APIs from BLoCs directly** — go through UseCases → Repositories → DataSources.
9. **Always handle loading, success, and error states** — no screen may be left without all three.
10. **Always paginate list screens** — infinite scroll with backend pagination params.
11. **Always support dark mode** — test every screen in both themes.
12. **Always match backend DTOs exactly** — field names, types, nullability must align with `backend_prompt.md`.
