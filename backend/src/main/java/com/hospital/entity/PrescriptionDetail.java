package com.hospital.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;

@Data
@Entity
@Table(name = "prescription_detail")
public class PrescriptionDetail {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DETAIL_ID")
    private Integer detailId;

    @ManyToOne
    @JoinColumn(name = "PRES_ID", nullable = false)
    @JsonIgnore
    private Prescription prescription;

    @ManyToOne
    @JoinColumn(name = "DRUG_ID", nullable = false)
    private Drug drug;

    @Column(name = "DETAIL_QUANTITY", nullable = false)
    private Integer detailQuantity;

    @Column(name = "DETAIL_AMOUNT", nullable = false, precision = 10, scale = 2)
    private BigDecimal detailAmount;
}
