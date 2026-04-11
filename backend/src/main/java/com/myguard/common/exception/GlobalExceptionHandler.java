package com.myguard.common.exception;

import com.myguard.common.response.ErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.time.Instant;
import java.util.stream.Collectors;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleNotFound(ResourceNotFoundException ex,
                                                         HttpServletRequest request) {
        log.warn("[ERROR] Resource not found: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(ErrorResponse.builder()
                        .code("RESOURCE_NOT_FOUND")
                        .message(ex.getMessage())
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(UnauthorizedException.class)
    public ResponseEntity<ErrorResponse> handleUnauthorized(UnauthorizedException ex,
                                                             HttpServletRequest request) {
        log.warn("[ERROR] Unauthorized: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(ErrorResponse.builder()
                        .code("UNAUTHORIZED")
                        .message(ex.getMessage())
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(ForbiddenException.class)
    public ResponseEntity<ErrorResponse> handleForbidden(ForbiddenException ex,
                                                          HttpServletRequest request) {
        log.warn("[ERROR] Forbidden: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ErrorResponse.builder()
                        .code("FORBIDDEN")
                        .message(ex.getMessage())
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(ValidationException.class)
    public ResponseEntity<ErrorResponse> handleValidation(ValidationException ex,
                                                           HttpServletRequest request) {
        log.warn("[ERROR] Validation failed: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ErrorResponse.builder()
                        .code("VALIDATION_ERROR")
                        .message(ex.getMessage())
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(ConflictException.class)
    public ResponseEntity<ErrorResponse> handleConflict(ConflictException ex,
                                                         HttpServletRequest request) {
        log.warn("[ERROR] Conflict: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(ErrorResponse.builder()
                        .code("CONFLICT")
                        .message(ex.getMessage())
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(FirebaseOperationException.class)
    public ResponseEntity<ErrorResponse> handleFirebaseOperation(FirebaseOperationException ex,
                                                                  HttpServletRequest request) {
        log.error("[ERROR] Firebase operation failed: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ErrorResponse.builder()
                        .code("FIREBASE_ERROR")
                        .message("An internal error occurred")
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleMethodArgumentNotValid(MethodArgumentNotValidException ex,
                                                                       HttpServletRequest request) {
        String errors = ex.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining(", "));
        log.warn("[ERROR] Validation errors: {}", errors);
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                .body(ErrorResponse.builder()
                        .code("VALIDATION_ERROR")
                        .message(errors)
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDenied(AccessDeniedException ex,
                                                             HttpServletRequest request) {
        log.warn("[ERROR] Access denied: {}", ex.getMessage());
        return ResponseEntity.status(HttpStatus.FORBIDDEN)
                .body(ErrorResponse.builder()
                        .code("ACCESS_DENIED")
                        .message("You do not have permission to access this resource")
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGeneral(Exception ex,
                                                        HttpServletRequest request) {
        log.error("[ERROR] Unexpected error: {}", ex.getMessage(), ex);
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ErrorResponse.builder()
                        .code("INTERNAL_ERROR")
                        .message("An unexpected error occurred")
                        .path(request.getRequestURI())
                        .timestamp(Instant.now())
                        .build());
    }
}
