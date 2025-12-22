package com.hospital.repository;

import com.hospital.entity.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Integer> {
    // 通过姓名搜索患者
    List<Patient> findByPatNameContaining(String patName);
    
    // 通过病历号或姓名搜索患者
    @Query("SELECT p FROM Patient p WHERE p.patId = :id OR p.patName LIKE %:name%")
    List<Patient> searchPatients(@Param("id") Integer id, @Param("name") String name);

    Patient findByUserUserId(Integer userId);
}
