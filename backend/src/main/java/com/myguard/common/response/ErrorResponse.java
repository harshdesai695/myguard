package com.myguard.common.response;

import lombok.Builder;
import lombok.Value;

import java.time.Instant;

@Value
@Builder
public class ErrorResponse {
    String code;
    String message;
    String path;
    Instant timestamp;
}
