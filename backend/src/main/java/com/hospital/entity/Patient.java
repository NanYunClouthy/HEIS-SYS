package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Data
@Entity
@Table(name = "PATIENT")
@JsonIgnoreProperties({"user"})
public class Patient {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "PAT_ID")
    private Integer patId;

    @OneToOne(optional = true)
    @JoinColumn(name = "USER_ID", unique = true)
    private User user;

    @Column(name = "PAT_NAME", nullable = false, length = 50)
    private String patName;

    @Column(name = "PAT_SURNAME", nullable = false, length = 50)
    private String patSurname;

    @Column(name = "PAT_FIRSTNAME", nullable = false, length = 100)
    private String patFirstname;

    @Column(name = "PAT_AGE", nullable = false)
    private Integer patAge;

    @Column(name = "PAT_SEX", nullable = false, length = 1)
    private String patSex;

    @Column(name = "PAT_ACTOR", nullable = false, length = 50)
    private String patActor;

    @Column(name = "PAT_CONTACT_PERSON", nullable = false, length = 50)
    private String patContactPerson;

    @Column(name = "PAT_TEL", nullable = false, length = 20)
    private String patTel;

    @Column(name = "PAT_STATUS", nullable = false, length = 1)
    private String patStatus;
}
