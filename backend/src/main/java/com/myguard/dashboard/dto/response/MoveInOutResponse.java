package com.myguard.dashboard.dto.response;

import lombok.Builder;
import lombok.Value;

@Value
@Builder
public class MoveInOutResponse {
    long moveInCount;
    long moveOutCount;
    long occupiedFlats;
    long vacantFlats;
}
