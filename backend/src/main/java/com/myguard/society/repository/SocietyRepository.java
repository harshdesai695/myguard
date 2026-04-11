package com.myguard.society.repository;

import com.myguard.auth.dto.response.UserAuthResponse;
import com.myguard.society.view.FlatEntity;
import com.myguard.society.view.SocietyEntity;

import java.util.List;
import java.util.Optional;

public interface SocietyRepository {
    SocietyEntity saveSociety(SocietyEntity society);
    Optional<SocietyEntity> findSocietyById(String id);
    SocietyEntity updateSociety(SocietyEntity society);
    List<SocietyEntity> findAllSocieties(int page, int size);
    long countSocieties();

    FlatEntity saveFlat(FlatEntity flat);
    Optional<FlatEntity> findFlatById(String flatId);
    FlatEntity updateFlat(FlatEntity flat);
    List<FlatEntity> findFlatsBySocietyId(String societyId, int page, int size);
    long countFlatsBySocietyId(String societyId);
    List<String> findResidentUidsByFlatId(String flatId);
}
