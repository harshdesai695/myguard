package com.myguard.dailyhelp.repository;

import com.myguard.dailyhelp.view.AttendanceEntity;
import com.myguard.dailyhelp.view.DailyHelpEntity;

import java.util.List;
import java.util.Optional;

public interface DailyHelpRepository {
    DailyHelpEntity save(DailyHelpEntity dailyHelp);
    Optional<DailyHelpEntity> findById(String id);
    DailyHelpEntity update(DailyHelpEntity dailyHelp);
    void delete(String id);
    List<DailyHelpEntity> findByResidentUid(String residentUid, int page, int size);
    long countByResidentUid(String residentUid);

    AttendanceEntity saveAttendance(AttendanceEntity attendance);
    List<AttendanceEntity> findAttendanceByDailyHelpId(String dailyHelpId, int page, int size);
    long countAttendanceByDailyHelpId(String dailyHelpId);
    List<AttendanceEntity> findAttendanceByMonth(String dailyHelpId, String yearMonth);
}
