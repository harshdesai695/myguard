package com.myguard.emergency.service;

import com.myguard.common.response.PaginatedResponse;
import com.myguard.emergency.dto.request.CreateEmergencyContactRequest;
import com.myguard.emergency.dto.request.TriggerPanicRequest;
import com.myguard.emergency.dto.request.UpdateEmergencyContactRequest;
import com.myguard.emergency.dto.response.EmergencyContactResponse;
import com.myguard.emergency.dto.response.PanicAlertResponse;

public interface EmergencyService {

    // Panic Alerts
    PanicAlertResponse triggerPanic(TriggerPanicRequest request);
    PaginatedResponse<PanicAlertResponse> listActivePanicAlerts(int page, int size, String societyId);
    PanicAlertResponse resolvePanicAlert(String id);

    // Emergency Contacts
    EmergencyContactResponse addEmergencyContact(CreateEmergencyContactRequest request);
    PaginatedResponse<EmergencyContactResponse> listEmergencyContacts(int page, int size, String societyId);
    EmergencyContactResponse updateEmergencyContact(String id, UpdateEmergencyContactRequest request);
    void deleteEmergencyContact(String id);

    // Child Alerts
    PaginatedResponse<com.myguard.emergency.dto.response.ChildAlertResponse> getChildAlerts(int page, int size);
}
