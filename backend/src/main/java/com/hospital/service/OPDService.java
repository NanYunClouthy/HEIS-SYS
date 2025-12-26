package com.hospital.service;

import com.hospital.entity.OPD;
import java.util.List;
import java.util.Optional;

public interface OPDService {
    List<OPD> getAllOPDs();
    Optional<OPD> getOPDById(Integer id);
    OPD saveOPD(OPD opd);
    List<OPD> getWaitingPatients(Integer status);
    List<OPD> getWaitingPatientsByDept(String dept, Integer status);
    List<OPD> getWaitingPatientsByDoctor(Integer docId, Integer status);
    OPD callPatient(Integer id);
    OPD skipPatient(Integer id);
}
