# MyGuard — Gated Community Management Platform

A full-stack gated-community management application (similar to MyGate) built with **Flutter** (frontend) and **Spring Boot** (backend), using **Firebase Auth** for authentication and **Firestore** as the database.

## Tech Stack

| Layer | Technology |
|-------|-----------|
| **Frontend** | Flutter 3.x, Dart 3.x |
| **Backend** | Spring Boot 3.x, Java 21 |
| **Auth** | Firebase Authentication |
| **Database** | Google Cloud Firestore |
| **State Management** | flutter_bloc (BLoC + Cubit) |
| **Navigation** | go_router |
| **HTTP Client** | Dio (Flutter) |
| **DI** | get_it |
| **Architecture** | Clean Architecture (Feature-First) |

## Project Structure

```
myguard/
├── backend/                    # Spring Boot REST API
│   ├── src/main/java/com/myguard/
│   │   ├── auth/               # Authentication & user management
│   │   ├── visitor/            # Gate & visitor management
│   │   ├── dailyhelp/          # Daily help (maids, cooks, etc.)
│   │   ├── guard/              # Guard management & patrolling
│   │   ├── communication/      # Notices, polls, groups, documents
│   │   ├── amenity/            # Amenity booking
│   │   ├── helpdesk/           # Digital helpdesk / complaints
│   │   ├── vehicle/            # Vehicle & parking management
│   │   ├── material/           # Material gatepass
│   │   ├── emergency/          # Panic alerts & emergency contacts
│   │   ├── pet/                # Pet directory
│   │   ├── marketplace/        # P2P marketplace
│   │   ├── society/            # Society & flat management
│   │   ├── dashboard/          # Admin dashboard & reports
│   │   └── common/             # Shared config, filters, responses
│   └── pom.xml
├── frontend/                   # Flutter mobile app
│   ├── lib/
│   │   ├── core/               # DioClient, interceptors, config, utils
│   │   ├── design_system/      # AppColors, AppTypography, AppTheme
│   │   ├── shared/             # Reusable widgets (AppButton, AppTextField, etc.)
│   │   ├── features/           # Feature-first modules (14 features)
│   │   ├── injection.dart      # get_it dependency injection
│   │   ├── app.dart            # Root MaterialApp + Router
│   │   └── main.dart           # Entry point
│   └── pubspec.yaml
├── figma/                      # Design specifications per screen
└── README.md
```

## Features (14 Modules)

| # | Feature | Resident | Guard | Admin |
|---|---------|----------|-------|-------|
| 1 | **Authentication** | Login, Register, OTP | Login | Login, User Management |
| 2 | **Gate & Visitors** | Pre-approve, Guest invite, History | Log entry/exit, QR scan, Group entry | Visitor reports |
| 3 | **Daily Help** | Register, View attendance | Check-in/out | — |
| 4 | **Guard & Patrol** | — | Patrol checkpoints, E-intercom | Guard management, Shifts, Reports |
| 5 | **Communications** | Notices, Polls, Groups | Notices | Create notices/polls, Manage groups |
| 6 | **Amenity Booking** | Browse, Book, My bookings | Check-in/out | Manage amenities, Bookings |
| 7 | **Digital Helpdesk** | Create/track tickets | — | Manage tickets, Reports |
| 8 | **Vehicle & Parking** | Register vehicles | Vehicle lookup, Log | Parking management |
| 9 | **Material Gatepass** | Create gatepass | Verify at gate | Approve/reject |
| 10 | **Emergency** | Panic button, Contacts | Panic alerts | Manage contacts |
| 11 | **Pet Directory** | Register pets, Vaccinations | — | — |
| 12 | **Marketplace** | Buy/sell listings | — | — |
| 13 | **Society Management** | — | — | Society, Flats, Users, Move in/out |
| 14 | **Dashboard** | — | — | Stats, Reports, Charts |

## Roles

- **Resident** — Home dashboard, gate management, services, community, profile
- **Security Guard** — Gate entry/exit, patrol, alerts, quick actions
- **Admin** — Dashboard with stats, management panels, reports

## Getting Started

### Prerequisites

- Flutter SDK 3.x
- Java 21
- Android Studio / VS Code
- Firebase project with Auth + Firestore enabled

### Backend Setup

```bash
cd backend
# Add firebase-service-account.json to backend/
mvn spring-boot:run
```

### Frontend Setup

```bash
cd frontend
flutter pub get
flutterfire configure --project=<your-firebase-project-id>
flutter run
```

### Environment Configuration

- Backend API base URL is configured in `frontend/lib/core/config/env_config.dart`
- Default: `http://10.0.2.2:8080` (Android emulator → localhost)
- Pass custom URL: `flutter run --dart-define=API_BASE_URL=http://your-server:8080`

## API Endpoints

All endpoints are prefixed with `/api/v1/` and wrapped in `ApiResponse<T>`:

```json
{
  "success": true,
  "message": "...",
  "data": { ... },
  "timestamp": "2026-04-12T..."
}
```

Paginated responses use `PaginatedResponse<T>`:

```json
{
  "content": [...],
  "page": 0,
  "size": 20,
  "totalElements": 100,
  "totalPages": 5,
  "hasNext": true,
  "hasPrevious": false
}
```

## Architecture

### Frontend — Clean Architecture (Feature-First)

```
Screen → BLoC/Cubit → UseCase → Repository (Interface) → RepositoryImpl → RemoteDatasource → API
```

- **Presentation**: Screens, Widgets, BLoC/Cubit
- **Domain**: Entities, Repository interfaces, UseCases
- **Data**: Models (DTOs), Remote datasources, Repository implementations

### Backend — Layered Architecture

```
Controller → Service → Repository → Firestore
```

- Role-based access via `@PreAuthorize`
- Firebase token validation via `FirebaseTokenFilter`
- Global exception handling via `GlobalExceptionHandler`

## Design System

| Token | Light | Dark |
|-------|-------|------|
| Primary | `#1A73E8` | `#4A9AF5` |
| Secondary | `#34A853` | `#5CBC6E` |
| Error | `#D93025` | `#D93025` |
| Surface | `#F8F9FA` | `#1E1E1E` |
| Background | `#FFFFFF` | `#121212` |

Typography: Inter font family, 12 text styles from displayLarge to labelSmall.

## License

Private project — not for public distribution.
