package com.myguard.society.dto.request;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateFlatRequest {
    private String block;
    private Integer floor;
    private String flatNumber;
    private String type;
    private String status;
    private String primaryResidentUid;
}
