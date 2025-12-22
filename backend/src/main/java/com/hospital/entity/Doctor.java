package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "DOCTOR")
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DOC_ID")
    private Integer docId;

    @OneToOne
    @JoinColumn(name = "USER_ID", nullable = false, unique = true)
    private User user;

    @Column(name = "DOC_NAME", nullable = false, length = 50)
    private String docName;

    @Column(name = "DOC_DEPT", nullable = false, length = 50)
    private String docDept;

    @Column(name = "DOC_TITLE", length = 50)
    private String docTitle;

    @Column(name = "DOC_SPECIALTY", length = 100)
    private String docSpecialty;
}
