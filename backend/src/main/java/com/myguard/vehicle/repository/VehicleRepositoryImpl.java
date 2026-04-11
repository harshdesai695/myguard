package com.myguard.vehicle.repository;

import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.Query;
import com.google.cloud.firestore.QuerySnapshot;
import com.myguard.common.exception.FirebaseOperationException;
import com.myguard.vehicle.constants.VehicleConstants;
import com.myguard.vehicle.view.ParkingSlotEntity;
import com.myguard.vehicle.view.VehicleEntity;
import com.myguard.vehicle.view.VisitorVehicleLogEntity;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

@Slf4j
@Repository
@RequiredArgsConstructor
public class VehicleRepositoryImpl implements VehicleRepository {

    private final Firestore firestore;

    private CollectionReference getVehiclesCollection() {
        return firestore.collection(VehicleConstants.COLLECTION_VEHICLES);
    }

    private CollectionReference getParkingCollection() {
        return firestore.collection(VehicleConstants.COLLECTION_PARKING);
    }

    private CollectionReference getVisitorVehicleLogCollection() {
        return firestore.collection(VehicleConstants.COLLECTION_VISITOR_VEHICLE_LOG);
    }

    // --- Vehicles ---

    @Override
    public VehicleEntity saveVehicle(VehicleEntity vehicle) {
        try {
            DocumentReference docRef;
            if (vehicle.getId() != null) {
                docRef = getVehiclesCollection().document(vehicle.getId());
            } else {
                docRef = getVehiclesCollection().document();
                vehicle.setId(docRef.getId());
            }
            docRef.set(vehicle).get();
            log.debug("[VEHICLE] Vehicle saved with ID: {}", vehicle.getId());
            return vehicle;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save vehicle", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save vehicle", e);
        }
    }

    @Override
    public Optional<VehicleEntity> findVehicleById(String id) {
        try {
            DocumentSnapshot doc = getVehiclesCollection().document(id).get().get();
            return doc.exists() ? Optional.ofNullable(doc.toObject(VehicleEntity.class)) : Optional.empty();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find vehicle", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find vehicle", e);
        }
    }

    @Override
    public VehicleEntity updateVehicle(VehicleEntity vehicle) {
        try {
            getVehiclesCollection().document(vehicle.getId()).set(vehicle).get();
            log.debug("[VEHICLE] Vehicle updated with ID: {}", vehicle.getId());
            return vehicle;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to update vehicle", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to update vehicle", e);
        }
    }

    @Override
    public void deleteVehicle(String id) {
        try {
            getVehiclesCollection().document(id).delete().get();
            log.debug("[VEHICLE] Vehicle deleted with ID: {}", id);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to delete vehicle", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to delete vehicle", e);
        }
    }

    @Override
    public List<VehicleEntity> findVehiclesByOwner(String ownerUid, int page, int size) {
        try {
            Query query = getVehiclesCollection()
                    .whereEqualTo(VehicleConstants.FIELD_OWNER_UID, ownerUid)
                    .orderBy(VehicleConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING)
                    .offset(page * size)
                    .limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(VehicleEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list vehicles", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list vehicles", e);
        }
    }

    @Override
    public long countVehiclesByOwner(String ownerUid) {
        try {
            return getVehiclesCollection()
                    .whereEqualTo(VehicleConstants.FIELD_OWNER_UID, ownerUid)
                    .get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count vehicles", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count vehicles", e);
        }
    }

    @Override
    public Optional<VehicleEntity> findVehicleByPlateNumber(String plateNumber) {
        try {
            QuerySnapshot snapshot = getVehiclesCollection()
                    .whereEqualTo(VehicleConstants.FIELD_PLATE_NUMBER, plateNumber)
                    .limit(1)
                    .get().get();
            return snapshot.isEmpty() ? Optional.empty()
                    : Optional.ofNullable(snapshot.getDocuments().get(0).toObject(VehicleEntity.class));
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to find vehicle by plate number", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to find vehicle by plate number", e);
        }
    }

    // --- Parking ---

    @Override
    public ParkingSlotEntity saveParkingSlot(ParkingSlotEntity slot) {
        try {
            DocumentReference docRef;
            if (slot.getId() != null) {
                docRef = getParkingCollection().document(slot.getId());
            } else {
                docRef = getParkingCollection().document();
                slot.setId(docRef.getId());
            }
            docRef.set(slot).get();
            log.debug("[VEHICLE] Parking slot saved with ID: {}", slot.getId());
            return slot;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save parking slot", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save parking slot", e);
        }
    }

    @Override
    public List<ParkingSlotEntity> findParkingSlots(String societyId, int page, int size) {
        try {
            Query query = getParkingCollection()
                    .orderBy(VehicleConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(VehicleConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(ParkingSlotEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list parking slots", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list parking slots", e);
        }
    }

    @Override
    public long countParkingSlots(String societyId) {
        try {
            Query query = getParkingCollection();
            if (societyId != null) {
                query = query.whereEqualTo(VehicleConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count parking slots", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count parking slots", e);
        }
    }

    // --- Visitor Vehicle Logs ---

    @Override
    public VisitorVehicleLogEntity saveVisitorVehicleLog(VisitorVehicleLogEntity logEntity) {
        try {
            DocumentReference docRef;
            if (logEntity.getId() != null) {
                docRef = getVisitorVehicleLogCollection().document(logEntity.getId());
            } else {
                docRef = getVisitorVehicleLogCollection().document();
                logEntity.setId(docRef.getId());
            }
            docRef.set(logEntity).get();
            log.debug("[VEHICLE] Visitor vehicle log saved with ID: {}", logEntity.getId());
            return logEntity;
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to save visitor vehicle log", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to save visitor vehicle log", e);
        }
    }

    @Override
    public List<VisitorVehicleLogEntity> findVisitorVehicleLogs(String societyId, int page, int size) {
        try {
            Query query = getVisitorVehicleLogCollection()
                    .orderBy(VehicleConstants.FIELD_CREATED_AT, Query.Direction.DESCENDING);
            if (societyId != null) {
                query = query.whereEqualTo(VehicleConstants.FIELD_SOCIETY_ID, societyId);
            }
            query = query.offset(page * size).limit(size);
            QuerySnapshot snapshot = query.get().get();
            return snapshot.getDocuments().stream()
                    .map(doc -> doc.toObject(VisitorVehicleLogEntity.class))
                    .collect(Collectors.toList());
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to list visitor vehicle logs", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to list visitor vehicle logs", e);
        }
    }

    @Override
    public long countVisitorVehicleLogs(String societyId) {
        try {
            Query query = getVisitorVehicleLogCollection();
            if (societyId != null) {
                query = query.whereEqualTo(VehicleConstants.FIELD_SOCIETY_ID, societyId);
            }
            return query.get().get().size();
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new FirebaseOperationException("Failed to count visitor vehicle logs", e);
        } catch (ExecutionException e) {
            throw new FirebaseOperationException("Failed to count visitor vehicle logs", e);
        }
    }
}
