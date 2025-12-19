package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;
import java.util.Date;

@Data
@Entity
@Table(name = "OPD")
public class OPD {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "OPD_ID")
    private Integer opdId;

    @Column(name = "OPD_DATE", nullable = false)
    private Date opdDate;

    @Column(name = "OPD_TIME", nullable = false)
    private Date opdTime;

    @Column(name = "OPD_DEPT", nullable = false, length = 50)
    private String opdDept;

    @ManyToOne
    @JoinColumn(name = "OPD_PAT_ID", nullable = false)
    private Patient patient;

    @Column(name = "OPD_STATS", nullable = false, columnDefinition = "int default 1")
    private Integer opdStats;
}
