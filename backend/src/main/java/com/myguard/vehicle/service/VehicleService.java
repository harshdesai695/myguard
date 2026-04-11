package com.myguard.vehicle.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.vehicle.dto.request.AllocateParkingRequest;
import com.myguard.vehicle.dto.request.LogVisitorVehicleRequest;
import com.myguard.vehicle.dto.request.RegisterVehicleRequest;
import com.myguard.vehicle.dto.request.UpdateVehicleRequest;
import com.myguard.vehicle.dto.response.ParkingSlotResponse;
import com.myguard.vehicle.dto.response.VehicleResponse;
import com.myguard.vehicle.dto.response.VisitorVehicleLogResponse;

public interface VehicleService {

    VehicleResponse registerVehicle(RegisterVehicleRequest request);
    PaginatedResponse<VehicleResponse> listMyVehicles(int page, int size);
    VehicleResponse getVehicleById(String id);
    VehicleResponse updateVehicle(String id, UpdateVehicleRequest request);
    void deleteVehicle(String id);
    VehicleResponse lookupByPlateNumber(String plateNumber);

    ParkingSlotResponse allocateParking(AllocateParkingRequest request);
    PaginatedResponse<ParkingSlotResponse> listParkingSlots(int page, int size, String societyId);

    VisitorVehicleLogResponse logVisitorVehicle(LogVisitorVehicleRequest request);
    PaginatedResponse<VisitorVehicleLogResponse> listVisitorVehicleLogs(int page, int size, String societyId);
}
