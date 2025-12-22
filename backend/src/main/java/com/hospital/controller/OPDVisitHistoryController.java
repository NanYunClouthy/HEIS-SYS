package com.hospital.controller;

import com.hospital.entity.OPDVisitHistory;
import com.hospital.service.OPDVisitHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/opd-visit-histories")
@CrossOrigin(origins = "*", maxAge = 3600)
public class OPDVisitHistoryController {

    @Autowired
    private OPDVisitHistoryService opdVisitHistoryService;

    // 获取所有就诊记录
    @GetMapping
    public ResponseEntity<List<OPDVisitHistory>> getAllOPDVisitHistories() {
        List<OPDVisitHistory> histories = opdVisitHistoryService.getAllOPDVisitHistories();
        return new ResponseEntity<>(histories, HttpStatus.OK);
    }

    // 根据ID获取就诊记录
    @GetMapping("/{id}")
    public ResponseEntity<OPDVisitHistory> getOPDVisitHistoryById(@PathVariable Integer id) {
        Optional<OPDVisitHistory> history = opdVisitHistoryService.getOPDVisitHistoryById(id);
        return history.map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // 创建就诊记录
    @PostMapping
    public ResponseEntity<OPDVisitHistory> createOPDVisitHistory(@RequestBody OPDVisitHistory history) {
        OPDVisitHistory savedHistory = opdVisitHistoryService.saveOPDVisitHistory(history);
        return new ResponseEntity<>(savedHistory, HttpStatus.CREATED);
    }

    // 更新就诊记录
    @PutMapping("/{id}")
    public ResponseEntity<OPDVisitHistory> updateOPDVisitHistory(@PathVariable Integer id, @RequestBody OPDVisitHistory history) {
        Optional<OPDVisitHistory> existingHistory = opdVisitHistoryService.getOPDVisitHistoryById(id);
        if (existingHistory.isPresent()) {
            history.setVisId(id);
            OPDVisitHistory updatedHistory = opdVisitHistoryService.saveOPDVisitHistory(history);
            return new ResponseEntity<>(updatedHistory, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // 删除就诊记录
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteOPDVisitHistory(@PathVariable Integer id) {
        opdVisitHistoryService.deleteOPDVisitHistory(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    // 根据患者ID获取就诊记录
    @GetMapping("/patient/{patId}")
    public ResponseEntity<List<OPDVisitHistory>> getOPDVisitHistoriesByPatientId(@PathVariable Integer patId) {
        List<OPDVisitHistory> histories = opdVisitHistoryService.getOPDVisitHistoriesByPatientId(patId);
        return new ResponseEntity<>(histories, HttpStatus.OK);
    }

    // 根据医生ID获取就诊记录
    @GetMapping("/doctor/{docId}")
    public ResponseEntity<List<OPDVisitHistory>> getOPDVisitHistoriesByDoctorId(@PathVariable Integer docId) {
        List<OPDVisitHistory> histories = opdVisitHistoryService.getOPDVisitHistoriesByDoctorId(docId);
        return new ResponseEntity<>(histories, HttpStatus.OK);
    }
}
