package com.hospital.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.hospital.entity.User;
import com.hospital.entity.Role;
import com.hospital.entity.Patient;
import com.hospital.entity.Doctor;
import com.hospital.service.UserService;
import com.hospital.service.PatientService;
import com.hospital.service.DoctorService;
import com.hospital.repository.RoleRepository;

import java.util.HashMap;
import java.util.Map;
import java.util.Collections;
import java.util.Set;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserDetailsService userDetailsService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private UserService userService;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PatientService patientService;

    @Autowired
    private DoctorService doctorService;

    // 登录API
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> loginRequest, HttpServletRequest request) {
        String username = loginRequest.get("username");
        String password = loginRequest.get("password");

        try {
            logger.info("Login attempt for user: {}", username);
            
            // 认证用户
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password)
            );

            // 设置认证信息到上下文
            SecurityContextHolder.getContext().setAuthentication(authentication);
            HttpSession session = request.getSession(true);
            session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, SecurityContextHolder.getContext());

            // 获取用户详情
            UserDetails userDetails = userDetailsService.loadUserByUsername(username);

            // 返回登录成功信息
            Map<String, Object> response = new HashMap<>();
            response.put("message", "Login successful");
            response.put("username", userDetails.getUsername());
            response.put("roles", userDetails.getAuthorities());

            logger.info("Login successful for user: {}", username);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            logger.error("Login failed for user {}: {}", username, e.getMessage());
            Map<String, String> response = new HashMap<>();
            response.put("message", "Invalid username or password");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody Map<String, Object> body) {
        try {
            String username = (String) body.get("username");
            String password = (String) body.get("password");
            String roleInput = (String) body.get("role");

            if (username == null || password == null || roleInput == null) {
                Map<String, String> resp = new HashMap<>();
                resp.put("message", "Invalid register data");
                return new ResponseEntity<>(resp, HttpStatus.BAD_REQUEST);
            }

            if (userService.existsByUsername(username)) {
                Map<String, String> resp = new HashMap<>();
                resp.put("message", "Username already exists");
                return new ResponseEntity<>(resp, HttpStatus.CONFLICT);
            }

            String roleName = roleInput.equalsIgnoreCase("doctor") ? "ROLE_DOCTOR" : "ROLE_PATIENT";
            Role role = roleRepository.findByRoleName(roleName);
            if (role == null) {
                role = new Role();
                role.setRoleName(roleName);
                role = roleRepository.save(role);
            }

            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setStatus("A");
            user.setRoles(Set.copyOf(Collections.singleton(role)));
            User savedUser = userService.saveUser(user);

            if (roleName.equals("ROLE_PATIENT")) {
                Object patientInfoObj = body.get("patientInfo");
                if (patientInfoObj instanceof Map) {
                    Map<?, ?> p = (Map<?, ?>) patientInfoObj;
                    Patient patient = new Patient();
                    patient.setUser(savedUser);
                    patient.setPatName((String) p.getOrDefault("patName", ""));
                    String name = (String) p.getOrDefault("patName", "");
                    patient.setPatSurname(name);
                    patient.setPatFirstname(name);
                    Object ageObj = p.get("patAge");
                    Integer age = null;
                    if (ageObj instanceof Number) {
                        age = ((Number) ageObj).intValue();
                    } else if (ageObj instanceof String) {
                        try { age = Integer.parseInt((String) ageObj); } catch (Exception ignored) {}
                    }
                    patient.setPatAge(age != null ? age : 0);
                    patient.setPatSex((String) p.getOrDefault("patSex", "男"));
                    patient.setPatActor("患者");
                    patient.setPatContactPerson((String) p.getOrDefault("patContactPerson", ""));
                    patient.setPatTel((String) p.getOrDefault("patTel", ""));
                    patient.setPatStatus("A");
                    patientService.savePatient(patient);
                }
            } else if (roleName.equals("ROLE_DOCTOR")) {
                Object doctorInfoObj = body.get("doctorInfo");
                if (doctorInfoObj instanceof Map) {
                    Map<?, ?> d = (Map<?, ?>) doctorInfoObj;
                    Doctor doctor = new Doctor();
                    doctor.setUser(savedUser);
                    doctor.setDocName((String) d.getOrDefault("docName", ""));
                    doctor.setDocDept((String) d.getOrDefault("docDept", ""));
                    doctor.setDocTitle((String) d.getOrDefault("docTitle", ""));
                    doctor.setDocSpecialty((String) d.getOrDefault("docSpecialty", ""));
                    doctorService.saveDoctor(doctor);
                }
            }

            Map<String, Object> resp = new HashMap<>();
            resp.put("message", "Register successful");
            resp.put("username", savedUser.getUsername());
            return new ResponseEntity<>(resp, HttpStatus.CREATED);
        } catch (Exception e) {
            Map<String, String> resp = new HashMap<>();
            resp.put("message", "Register failed");
            return new ResponseEntity<>(resp, HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 注销API
    @PostMapping("/logout")
    public ResponseEntity<?> logout() {
        SecurityContextHolder.clearContext();
        Map<String, String> response = new HashMap<>();
        response.put("message", "Logout successful");
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    // 获取当前用户信息
    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            Map<String, Object> response = new HashMap<>();
            response.put("username", userDetails.getUsername());
            response.put("roles", userDetails.getAuthorities());
            return new ResponseEntity<>(response, HttpStatus.OK);
        } else {
            Map<String, String> response = new HashMap<>();
            response.put("message", "Not authenticated");
            return new ResponseEntity<>(response, HttpStatus.UNAUTHORIZED);
        }
    }
}
