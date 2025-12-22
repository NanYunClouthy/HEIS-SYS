package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;
import java.util.Date;

@Data
@Entity
@Table(name = "OPD_VISIT_HISTORY")
public class OPDVisitHistory {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "VIS_ID")
    private Integer visId;

    @ManyToOne
    @JoinColumn(name = "PAT_ID", nullable = false)
    private Patient patient;

    @Column(name = "VIS_DOC_ID", nullable = false)
    private Integer visDocId;

    @Column(name = "VIS_CASE_DESC", nullable = false, columnDefinition = "text")
    private String visCaseDesc;

    @Column(name = "VIS_DIAGNOSIS", nullable = false, length = 200)
    private String visDiagnosis;

    @Column(name = "VIS_CREATED_BY", nullable = false, length = 50)
    private String visCreatedBy;

    @Column(name = "VIS_CREATED_DATE", nullable = false)
    private Date visCreatedDate;

    @Column(name = "VIS_LAST_MODIFIED_BY", nullable = false, length = 50)
    private String visLastModifiedBy;

    @Column(name = "VIS_LAST_MODIFIED_DATE", nullable = false)
    private Date visLastModifiedDate;

    @Column(name = "VIS_NOTE", columnDefinition = "text")
    private String visNote;
}
