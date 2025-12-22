package com.hospital.service;

import com.hospital.entity.Patient;
import java.util.List;
import java.util.Optional;

public interface PatientService {
    List<Patient> getAllPatients();
    Optional<Patient> getPatientById(Integer id);
    Patient savePatient(Patient patient);
    void deletePatient(Integer id);
    List<Patient> searchPatientsByPatName(String patName);
    List<Patient> searchPatients(Integer id, String name);
    Patient getPatientByUserId(Integer userId);
}
