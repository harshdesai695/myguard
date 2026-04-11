package com.myguard.society.service;

import com.myguard.society.dto.request.CreateFlatRequest;
import com.myguard.society.dto.request.CreateSocietyRequest;
import com.myguard.society.dto.request.UpdateFlatRequest;
import com.myguard.society.dto.request.UpdateSocietyRequest;
import com.myguard.society.dto.response.FlatResponse;
import com.myguard.society.dto.response.SocietyResponse;
import com.myguard.common.response.PaginatedResponse;

import java.util.List;

public interface SocietyService {
    SocietyResponse createSociety(CreateSocietyRequest request);
    PaginatedResponse<SocietyResponse> listSocieties(int page, int size);
    SocietyResponse getSocietyById(String id);
    SocietyResponse updateSociety(String id, UpdateSocietyRequest request);

    FlatResponse addFlat(String societyId, CreateFlatRequest request);
    PaginatedResponse<FlatResponse> listFlats(String societyId, int page, int size);
    FlatResponse getFlatById(String societyId, String flatId);
    FlatResponse updateFlat(String societyId, String flatId, UpdateFlatRequest request);
    List<String> getResidentsInFlat(String societyId, String flatId);
}
