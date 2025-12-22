package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;

@Data
@Entity
@Table(name = "ADMIN")
public class Admin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ADMIN_ID")
    private Integer adminId;

    @OneToOne
    @JoinColumn(name = "USER_ID", nullable = false, unique = true)
    private User user;

    @Column(name = "ADMIN_NAME", nullable = false, length = 50)
    private String adminName;

    @Column(name = "ADMIN_ROLE", length = 50)
    private String adminRole;
}
