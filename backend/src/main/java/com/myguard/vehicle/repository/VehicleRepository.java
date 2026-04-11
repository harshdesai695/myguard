package com.myguard.vehicle.repository;

import com.myguard.vehicle.view.ParkingSlotEntity;
import com.myguard.vehicle.view.VehicleEntity;
import com.myguard.vehicle.view.VisitorVehicleLogEntity;

import java.util.List;
import java.util.Optional;

public interface VehicleRepository {

    // Vehicles
    VehicleEntity saveVehicle(VehicleEntity vehicle);
    Optional<VehicleEntity> findVehicleById(String id);
    VehicleEntity updateVehicle(VehicleEntity vehicle);
    void deleteVehicle(String id);
    List<VehicleEntity> findVehiclesByOwner(String ownerUid, int page, int size);
    long countVehiclesByOwner(String ownerUid);
    Optional<VehicleEntity> findVehicleByPlateNumber(String plateNumber);

    // Parking
    ParkingSlotEntity saveParkingSlot(ParkingSlotEntity slot);
    List<ParkingSlotEntity> findParkingSlots(String societyId, int page, int size);
    long countParkingSlots(String societyId);

    // Visitor Vehicle Logs
    VisitorVehicleLogEntity saveVisitorVehicleLog(VisitorVehicleLogEntity log);
    List<VisitorVehicleLogEntity> findVisitorVehicleLogs(String societyId, int page, int size);
    long countVisitorVehicleLogs(String societyId);
}
