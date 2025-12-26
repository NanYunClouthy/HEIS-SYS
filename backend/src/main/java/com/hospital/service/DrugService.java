package com.hospital.service;

import com.hospital.entity.Drug;
import java.util.List;
import java.util.Optional;

public interface DrugService {
    List<Drug> getAllDrugs();
    Optional<Drug> getDrugById(Integer id);
    Drug saveDrug(Drug drug);
    void deleteDrug(Integer id);
}
