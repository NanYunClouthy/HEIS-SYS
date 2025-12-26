package com.hospital.repository;

import com.hospital.entity.OPDVisitHistory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OPDVisitHistoryRepository extends JpaRepository<OPDVisitHistory, Integer> {
    List<OPDVisitHistory> findByPatientPatId(Integer patId);
    List<OPDVisitHistory> findByDoctorDocId(Integer docId);
}
