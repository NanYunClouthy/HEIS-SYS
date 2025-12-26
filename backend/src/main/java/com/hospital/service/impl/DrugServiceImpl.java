package com.hospital.service.impl;

import com.hospital.entity.Drug;
import com.hospital.repository.DrugRepository;
import com.hospital.service.DrugService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DrugServiceImpl implements DrugService {

    @Autowired
    private DrugRepository drugRepository;

    @Override
    public List<Drug> getAllDrugs() {
        return drugRepository.findAll();
    }

    @Override
    public Optional<Drug> getDrugById(Integer id) {
        return drugRepository.findById(id);
    }

    @Override
    public Drug saveDrug(Drug drug) {
        return drugRepository.save(drug);
    }

    @Override
    public void deleteDrug(Integer id) {
        drugRepository.deleteById(id);
    }
}
