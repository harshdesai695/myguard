package com.myguard.material.repository;

import com.myguard.material.view.GatepassEntity;

import java.util.List;
import java.util.Optional;

public interface MaterialRepository {

    GatepassEntity saveGatepass(GatepassEntity gatepass);
    Optional<GatepassEntity> findGatepassById(String id);
    GatepassEntity updateGatepass(GatepassEntity gatepass);
    List<GatepassEntity> findGatepassesByRequestedBy(String requestedBy, int page, int size);
    long countGatepassesByRequestedBy(String requestedBy);
    List<GatepassEntity> findAllGatepasses(String societyId, int page, int size, String status);
    long countAllGatepasses(String societyId, String status);
}
