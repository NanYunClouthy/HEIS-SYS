package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "ROLE")
public class Role {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ROLE_ID")
    private Integer roleId;

    @Column(name = "ROLE_NAME", nullable = false, unique = true, length = 50)
    private String roleName;
}
