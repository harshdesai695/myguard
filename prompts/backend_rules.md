# MyGuard Backend — Rules & Standards

> **Stack:** Spring Boot · Firebase (Auth + Firestore) · Java  
> **Pattern:** MVC — Controller → Service → Repository  
> **Base Package:** `com.myguard.<functionality>`

---

## Table of Contents

1. [Project Structure](#1-project-structure)
2. [Package & Naming Conventions](#2-package--naming-conventions)
3. [Layered Architecture Rules](#3-layered-architecture-rules)
4. [Controller Rules](#4-controller-rules)
5. [Service Rules](#5-service-rules)
6. [Repository Rules](#6-repository-rules)
7. [Entity & DTO Rules](#7-entity--dto-rules)
8. [Firebase Rules](#8-firebase-rules)
9. [Security Rules](#9-security-rules)
10. [Error Handling Rules](#10-error-handling-rules)
11. [API Design Rules](#11-api-design-rules)
12. [Logging Rules](#12-logging-rules)
13. [Testing Rules](#13-testing-rules)
14. [Configuration Rules](#14-configuration-rules)
15. [Code Quality Rules](#15-code-quality-rules)

---

## 1. Project Structure

```
backend/
├── src/main/java/com/myguard/
│   ├── common/                         # Shared utilities, base classes, global config
│   │   ├── config/
│   │   ├── exception/
│   │   ├── filter/
│   │   ├── response/
│   │   └── constants/
│   ├── <feature>/                      # One package per feature
│   │   ├── controller/
│   │   ├── service/
│   │   │   ├── <Feature>Service.java           # Interface
│   │   │   └── <Feature>ServiceImpl.java       # Implementation
│   │   ├── repository/
│   │   │   ├── <Feature>Repository.java        # Interface
│   │   │   └── <Feature>RepositoryImpl.java    # Implementation
│   │   ├── view/                               # Entities / Firestore models
│   │   └── dto/
│   │       ├── request/
│   │       └── response/
│   └── MyGuardApplication.java
├── src/main/resources/
│   ├── application.yml
│   ├── application-dev.yml
│   ├── application-staging.yml
│   └── application-prod.yml
└── src/test/java/com/myguard/
    └── <feature>/                      # Mirrors source structure
```

### Rules

- ✅ Every feature is **fully self-contained** in its own package.
- ✅ Shared/cross-cutting code goes **only** in `com.myguard.common`.
- ❌ Features must **never import classes from another feature package** directly.
- ❌ No orphan classes — every class must belong to a feature or `common`.

---

## 2. Package & Naming Conventions

### Package Pattern

```
com.myguard.<feature>.<layer>
```

| Layer | Example Package |
|---|---|
| Controller | `com.myguard.auth.controller` |
| Service Interface | `com.myguard.auth.service` |
| Service Impl | `com.myguard.auth.service` |
| Repository Interface | `com.myguard.auth.repository` |
| Repository Impl | `com.myguard.auth.repository` |
| Entity/View | `com.myguard.auth.view` |
| Request DTO | `com.myguard.auth.dto.request` |
| Response DTO | `com.myguard.auth.dto.response` |

### Class Naming Pattern

| Type | Convention | Example |
|---|---|---|
| Controller | `<Feature>Controller` | `AuthController` |
| Service Interface | `<Feature>Service` | `AuthService` |
| Service Impl | `<Feature>ServiceImpl` | `AuthServiceImpl` |
| Repository Interface | `<Feature>Repository` | `AuthRepository` |
| Repository Impl | `<Feature>RepositoryImpl` | `AuthRepositoryImpl` |
| Entity | `<Feature>Entity` | `UserEntity` |
| Request DTO | `<Action><Feature>Request` | `LoginAuthRequest` |
| Response DTO | `<Action><Feature>Response` | `LoginAuthResponse` |
| Exception | `<Reason>Exception` | `ResourceNotFoundException` |
| Constants | `<Feature>Constants` | `AuthConstants` |

### Rules

- ✅ Use **exact** naming conventions — no abbreviations or creative alternatives.
- ✅ Use **PascalCase** for classes, **camelCase** for methods/fields, **SCREAMING_SNAKE_CASE** for constants.
- ❌ No suffixes like `Manager`, `Handler`, `Helper`, `Util` in feature packages — use the defined conventions.

---

## 3. Layered Architecture Rules

```
Request → Controller → Service (Interface) → ServiceImpl → Repository (Interface) → RepositoryImpl → Firebase
```

- ✅ **Controllers** call only **Services** (via interface).
- ✅ **Services** call only **Repositories** (via interface).
- ✅ **Repositories** call only **Firebase SDK**.
- ❌ Controllers must **never** call Repositories directly.
- ❌ Repositories must **never** call other Repositories (unless via a service).
- ❌ Firebase SDK calls must **never** appear outside of Repository implementations.
- ❌ No circular dependencies between any layers or features.

---

## 4. Controller Rules

- ✅ Annotate with `@RestController` and `@RequestMapping("/api/v1/<feature>")`.
- ✅ Use constructor injection via `@RequiredArgsConstructor` (Lombok).
- ✅ Always annotate request bodies with `@Valid`.
- ✅ Return `ResponseEntity<ApiResponse<T>>` for all endpoints.
- ✅ Use appropriate HTTP methods: `GET` (read), `POST` (create), `PUT` (full update), `PATCH` (partial update), `DELETE` (remove).
- ❌ No business logic in controllers — only HTTP concerns (request parsing, response building).
- ❌ No try-catch blocks — delegate all exception handling to `@ControllerAdvice`.
- ❌ Entities must **never** be returned from a controller — always map to a response DTO.
- ❌ No direct Firebase / repository calls.

```java
// ✅ Correct controller structure
@Slf4j
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginAuthResponse>> login(@Valid @RequestBody LoginAuthRequest request) {
        LoginAuthResponse response = authService.login(request);
        return ResponseEntity.ok(ApiResponse.success(response));
    }
}
```

---

## 5. Service Rules

- ✅ Always define a **Service Interface** before the implementation.
- ✅ Implementation class must be annotated with `@Service`.
- ✅ Use constructor injection via `@RequiredArgsConstructor`.
- ✅ All business logic, validations, and orchestration live here.
- ✅ Use `@Transactional` where operations span multiple writes.
- ✅ Retrieve the current authenticated user from `SecurityContextHolder`, never as a method parameter from the controller.
- ❌ No Firebase SDK calls in service layer.
- ❌ No HTTP-specific objects (`HttpServletRequest`, `HttpServletResponse`) in service methods.
- ❌ No direct entity returns to controllers — always map to DTOs.

```java
// ✅ Correct service interface
public interface AuthService {
    LoginAuthResponse login(LoginAuthRequest request);
}

// ✅ Correct service implementation
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final AuthRepository authRepository;

    @Override
    public LoginAuthResponse login(LoginAuthRequest request) {
        // Business logic here
    }
}
```

---

## 6. Repository Rules

- ✅ Always define a **Repository Interface** before the implementation.
- ✅ Implementation class must be annotated with `@Repository`.
- ✅ All Firestore / Firebase SDK calls are **exclusively** in repository implementations.
- ✅ Add a Javadoc comment on each entity class describing its Firestore collection path.
- ✅ Use `ApiFuture` / `CompletableFuture` for non-blocking Firestore operations.
- ✅ All list/query methods must support **pagination** — no unbounded `getAll()`.
- ❌ No business logic in repositories — only data access operations.
- ❌ No DTO classes in the repository layer — work only with entities.

```java
// ✅ Correct repository interface
public interface AuthRepository {
    Optional<UserEntity> findByUid(String uid);
    UserEntity save(UserEntity user);
}

// ✅ Correct repository implementation
@Repository
@RequiredArgsConstructor
public class AuthRepositoryImpl implements AuthRepository {

    private final Firestore firestore; // Firebase injected via config

    @Override
    public Optional<UserEntity> findByUid(String uid) {
        // Firestore SDK call here
    }
}
```

---

## 7. Entity & DTO Rules

### Entities (`view` package)

- ✅ Annotate Firestore document models with a comment indicating their collection path.
- ✅ Use `@Data`, `@Builder`, `@NoArgsConstructor`, `@AllArgsConstructor` (Lombok).
- ❌ Entities must **never** leave the service layer — always convert to DTOs before returning.

```java
/**
 * Firestore collection: /users/{uid}
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserEntity {
    private String uid;
    private String email;
    private String role;
    private Timestamp createdAt;
}
```

### DTOs (`dto/request` and `dto/response`)

- ✅ Use `@Builder` + `@Value` (Lombok) or Java Records for **immutability**.
- ✅ Annotate all request DTO fields with Bean Validation annotations (`@NotBlank`, `@Email`, `@NotNull`, etc.).
- ✅ Request DTOs live in `dto/request/`, response DTOs in `dto/response/`.
- ❌ No validation annotations on response DTOs.
- ❌ No entity fields/references in DTOs.

```java
// ✅ Request DTO
@Data
@Builder
public class LoginAuthRequest {
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Password is required")
    private String password;
}

// ✅ Response DTO (immutable)
@Value
@Builder
public class LoginAuthResponse {
    String uid;
    String email;
    String token;
}
```

---

## 8. Firebase Rules

### Authentication

- ✅ Firebase ID token verification happens **only** in a `OncePerRequestFilter`.
- ✅ After verification, store the authenticated user in `SecurityContextHolder`.
- ❌ Never verify Firebase tokens in service or controller layer.
- ❌ Firebase Admin SDK credentials must never be hardcoded — use environment variables or Secret Manager.

### Firestore

- ✅ Inject `Firestore` bean via a `@Configuration` class in `common/config`.
- ✅ Use async calls (`ApiFuture`) for Firestore reads/writes where possible.
- ✅ Define collection name constants in a `<Feature>Constants` class.
- ✅ All queries must specify field constraints to avoid full collection scans.
- ❌ No direct `FirebaseApp.initializeApp()` calls outside of config classes.

```java
// ✅ Firebase config
@Configuration
public class FirebaseConfig {

    @Bean
    public Firestore firestore() throws IOException {
        FirebaseOptions options = FirebaseOptions.builder()
            .setCredentials(GoogleCredentials.getApplicationDefault())
            .build();
        if (FirebaseApp.getApps().isEmpty()) {
            FirebaseApp.initializeApp(options);
        }
        return FirestoreClient.getFirestore();
    }
}
```

---

## 9. Security Rules

- ✅ Use `@PreAuthorize` for role/permission-based access control.
- ✅ All protected routes must be validated through the Firebase token filter.
- ✅ Define public routes explicitly in `SecurityConfig`.
- ✅ Use Spring Security's `SecurityContextHolder` to access the current user in services.
- ❌ No manual role-checking if-statements in service methods — use `@PreAuthorize`.
- ❌ Sensitive data (UIDs, tokens, emails, passwords) must **never** appear in logs.
- ❌ No hardcoded credentials, API keys, or secrets in source code.
- ❌ CORS configuration must be explicitly defined — never use wildcard `*` in production.

```java
// ✅ Get current user in service
public UserEntity getCurrentUser() {
    String uid = (String) SecurityContextHolder.getContext()
        .getAuthentication().getPrincipal();
    return authRepository.findByUid(uid)
        .orElseThrow(() -> new ResourceNotFoundException("User not found"));
}
```

---

## 10. Error Handling Rules

### Exception Hierarchy

```
MyGuardException (base, RuntimeException)
├── ResourceNotFoundException       (404)
├── UnauthorizedException           (401)
├── ForbiddenException              (403)
├── ValidationException             (400)
├── ConflictException               (409)
└── FirebaseOperationException      (500)
```

### Global Handler

- ✅ One `@ControllerAdvice` class (`GlobalExceptionHandler`) handles **all** exceptions.
- ✅ All error responses use a standard `ErrorResponse` DTO format.
- ❌ No try-catch blocks in controllers or services for business exceptions.
- ❌ Stack traces must **never** be exposed in API error responses in production.

```java
// ✅ Standard error response format
@Value
@Builder
public class ErrorResponse {
    String code;         // e.g. "RESOURCE_NOT_FOUND"
    String message;
    String path;
    Instant timestamp;
}

// ✅ Global exception handler
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex,
                                                         HttpServletRequest request) {
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
            .body(ErrorResponse.builder()
                .code("RESOURCE_NOT_FOUND")
                .message(ex.getMessage())
                .path(request.getRequestURI())
                .timestamp(Instant.now())
                .build());
    }
}
```

---

## 11. API Design Rules

### URL Structure

```
/api/v1/<feature>/<resource>
```

| Action | Method | URL Example |
|---|---|---|
| List resources | `GET` | `/api/v1/users` |
| Get one resource | `GET` | `/api/v1/users/{id}` |
| Create resource | `POST` | `/api/v1/users` |
| Full update | `PUT` | `/api/v1/users/{id}` |
| Partial update | `PATCH` | `/api/v1/users/{id}` |
| Delete resource | `DELETE` | `/api/v1/users/{id}` |

### Standard Response Wrapper

```java
@Value
@Builder
public class ApiResponse<T> {
    boolean success;
    String message;
    T data;
    Instant timestamp;

    public static <T> ApiResponse<T> success(T data) { ... }
    public static <T> ApiResponse<T> success(T data, String message) { ... }
}
```

### Rules

- ✅ All endpoints must be prefixed with `/api/v1/`.
- ✅ All successful responses use `ApiResponse<T>` wrapper.
- ✅ All list endpoints support pagination (`page`, `size`, `sort` query params).
- ✅ Use nouns, not verbs, in URLs (`/users` not `/getUsers`).
- ✅ `PUT`/`PATCH` endpoints must be idempotent.
- ❌ No action verbs in endpoint URLs.
- ❌ No unbounded list responses — pagination is mandatory.

---

## 12. Logging Rules

- ✅ Use `@Slf4j` (Lombok) on every class that requires logging.
- ✅ Log messages must include feature context: `[AUTH] User login - uid={}`.
- ✅ Use a single filter/interceptor to log all incoming requests and outgoing responses with duration.
- ❌ No `System.out.println` anywhere in the codebase.
- ❌ No sensitive data in logs (UID, email, tokens, passwords).

### Log Level Guide

| Level | When to Use |
|---|---|
| `DEBUG` | Internal dev tracing, variable states |
| `INFO` | Business events (user created, login success) |
| `WARN` | Recoverable issues, deprecations, unexpected-but-handled states |
| `ERROR` | Unrecoverable failures, exceptions |

```java
// ✅ Correct logging
@Slf4j
@Service
public class AuthServiceImpl implements AuthService {
    public LoginAuthResponse login(LoginAuthRequest request) {
        log.info("[AUTH] Login attempt initiated");
        // ...
        log.info("[AUTH] Login successful");
    }
}
```

---

---

## 13. Configuration Rules

### Spring Profiles

| Profile | Purpose |
|---|---|
| `dev` | Local development with Firebase Emulator |
| `staging` | Pre-production with staging Firebase project |
| `prod` | Production with production Firebase project |

### Rules

- ✅ Use `application-{profile}.yml` for environment-specific config.
- ✅ All secrets (Firebase credentials, keys) must come from environment variables or a secrets manager — never committed to version control.
- ✅ Add `application-*.yml` (except `application.yml`) to `.gitignore`.
- ✅ Use `@ConfigurationProperties` for typed config binding instead of `@Value` for complex configs.
- ❌ No hardcoded environment-specific values (URLs, ports, credentials) in code.
- ❌ No `application-prod.yml` with real credentials committed to the repo.

---

## 14. Code Quality Rules

### General

- ✅ Use **Lombok** to eliminate boilerplate: `@Data`, `@Builder`, `@Slf4j`, `@RequiredArgsConstructor`.
- ✅ Use **constants classes** (`<Feature>Constants`) for all magic strings and numbers.
- ✅ Keep methods short — a method doing more than one thing should be split.
- ✅ Use Java **enums** for status values, roles, types.
- ❌ No magic strings or numbers inline in business logic.
- ❌ No commented-out code committed to the repository.
- ❌ No `public` fields on any class — always use encapsulation.

### Dependency Injection

- ✅ Always use **constructor injection** (via `@RequiredArgsConstructor`).
- ❌ No field injection (`@Autowired` on fields).
- ❌ No setter injection unless absolutely necessary.

### Imports & Dependencies

- ✅ Only import what is needed — no wildcard imports (`import java.util.*`).
- ✅ Add new dependencies only if they solve a clear, justified problem.
- ✅ Review and remove unused dependencies during refactoring.

---

## Quick Reference Checklist

Before raising a PR, verify:

- [ ] Feature is fully contained in `com.myguard.<feature>` package
- [ ] All layers have interface + implementation
- [ ] No Firebase SDK calls outside repository implementations
- [ ] All controller endpoints return `ResponseEntity<ApiResponse<T>>`
- [ ] No entities returned from controllers
- [ ] All request DTOs have Bean Validation annotations
- [ ] No business logic in controllers
- [ ] Global exception handler used — no try-catch in controller/service
- [ ] No sensitive data in logs
- [ ] Unit tests written for all service implementations
- [ ] All endpoints versioned under `/api/v1/`
- [ ] No hardcoded secrets or credentials
- [ ] `@Slf4j` used instead of `System.out.println`
- [ ] Spring profile used for environment-specific config