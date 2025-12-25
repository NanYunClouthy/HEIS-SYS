package com.hospital.entity;

import javax.persistence.*;
import lombok.Data;
import java.util.Set;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Data
@Entity
@Table(name = "USER")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "USER_ID")
    private Integer userId;

    @Column(name = "USERNAME", nullable = false, unique = true, length = 50)
    private String username;

    @Column(name = "PASSWORD", nullable = false, length = 255)
    private String password;

    @Column(name = "EMAIL", length = 100)
    private String email;

    @Column(name = "PHONE", length = 20)
    private String phone;

    @Column(name = "STATUS", nullable = false, length = 1, columnDefinition = "char default 'A'")
    private String status;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
        name = "USER_ROLE",
        joinColumns = @JoinColumn(name = "USER_ID"),
        inverseJoinColumns = @JoinColumn(name = "ROLE_ID")
    )
    @JsonIgnoreProperties(ignoreUnknown = true)
    private Set<Role> roles;
}
