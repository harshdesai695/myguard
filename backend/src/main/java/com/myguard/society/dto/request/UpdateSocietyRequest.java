package com.myguard.society.dto.request;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UpdateSocietyRequest {
    private String name;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private Integer totalBlocks;
    private Integer totalFlats;
    private String logoUrl;
    private String status;
}
