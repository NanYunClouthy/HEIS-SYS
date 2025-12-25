package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Data
@Entity
@Table(name = "DOCTOR")
@JsonIgnoreProperties({"user"})
public class Doctor {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "DOC_ID")
    private Integer docId;

    @OneToOne(optional = true)
    @JoinColumn(name = "USER_ID", unique = true)
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
