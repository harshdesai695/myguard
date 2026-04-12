# MyGuard Frontend — Rules & Standards

> **Stack:** Flutter · Firebase Auth · Dart  
> **Design Reference:** Mobbin · Lapa Ninja · v0 Templates  
> **Backend Contract:** `backend_details.md`  
> **Output Folder:** `frontend/`

---

## Table of Contents

1. [Project Structure](#1-project-structure)
2. [Package & Naming Conventions](#2-package--naming-conventions)
3. [Architecture Rules — Feature-First + Clean Layers](#3-architecture-rules--feature-first--clean-layers)
4. [Screen & Widget Rules](#4-screen--widget-rules)
5. [State Management Rules](#5-state-management-rules)
6. [Navigation Rules](#6-navigation-rules)
7. [API Integration Rules](#7-api-integration-rules)
8. [Firebase Auth Rules](#8-firebase-auth-rules)
9. [Design System Rules](#9-design-system-rules)
10. [Figma-to-Code Rules](#10-figma-to-code-rules)
11. [Form & Validation Rules](#11-form--validation-rules)
12. [Error Handling & Feedback Rules](#12-error-handling--feedback-rules)
13. [Performance Rules](#13-performance-rules)
14. [Accessibility Rules](#14-accessibility-rules)
15. [Testing Rules](#15-testing-rules)
16. [Code Quality Rules](#16-code-quality-rules)

---

## 1. Project Structure

```
frontend/
├── lib/
│   ├── main.dart
│   ├── app.dart                        # Root MaterialApp / routing setup
│   ├── core/                           # App-wide shared infrastructure
│   │   ├── config/                     # Environment config, constants
│   │   ├── network/                    # Dio/HTTP client, interceptors
│   │   ├── firebase/                   # Firebase init, auth service wrapper
│   │   ├── error/                      # Failure classes, error handling
│   │   ├── storage/                    # Secure storage, shared prefs wrapper
│   │   └── utils/                      # Validators, formatters, extensions
│   ├── design_system/                  # Global design tokens — ONE source of truth
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   ├── app_shadows.dart
│   │   └── app_theme.dart
│   ├── shared/                         # Reusable widgets used across features
│   │   ├── widgets/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_loader.dart
│   │   │   ├── app_error_widget.dart
│   │   │   └── app_snackbar.dart
│   │   └── models/                     # Shared data models (ApiResponse, etc.)
│   └── features/
│       └── <feature>/                  # One folder per feature
│           ├── data/
│           │   ├── models/             # Request/Response models (DTOs)
│           │   ├── datasources/        # Remote datasource (API calls)
│           │   └── repositories/      # Repository implementation
│           ├── domain/
│           │   ├── entities/           # Pure Dart domain models
│           │   ├── repositories/      # Repository abstract interface
│           │   └── usecases/           # One file per use case
│           └── presentation/
│               ├── screens/            # Full screens
│               ├── widgets/            # Feature-specific widgets
│               ├── bloc/ or provider/  # State management files
│               └── <feature>_routes.dart
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── animations/                     # Lottie files
├── test/
│   └── features/                       # Mirrors lib/features structure
└── pubspec.yaml
```

### Rules

- ✅ Every feature is **fully self-contained** inside `lib/features/<feature>/`.
- ✅ Shared reusable widgets live **only** in `lib/shared/widgets/`.
- ✅ Design tokens (colors, fonts, spacing) live **only** in `lib/design_system/`.
- ❌ Features must **never** import widgets or business logic from another feature — go through `shared/` only.
- ❌ No inline styles, hardcoded colors, or font sizes anywhere — always reference `design_system`.

---

## 2. Package & Naming Conventions

### File Naming

All files use **snake_case**.

| Type | Convention | Example |
|---|---|---|
| Screen | `<name>_screen.dart` | `login_screen.dart` |
| Widget | `<name>_widget.dart` | `profile_card_widget.dart` |
| Bloc | `<name>_bloc.dart` | `auth_bloc.dart` |
| Cubit | `<name>_cubit.dart` | `auth_cubit.dart` |
| State | `<name>_state.dart` | `auth_state.dart` |
| Event | `<name>_event.dart` | `auth_event.dart` |
| Use Case | `<action>_<feature>_usecase.dart` | `login_auth_usecase.dart` |
| Repository Interface | `<feature>_repository.dart` | `auth_repository.dart` |
| Repository Impl | `<feature>_repository_impl.dart` | `auth_repository_impl.dart` |
| Remote Datasource | `<feature>_remote_datasource.dart` | `auth_remote_datasource.dart` |
| Model (DTO) | `<name>_model.dart` | `login_request_model.dart` |
| Entity | `<name>_entity.dart` | `user_entity.dart` |
| Route file | `<feature>_routes.dart` | `auth_routes.dart` |

### Class Naming

| Type | Convention | Example |
|---|---|---|
| Screen | `<Name>Screen` | `LoginScreen` |
| Widget | `<Name>Widget` | `ProfileCardWidget` |
| Bloc | `<Name>Bloc` | `AuthBloc` |
| Cubit | `<Name>Cubit` | `AuthCubit` |
| State | `<Name>State` | `AuthState` |
| Event | `<Name>Event` | `AuthEvent` |
| Use Case | `<Action><Name>UseCase` | `LoginAuthUseCase` |
| Repository Interface | `<Name>Repository` | `AuthRepository` |
| Repository Impl | `<Name>RepositoryImpl` | `AuthRepositoryImpl` |
| DTO / Model | `<Name>Model` | `LoginRequestModel` |
| Entity | `<Name>Entity` | `UserEntity` |

### Rules

- ✅ Use **exact** conventions above — no abbreviations.
- ✅ Use `lowerCamelCase` for variables, `UpperCamelCase` for classes, `SCREAMING_SNAKE_CASE` for constants.
- ❌ No `page` suffix for screens — always `screen`.
- ❌ No `view` suffix — always `screen` or `widget`.

---

## 3. Architecture Rules — Feature-First + Clean Layers

```
Presentation → Domain → Data
Screen → Bloc/Cubit → UseCase → Repository (Interface) → RepositoryImpl → RemoteDatasource → API
```

- ✅ **Presentation** layer knows only **Domain** interfaces (via dependency injection).
- ✅ **Domain** layer is pure Dart — zero Flutter/Firebase/Dio imports.
- ✅ **Data** layer implements Domain interfaces and handles all API/Firebase calls.
- ✅ Dependency injection is handled through a DI container (e.g., `get_it` + `injectable`).
- ❌ Screens must **never** call repositories or datasources directly.
- ❌ Domain entities must **never** contain `fromJson`/`toJson` — that belongs in Data models.
- ❌ No business logic in widgets or screens — Bloc/Cubit only.
- ❌ No `BuildContext` in Bloc/Cubit/UseCase — only in the Presentation layer.

---

## 4. Screen & Widget Rules

### Screen Rules

- ✅ Screens are responsible only for layout, `BlocBuilder`/`BlocListener`, and routing.
- ✅ Every screen must handle all 3 UI states: **loading**, **success**, **error**.
- ✅ All screens must be wrapped with `SafeArea` unless explicitly designed to bleed into the notch.
- ✅ Each screen has its own route constant defined in `<feature>_routes.dart`.
- ❌ No API calls, business logic, or state management logic directly inside screens.
- ❌ No anonymous or inline `TextStyle`, `Color`, `EdgeInsets` — always reference design tokens.

### Widget Rules

- ✅ Widgets must be **small and single-purpose** — a widget that exceeds ~80 lines should be split.
- ✅ Extract repeated UI patterns into `shared/widgets/` with clear, generic interfaces.
- ✅ Use `const` constructors wherever possible.
- ✅ Stateful widgets are only used when local ephemeral state is needed (e.g., animation tickers, text controllers).
- ✅ All text must use `AppTypography` text styles, never raw `TextStyle`.
- ❌ No `StatefulWidget` when a `StatelessWidget` + `BlocBuilder` is sufficient.
- ❌ Widgets must never directly access `GetIt` / service locator — receive via constructor.

```dart
// ✅ Correct — const, uses design tokens, accepts props
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  // ...
}
```

---

## 5. State Management Rules

> **Recommended:** `flutter_bloc` (Bloc or Cubit)

### Cubit vs Bloc

| Use Cubit for | Use Bloc for |
|---|---|
| Simple state (loading/success/error) | Complex event-driven flows |
| Single-screen local state | Cross-screen or multi-step state |
| Toggle, counter, form state | Auth flows, multi-step forms, real-time |

### Rules

- ✅ Every feature has its own dedicated Bloc/Cubit — no shared Blocs between unrelated features.
- ✅ States must be **sealed classes** or `Equatable` subclasses covering: `Initial`, `Loading`, `Success`, `Failure`.
- ✅ `BlocProvider` is set at the route level, not inside widgets.
- ✅ Use `BlocListener` for side effects (navigation, snackbars, dialogs).
- ✅ Use `BlocBuilder` only for UI rebuilds based on state.
- ✅ Use `BlocConsumer` when a screen needs both build + listen.
- ❌ No `setState` for business data — use Bloc/Cubit.
- ❌ Blocs must never directly reference other Blocs.
- ❌ No logic in state classes — they are pure data containers.

```dart
// ✅ Correct sealed state
sealed class AuthState extends Equatable {
  const AuthState();
}
class AuthInitial extends AuthState { ... }
class AuthLoading extends AuthState { ... }
class AuthSuccess extends AuthState {
  const AuthSuccess(this.user);
  final UserEntity user;
  @override List<Object> get props => [user];
}
class AuthFailure extends AuthState {
  const AuthFailure(this.message);
  final String message;
  @override List<Object> get props => [message];
}
```

---

## 6. Navigation Rules

> **Recommended:** `go_router`

- ✅ All routes are defined in a **central router file** (`app_router.dart`) under `core/config/`.
- ✅ Each feature exports its route constants in `<feature>_routes.dart`.
- ✅ Use **named routes** for all navigation — no anonymous `MaterialPageRoute`.
- ✅ Pass data through route `extra` or path/query params — never through global state.
- ✅ Authenticated routes are guarded with a `GoRouter` redirect using the auth state.
- ✅ Deep linking must be defined from the start, even if unused initially.
- ❌ No `Navigator.push` with raw `MaterialPageRoute` — use `context.go()` or `context.push()`.
- ❌ No hardcoded route strings in screens — always use route constants.
- ❌ No `BuildContext` passed across async gaps — check `mounted` before using.

```dart
// ✅ Route constants
class AuthRoutes {
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const forgotPassword = '/auth/forgot-password';
}
```

---

## 7. API Integration Rules

> **Recommended:** `dio` with interceptors

### HTTP Client Setup

- ✅ One `DioClient` configured in `core/network/` with base URL, headers, and timeouts.
- ✅ An **AuthInterceptor** automatically attaches the Firebase ID token to every request.
- ✅ A **LoggingInterceptor** logs requests/responses in debug mode only.
- ✅ A **ErrorInterceptor** converts HTTP errors to typed `Failure` objects.
- ✅ All API responses map to `ApiResponseModel<T>` matching the backend's `ApiResponse<T>` wrapper.
- ❌ No raw `http` package — always use the configured `DioClient`.
- ❌ No API calls in Blocs/Cubits — only through `UseCase → Repository → DataSource`.
- ❌ No hardcoded base URLs — use environment config from `core/config/`.

### Backend Endpoint Alignment

- ✅ Every remote datasource method maps **exactly** to a backend endpoint in `backend_details.md`.
- ✅ Request model field names must match the backend's request DTO field names exactly.
- ✅ Response model field names must match the backend's response DTO field names exactly.
- ✅ Document each datasource method with the endpoint it calls:
  ```dart
  /// POST /api/v1/auth/login
  Future<LoginResponseModel> login(LoginRequestModel request);
  ```
- ❌ Never assume a field is optional — check `backend_details.md` for nullability.

---

## 8. Firebase Auth Rules

- ✅ Firebase Auth operations are wrapped in `core/firebase/auth_service.dart` — never called raw from features.
- ✅ Firebase ID tokens must be **refreshed automatically** via the `AuthInterceptor` before every API call.
- ✅ Token persistence is handled by Firebase SDK — never store tokens manually in SharedPreferences.
- ✅ Auth state changes are listened to via a `StreamSubscription` in the root `AuthBloc`.
- ✅ On sign-out, clear all local caches (SharedPreferences, secure storage, in-memory state).
- ❌ No `FirebaseAuth.instance` calls outside of `core/firebase/`.
- ❌ Never log or store Firebase ID tokens.
- ❌ No direct Firebase imports in feature-level files.

---

## 9. Design System Rules

### Design Tokens

All visual values are defined once in `lib/design_system/` and referenced everywhere else.

```dart
// ✅ app_colors.dart
class AppColors {
  static const primary    = Color(0xFF1A73E8);
  static const onPrimary  = Color(0xFFFFFFFF);
  static const surface    = Color(0xFFF8F9FA);
  static const error      = Color(0xFFD93025);
  // ... semantic names, never raw hex inline
}

// ✅ app_spacing.dart
class AppSpacing {
  static const xs  = 4.0;
  static const sm  = 8.0;
  static const md  = 16.0;
  static const lg  = 24.0;
  static const xl  = 32.0;
  static const xxl = 48.0;
}

// ✅ app_typography.dart
class AppTypography {
  static const headingLarge = TextStyle(fontSize: 28, fontWeight: FontWeight.w700);
  static const bodyMedium   = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  // ...
}
```

### Rules

- ✅ Dark mode must be supported from the start — use `ThemeData` with semantic color roles.
- ✅ Font family must be declared in `pubspec.yaml` and loaded from `assets/fonts/`.
- ✅ All corner radii use `AppRadius` constants, never hardcoded doubles.
- ✅ All spacing uses `AppSpacing` constants, never hardcoded numbers.
- ❌ No inline `Color(0xFF...)` in widgets — always `AppColors.<name>`.
- ❌ No raw `TextStyle(fontSize: ...)` in widgets — always `AppTypography.<style>`.
- ❌ No hardcoded `EdgeInsets.all(16)` — always `EdgeInsets.all(AppSpacing.md)`.

---

## 10. Figma-to-Code Rules

> Design references: Mobbin (mobile patterns), Lapa Ninja (visual inspiration), v0 Templates (component patterns)

### Design Principles to Follow

- ✅ **Mobile-first layout** — design for 375px width minimum, test at 320px.
- ✅ **Consistent visual hierarchy** — heading → subheading → body → caption, no skipping levels.
- ✅ **Generous whitespace** — use Mobbin-style spacing; content should breathe.
- ✅ **Clear primary CTA** — every screen has one visually dominant action button.
- ✅ **Modern card-based UI** — group related content in elevated or outlined cards with consistent radius.
- ✅ **Bottom-safe navigation** — all interactive elements must be reachable by thumb (bottom 60% of screen).

### Figma Frame Requirements

Every screen frame in Figma must include:

| Element | Requirement |
|---|---|
| Frame size | 390 × 844 (iPhone 14 base) |
| Status bar | Included as component |
| Safe area | Top and bottom insets marked |
| Navigation bar | Consistent across all screens |
| Loading state | Skeleton or shimmer variant |
| Empty state | Illustration + message + CTA |
| Error state | Error message + retry CTA |
| Dark mode | Required for all screens |

### Figma → Flutter Translation Rules

- ✅ Each Figma **frame** maps to one Flutter **Screen** (`_screen.dart`).
- ✅ Each Figma **component** maps to one Flutter **Widget** (`_widget.dart`).
- ✅ Figma **auto-layout** → Flutter `Column`, `Row`, or `Flex` with `MainAxisAlignment` / spacing.
- ✅ Figma **color styles** → `AppColors` constants.
- ✅ Figma **text styles** → `AppTypography` constants.
- ✅ Figma **spacing tokens** → `AppSpacing` constants.
- ✅ Figma **border radius** → `AppRadius` constants.
- ❌ Do not use `Stack` as a layout default — only for deliberate overlapping elements.
- ❌ Do not hardcode pixel values from Figma directly — map to nearest design token.

---

## 11. Form & Validation Rules

- ✅ All forms use `Form` widget with a `GlobalKey<FormState>`.
- ✅ All text inputs use the shared `AppTextField` widget with consistent styling.
- ✅ Validation logic lives in `core/utils/validators.dart` — never inline in widgets.
- ✅ Show validation errors inline below each field, not via snackbar.
- ✅ Disable the submit button when the form is in a loading state.
- ✅ Use `TextInputAction` to chain fields (`next` → `next` → `done`).
- ✅ Use `TextInputType` appropriate to each field (`emailAddress`, `phone`, `number`, etc.).
- ✅ Mask password fields and provide a show/hide toggle.
- ❌ No validation logic duplicated across screens — always use shared validators.
- ❌ Never clear a field on validation error — preserve user input.
- ❌ No form submission when any required field is empty — validate before calling Bloc event.

---

## 12. Error Handling & Feedback Rules

### Failure Types

```dart
sealed class Failure {
  const Failure(this.message);
  final String message;
}
class NetworkFailure extends Failure { ... }     // No internet
class ServerFailure extends Failure { ... }      // 5xx errors
class UnauthorizedFailure extends Failure { ... } // 401
class NotFoundFailure extends Failure { ... }    // 404
class ValidationFailure extends Failure { ... }  // 400
class UnknownFailure extends Failure { ... }     // Unexpected
```

### Rules

- ✅ Use `Either<Failure, T>` (from `dartz` or `fpdart`) as the return type of all repository and use case methods.
- ✅ Map backend `ErrorResponse.code` to the correct `Failure` subclass in the error interceptor.
- ✅ Show **snackbars** for brief non-blocking errors (network timeout, generic server error).
- ✅ Show **inline error widgets** for screen-level failures (empty list, failed fetch).
- ✅ Show **dialog** only for destructive or irreversible action confirmations.
- ✅ All error messages must be **user-friendly** — never expose raw API error strings.
- ✅ Provide a **retry** option for all network-related failures.
- ❌ No `try-catch` blocks in Blocs/Cubits — errors are already wrapped as `Failure` from repositories.
- ❌ No stack traces or technical details shown in the UI.

---

## 13. Performance Rules

- ✅ Use `const` constructors on all widgets that don't depend on runtime data.
- ✅ Use `ListView.builder` / `SliverList` for all lists — never `Column` with a mapped list for variable-length data.
- ✅ Paginate all lists — implement infinite scroll aligned with backend pagination parameters.
- ✅ Use `CachedNetworkImage` for all remote images — never raw `Image.network`.
- ✅ Debounce search input by at least 300ms before triggering API calls.
- ✅ Lazy-load feature modules using deferred imports where applicable.
- ✅ Use `RepaintBoundary` around complex animated or frequently-rebuilt widgets.
- ❌ No `setState` calls on large widget trees — keep state as local as possible.
- ❌ No synchronous heavy computation on the main thread — use `compute()` for CPU-intensive work.
- ❌ No `Future.wait` inside `build()` methods.
- ❌ No unbounded image sizes — always specify `width`/`height` or constrain via layout.

---

## 14. Accessibility Rules

- ✅ All interactive widgets must have a `Semantics` label or use `Tooltip`.
- ✅ Minimum tap target size: **48×48 dp** for all buttons and touchable elements.
- ✅ Color must **never** be the sole indicator of state — use icon + color, or text + color.
- ✅ All images must have a meaningful `semanticLabel` or be marked `excludeFromSemantics: true` if decorative.
- ✅ Text must scale correctly — test with system font size at 1.5× and 2×.
- ✅ Sufficient color contrast — minimum **4.5:1** for normal text, **3:1** for large text (WCAG AA).
- ✅ Loading states must announce progress to screen readers via `Semantics`.
- ❌ No text in images — always use actual Flutter `Text` widgets for readability.

---

## 15. Testing Rules

### Coverage Requirements

| Layer | Test Type | Tool |
|---|---|---|
| Use Cases | Unit Test | `flutter_test` + `mocktail` |
| Repository Impl | Unit Test | `mocktail` (mock datasource) |
| Bloc / Cubit | Unit Test | `bloc_test` |
| Screens | Widget Test | `flutter_test` + `MockBloc` |
| Critical flows | Integration Test | `integration_test` |

### Rules

- ✅ Every `UseCase` must have unit tests covering success and failure paths.
- ✅ Every Bloc/Cubit must be tested with `bloc_test` covering all events and state transitions.
- ✅ Widget tests must test: initial render, loading state, success state, error state.
- ✅ Test files must mirror the source structure under `test/`.
- ✅ Test naming: `methodName_scenario_expectedResult`.
- ✅ Use `mocktail` for all mocking — never hand-written stubs.
- ❌ No real API calls or Firebase calls in any tests — always mock at the datasource level.
- ❌ No shared mutable state between test cases — always reset in `setUp`/`tearDown`.

---

## 16. Code Quality Rules

### Dart / Flutter Specific

- ✅ Enable **strict mode** in `analysis_options.yaml`:
  ```yaml
  analyzer:
    strong-mode:
      implicit-casts: false
      implicit-dynamic: false
  ```
- ✅ Run `flutter analyze` and `dart fix` before every commit.
- ✅ Use `flutter_lints` or `very_good_analysis` lint rules.
- ✅ Prefer `final` over `var` for all variables that are not reassigned.
- ✅ Prefer named parameters for constructors with more than 2 parameters.
- ✅ Use `extension` methods for utility functions on existing classes instead of top-level functions.
- ❌ No `dynamic` types — always specify explicit types.
- ❌ No `print()` — use `debugPrint()` in dev, or a proper logging package.
- ❌ No commented-out code committed to the repo.
- ❌ No `!` null assertion without a justified comment explaining why it's safe.

### Dependency Management

- ✅ Pin all dependency versions in `pubspec.yaml` — no unbounded `^` in production.
- ✅ Review and remove unused packages before each release.
- ✅ Document the purpose of any non-obvious package with a comment in `pubspec.yaml`.

### Environment Config

- ✅ Use `.env` files or `--dart-define` for environment-specific values (API base URL, Firebase project ID).
- ✅ Separate config for `dev`, `staging`, `prod` environments.
- ❌ No hardcoded API URLs, Firebase config values, or secrets in source code.
- ❌ No `google-services.json` or `GoogleService-Info.plist` committed to public repos — use CI secrets.

---

## Quick Reference Checklist

Before raising a PR, verify:

- [ ] Feature is self-contained in `lib/features/<feature>/`
- [ ] All 3 layers present: `data/`, `domain/`, `presentation/`
- [ ] No direct API/Firebase calls outside `data/datasources/`
- [ ] All states handled: loading, success, error
- [ ] No inline colors, font sizes, or spacing — design tokens used throughout
- [ ] Every screen has a loading state and error state
- [ ] Form validation uses shared validators
- [ ] All routes use named constants
- [ ] `const` constructors used wherever applicable
- [ ] `ListView.builder` used for all lists
- [ ] All remote images use `CachedNetworkImage`
- [ ] No `print()` — `debugPrint()` only
- [ ] Unit tests written for use cases and Bloc/Cubit
- [ ] No hardcoded secrets or API keys in source
- [ ] `flutter analyze` passes with zero issues
- [ ] Dark mode verified on at least one screen
- [ ] Tap targets ≥ 48×48 dp on all interactive elements