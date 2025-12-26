package com.hospital.service.impl;

import com.hospital.entity.OPDVisitHistory;
import com.hospital.repository.OPDVisitHistoryRepository;
import com.hospital.service.OPDVisitHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class OPDVisitHistoryServiceImpl implements OPDVisitHistoryService {

    @Autowired
    private OPDVisitHistoryRepository opdVisitHistoryRepository;

    @Override
    public List<OPDVisitHistory> getAllOPDVisitHistories() {
        return opdVisitHistoryRepository.findAll();
    }

    @Override
    public Optional<OPDVisitHistory> getOPDVisitHistoryById(Integer id) {
        return opdVisitHistoryRepository.findById(id);
    }

    @Override
    public OPDVisitHistory saveOPDVisitHistory(OPDVisitHistory opdVisitHistory) {
        if (opdVisitHistory.getVisCreatedDate() == null) {
            opdVisitHistory.setVisCreatedDate(new Date());
        }
        opdVisitHistory.setVisLastModifiedDate(new Date());
        return opdVisitHistoryRepository.save(opdVisitHistory);
    }

    @Override
    public void deleteOPDVisitHistory(Integer id) {
        opdVisitHistoryRepository.deleteById(id);
    }

    @Override
    public List<OPDVisitHistory> getOPDVisitHistoriesByPatientId(Integer patId) {
        return opdVisitHistoryRepository.findByPatientPatId(patId);
    }

    @Override
    public List<OPDVisitHistory> getOPDVisitHistoriesByDoctorId(Integer docId) {
        return opdVisitHistoryRepository.findByDoctorDocId(docId);
    }
}
