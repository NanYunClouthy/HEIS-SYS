package com.hospital.entity;

import lombok.Data;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

@Data
@Entity
@Table(name = "prescription")
public class Prescription {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PRES_ID")
    private Integer presId;

    @ManyToOne
    @JoinColumn(name = "VIS_ID", nullable = false)
    private OPDVisitHistory visit;

    @Column(name = "PRES_TOTAL_AMOUNT", nullable = false, precision = 10, scale = 2)
    private BigDecimal presTotalAmount;

    @Column(name = "PRES_STATUS", nullable = false)
    private Integer presStatus; // 1-Created, 2-Paid, 3-Dispensed, 0-Cancelled

    @Column(name = "PRES_CREATED_TIME", nullable = false, insertable = false, updatable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date presCreatedTime;
    
    @OneToMany(mappedBy = "prescription", cascade = CascadeType.ALL)
    private List<PrescriptionDetail> details;
}
