package com.hospital.controller;

import com.hospital.entity.Doctor;
import com.hospital.entity.User;
import com.hospital.entity.Role;
import com.hospital.repository.UserRepository;
import com.hospital.repository.RoleRepository;
import com.hospital.service.impl.DoctorServiceImpl;
import com.hospital.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@RestController
@RequestMapping("/doctors")
@CrossOrigin(origins = "*", maxAge = 3600)
public class DoctorController {

    @Autowired
    private DoctorServiceImpl doctorService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @GetMapping
    public ResponseEntity<?> getAll() {
        return new ResponseEntity<>(doctorService.getAllDoctors(), HttpStatus.OK);
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getById(@PathVariable Integer id) {
        return doctorService.getDoctorById(id)
                .map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @PostMapping
    public ResponseEntity<?> create(@RequestBody Map<String, Object> body) {
        try {
            String username = (String) body.get("username");
            String password = (String) body.get("password");
            
            if (username == null || password == null) {
                 Map<String, String> resp = new HashMap<>();
                 resp.put("message", "Username and password are required");
                 return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
            }
            
            if (userService.existsByUsername(username)) {
                Map<String, String> resp = new HashMap<>();
                resp.put("message", "Username already exists");
                return new ResponseEntity<>(resp, HttpStatus.CONFLICT);
            }

            Role role = roleRepository.findByRoleName("ROLE_DOCTOR");
            if (role == null) {
                role = new Role();
                role.setRoleName("ROLE_DOCTOR");
                role = roleRepository.save(role);
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setStatus("A");
            user.setRoles(Collections.singleton(role));
            
            User savedUser = userService.saveUser(user);

            Doctor doctor = new Doctor();
            doctor.setUser(savedUser);
            doctor.setDocName((String) body.get("docName"));
            doctor.setDocDept((String) body.get("docDept"));
            doctor.setDocTitle((String) body.get("docTitle"));
            doctor.setDocSpecialty((String) body.get("docSpecialty"));
            
            Doctor saved = doctorService.saveDoctor(doctor);
            return new ResponseEntity<>(saved, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>("Error: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> update(@PathVariable Integer id, @RequestBody Doctor doctor) {
        return doctorService.getDoctorById(id).map(d -> {
            doctor.setDocId(id);
            return new ResponseEntity<>(doctorService.saveDoctor(doctor), HttpStatus.OK);
        }).orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> delete(@PathVariable Integer id) {
        doctorService.deleteDoctor(id);
        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }

    @GetMapping("/me")
    public ResponseEntity<?> getMyDoctorProfile() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return new ResponseEntity<>(HttpStatus.UNAUTHORIZED);
        }
        String username = authentication.getName();
        User user = userRepository.findByUsername(username);
        if (user == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        Doctor doctor = doctorService.getDoctorByUserId(user.getUserId());
        if (doctor == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(doctor, HttpStatus.OK);
    }

    @GetMapping("/dept/{dept}")
    public ResponseEntity<List<Doctor>> getDoctorsByDept(@PathVariable String dept) {
        return new ResponseEntity<>(doctorService.getDoctorsByDept(dept), HttpStatus.OK);
    }
}
