package com.hospital.service;

import com.hospital.entity.Doctor;
import java.util.List;
import java.util.Optional;

public interface DoctorService {
    List<Doctor> getAllDoctors();
    Optional<Doctor> getDoctorById(Integer id);
    Doctor saveDoctor(Doctor doctor);
    void deleteDoctor(Integer id);
    Doctor getDoctorByUserId(Integer userId);
}
