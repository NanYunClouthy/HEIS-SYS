package com.hospital.service;

import com.hospital.dto.PrescriptionDTO;
import com.hospital.entity.Prescription;
import java.util.List;
import java.util.Optional;

public interface PrescriptionService {
    Prescription createPrescription(PrescriptionDTO prescriptionDTO);
    List<Prescription> getPrescriptionsByVisitId(Integer visId);
    Optional<Prescription> getPrescriptionById(Integer id);
}
