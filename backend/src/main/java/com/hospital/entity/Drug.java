package com.hospital.entity;

import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;

@Data
@Entity
@Table(name = "drug")
public class Drug {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DRUG_ID")
    private Integer drugId;

    @Column(name = "DRUG_NAME", nullable = false, length = 100)
    private String drugName;

    @Column(name = "DRUG_CODE", nullable = false, length = 50, unique = true)
    private String drugCode;

    @Column(name = "DRUG_PRICE", nullable = false, precision = 10, scale = 2)
    private BigDecimal drugPrice;

    @Column(name = "DRUG_STOCK", nullable = false)
    private Integer drugStock;

    @Column(name = "DRUG_UNIT", nullable = false, length = 20)
    private String drugUnit;

    @Column(name = "DRUG_SPEC", length = 50)
    private String drugSpec;
}
