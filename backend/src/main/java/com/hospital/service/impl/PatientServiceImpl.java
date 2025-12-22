package com.hospital.service.impl;

import com.hospital.entity.Patient;
import com.hospital.repository.PatientRepository;
import com.hospital.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class PatientServiceImpl implements PatientService {

    @Autowired
    private PatientRepository patientRepository;

    @Override
    public List<Patient> getAllPatients() {
        return patientRepository.findAll();
    }

    @Override
    public Optional<Patient> getPatientById(Integer id) {
        return patientRepository.findById(id);
    }

    @Override
    public Patient savePatient(Patient patient) {
        return patientRepository.save(patient);
    }

    @Override
    public void deletePatient(Integer id) {
        patientRepository.deleteById(id);
    }

    @Override
    public List<Patient> searchPatientsByPatName(String patName) {
        return patientRepository.findByPatNameContaining(patName);
    }

    @Override
    public List<Patient> searchPatients(Integer id, String name) {
        return patientRepository.searchPatients(id, name);
    }

    @Override
    public Patient getPatientByUserId(Integer userId) {
        return patientRepository.findByUserUserId(userId);
    }
}
