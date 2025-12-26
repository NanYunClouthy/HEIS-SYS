package com.hospital.service.impl;

import com.hospital.dto.PrescriptionDTO;
import com.hospital.entity.*;
import com.hospital.repository.*;
import com.hospital.service.PrescriptionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Optional;

@Service
public class PrescriptionServiceImpl implements PrescriptionService {

    @Autowired
    private PrescriptionRepository prescriptionRepository;

    @Autowired
    private DrugRepository drugRepository;

    @Autowired
    private OPDVisitHistoryRepository opdVisitHistoryRepository;

    @Override
    @Transactional
    public Prescription createPrescription(PrescriptionDTO dto) {
        // 1. Validate Visit
        OPDVisitHistory visit = opdVisitHistoryRepository.findById(dto.getVisId())
                .orElseThrow(() -> new RuntimeException("Visit not found: " + dto.getVisId()));

        // 2. Initialize Prescription
        Prescription prescription = new Prescription();
        prescription.setVisit(visit);
        prescription.setPresStatus(1); // Created
        prescription.setPresTotalAmount(BigDecimal.ZERO);
        
        List<PrescriptionDetail> details = new ArrayList<>();
        BigDecimal totalAmount = BigDecimal.ZERO;

        // 3. Process Items
        for (PrescriptionDTO.PrescriptionItemDTO item : dto.getItems()) {
            Drug drug = drugRepository.findById(item.getDrugId())
                    .orElseThrow(() -> new RuntimeException("Drug not found: " + item.getDrugId()));

            // Check Stock
            if (drug.getDrugStock() < item.getQuantity()) {
                throw new RuntimeException("Insufficient stock for drug: " + drug.getDrugName());
            }

            // Deduct Stock
            drug.setDrugStock(drug.getDrugStock() - item.getQuantity());
            drugRepository.save(drug);

            // Create Detail
            PrescriptionDetail detail = new PrescriptionDetail();
            detail.setPrescription(prescription);
            detail.setDrug(drug);
            detail.setDetailQuantity(item.getQuantity());
            
            BigDecimal amount = drug.getDrugPrice().multiply(BigDecimal.valueOf(item.getQuantity()));
            detail.setDetailAmount(amount);
            
            details.add(detail);
            totalAmount = totalAmount.add(amount);
        }

        prescription.setDetails(details);
        prescription.setPresTotalAmount(totalAmount);
        // Note: presCreatedTime is handled by DB default or @PrePersist if we added it, 
        // but here we rely on DB default CURRENT_TIMESTAMP or we can set it explicitly if needed.
        // Since we defined `insertable = false` in entity, we let DB handle it.
        
        return prescriptionRepository.save(prescription);
    }

    @Override
    public List<Prescription> getPrescriptionsByVisitId(Integer visId) {
        return prescriptionRepository.findByVisit_VisId(visId);
    }

    @Override
    public Optional<Prescription> getPrescriptionById(Integer id) {
        return prescriptionRepository.findById(id);
    }
}
