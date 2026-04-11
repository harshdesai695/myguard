package com.myguard.marketplace.dto.request;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ExpressInterestRequest {
    private String message;
}
