package com.hospital.service.impl;

import com.hospital.entity.OPD;
import com.hospital.repository.OPDRepository;
import com.hospital.service.OPDService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class OPDServiceImpl implements OPDService {

    @Autowired
    private OPDRepository opdRepository;

    @Override
    public List<OPD> getAllOPDs() {
        return opdRepository.findAll();
    }

    @Override
    public Optional<OPD> getOPDById(Integer id) {
        return opdRepository.findById(id);
    }

    @Override
    public OPD saveOPD(OPD opd) {
        // 确保初始状态为1（待就诊）
        if (opd.getOpdStats() == null) {
            opd.setOpdStats(1);
        }
        return opdRepository.save(opd);
    }

    @Override
    public List<OPD> getWaitingPatients(Integer status) {
        return opdRepository.findByOpdStats(status);
    }

    @Override
    public List<OPD> getWaitingPatientsByDept(String dept, Integer status) {
        return opdRepository.findByOpdDeptAndOpdStats(dept, status);
    }

    @Override
    public List<OPD> getWaitingPatientsByDoctor(Integer docId, Integer status) {
        return opdRepository.findByDoctorDocIdAndOpdStats(docId, status);
    }

    @Override
    public OPD callPatient(Integer id) {
        Optional<OPD> optionalOPD = opdRepository.findById(id);
        if (optionalOPD.isPresent()) {
            OPD opd = optionalOPD.get();
            // 更新状态为2（就诊中）
            opd.setOpdStats(2);
            return opdRepository.save(opd);
        }
        return null;
    }

    @Override
    public OPD skipPatient(Integer id) {
        Optional<OPD> optionalOPD = opdRepository.findById(id);
        if (optionalOPD.isPresent()) {
            OPD opd = optionalOPD.get();
            // 更新状态为3（已过号）
            opd.setOpdStats(3);
            return opdRepository.save(opd);
        }
        return null;
    }
}
