package com.hospital.controller;

import com.hospital.dto.PrescriptionDTO;
import com.hospital.entity.Prescription;
import com.hospital.service.PrescriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/prescriptions")
@CrossOrigin(origins = "*", maxAge = 3600)
public class PrescriptionController {

    @Autowired
    private PrescriptionService prescriptionService;

    @PostMapping
    public ResponseEntity<?> createPrescription(@RequestBody PrescriptionDTO dto) {
        try {
            Prescription prescription = prescriptionService.createPrescription(dto);
            return new ResponseEntity<>(prescription, HttpStatus.CREATED);
        } catch (RuntimeException e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @GetMapping("/visit/{visId}")
    public ResponseEntity<List<Prescription>> getPrescriptionsByVisit(@PathVariable Integer visId) {
        return ResponseEntity.ok(prescriptionService.getPrescriptionsByVisitId(visId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<Prescription> getPrescription(@PathVariable Integer id) {
        return prescriptionService.getPrescriptionById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
}
