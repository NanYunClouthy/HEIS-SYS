package com.hospital.controller;

import com.hospital.entity.Drug;
import com.hospital.service.DrugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/drugs")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DrugController {

    @Autowired
    private DrugService drugService;

    @GetMapping
    public ResponseEntity<List<Drug>> getAllDrugs() {
        return ResponseEntity.ok(drugService.getAllDrugs());
    }

    @GetMapping("/{id}")
    public ResponseEntity<Drug> getDrugById(@PathVariable Integer id) {
        return drugService.getDrugById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Drug> createDrug(@RequestBody Drug drug) {
        return new ResponseEntity<>(drugService.saveDrug(drug), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Drug> updateDrug(@PathVariable Integer id, @RequestBody Drug drug) {
        Optional<Drug> existingDrug = drugService.getDrugById(id);
        if (existingDrug.isPresent()) {
            drug.setDrugId(id);
            return ResponseEntity.ok(drugService.saveDrug(drug));
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteDrug(@PathVariable Integer id) {
        drugService.deleteDrug(id);
        return ResponseEntity.noContent().build();
    }
}
