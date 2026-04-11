package com.myguard.guard.repository;

import com.myguard.guard.view.CheckpointEntity;
import com.myguard.guard.view.IntercomEntity;
import com.myguard.guard.view.PatrolEntity;
import com.myguard.guard.view.ShiftEntity;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

public interface GuardRepository {
    CheckpointEntity saveCheckpoint(CheckpointEntity checkpoint);
    List<CheckpointEntity> findAllCheckpoints(int page, int size);
    long countCheckpoints();

    PatrolEntity savePatrol(PatrolEntity patrol);
    List<PatrolEntity> findPatrols(int page, int size, String guardUid, Instant from, Instant to);
    long countPatrols(String guardUid, Instant from, Instant to);

    ShiftEntity saveShift(ShiftEntity shift);
    List<ShiftEntity> findShifts(int page, int size);
    long countShifts();

    IntercomEntity saveIntercom(IntercomEntity intercom);
}
