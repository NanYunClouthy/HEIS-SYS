package com.hospital.repository;

import com.hospital.entity.OPD;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface OPDRepository extends JpaRepository<OPD, Integer> {
    List<OPD> findByOpdStats(Integer opdStats);
    List<OPD> findByOpdDeptAndOpdStats(String opdDept, Integer opdStats);
    List<OPD> findByDoctorDocIdAndOpdStats(Integer docId, Integer opdStats);
}
