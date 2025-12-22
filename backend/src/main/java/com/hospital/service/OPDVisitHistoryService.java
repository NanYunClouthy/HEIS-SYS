package com.hospital.service;

import com.hospital.entity.OPDVisitHistory;
import java.util.List;
import java.util.Optional;

public interface OPDVisitHistoryService {
    List<OPDVisitHistory> getAllOPDVisitHistories();
    Optional<OPDVisitHistory> getOPDVisitHistoryById(Integer id);
    OPDVisitHistory saveOPDVisitHistory(OPDVisitHistory opdVisitHistory);
    void deleteOPDVisitHistory(Integer id);
    List<OPDVisitHistory> getOPDVisitHistoriesByPatientId(Integer patId);
    List<OPDVisitHistory> getOPDVisitHistoriesByDoctorId(Integer docId);
}
