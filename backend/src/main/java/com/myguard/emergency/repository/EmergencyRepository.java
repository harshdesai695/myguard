package com.myguard.emergency.repository;

import java.util.List;
import java.util.Optional;

import com.myguard.emergency.view.ChildAlertEntity;
import com.myguard.emergency.view.EmergencyContactEntity;
import com.myguard.emergency.view.PanicAlertEntity;

public interface EmergencyRepository {

    // Panic Alerts
    PanicAlertEntity savePanicAlert(PanicAlertEntity alert);
    Optional<PanicAlertEntity> findPanicAlertById(String id);
    PanicAlertEntity updatePanicAlert(PanicAlertEntity alert);
    List<PanicAlertEntity> findActivePanicAlerts(String societyId, int page, int size);
    long countActivePanicAlerts(String societyId);

    // Emergency Contacts
    EmergencyContactEntity saveEmergencyContact(EmergencyContactEntity contact);
    Optional<EmergencyContactEntity> findEmergencyContactById(String id);
    EmergencyContactEntity updateEmergencyContact(EmergencyContactEntity contact);
    void deleteEmergencyContact(String id);
    List<EmergencyContactEntity> findEmergencyContacts(String societyId, int page, int size);
    long countEmergencyContacts(String societyId);

    // Child Alerts
    List<ChildAlertEntity> findChildAlertsByResidentUid(String residentUid, int page, int size);
    long countChildAlertsByResidentUid(String residentUid);
}
