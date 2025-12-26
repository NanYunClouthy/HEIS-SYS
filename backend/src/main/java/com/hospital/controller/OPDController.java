package com.hospital.controller;

import com.hospital.entity.OPD;
import com.hospital.entity.Patient;
import com.hospital.entity.Doctor;
import com.hospital.entity.User;
import com.hospital.repository.UserRepository;
import com.hospital.service.OPDService;
import com.hospital.service.PatientService;
import com.hospital.service.DoctorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/opds")
@CrossOrigin(origins = "*", maxAge = 3600)
public class OPDController {

    @Autowired
    private OPDService opdService;

    @Autowired
    private PatientService patientService;

    @Autowired
    private DoctorService doctorService;

    @Autowired
    private UserRepository userRepository;

    // 获取所有OPD记录
    @GetMapping
    public ResponseEntity<List<OPD>> getAllOPDs() {
        List<OPD> opds = opdService.getAllOPDs();
        return new ResponseEntity<>(opds, HttpStatus.OK);
    }

    // 根据ID获取OPD记录
    @GetMapping("/{id}")
    public ResponseEntity<OPD> getOPDById(@PathVariable Integer id) {
        Optional<OPD> opd = opdService.getOPDById(id);
        return opd.map(ResponseEntity::ok)
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    // 创建OPD记录（挂号）
    @PostMapping
    public ResponseEntity<?> createOPD(@RequestBody OPD requestOpd) {
        try {
            OPD newOpd = new OPD();
            newOpd.setOpdDate(requestOpd.getOpdDate());
            newOpd.setOpdTime(requestOpd.getOpdTime());
            newOpd.setOpdDept(requestOpd.getOpdDept());

            if (requestOpd.getDoctor() != null && requestOpd.getDoctor().getDocId() != null) {
                Optional<Doctor> doctorOpt = doctorService.getDoctorById(requestOpd.getDoctor().getDocId());
                if (doctorOpt.isPresent()) {
                    newOpd.setDoctor(doctorOpt.get());
                    newOpd.setOpdDept(doctorOpt.get().getDocDept());
                } else {
                    return new ResponseEntity<>("挂号失败: 找不到指定的医生", HttpStatus.BAD_REQUEST);
                }
            }

            // 如果请求中未提供状态，默认为1
            newOpd.setOpdStats(requestOpd.getOpdStats() != null ? requestOpd.getOpdStats() : 1);

            // 确保Patient对象是从数据库加载的完整实体
            if (requestOpd.getPatient() != null && requestOpd.getPatient().getPatId() != null) {
                Optional<Patient> patientOpt = patientService.getPatientById(requestOpd.getPatient().getPatId());
                if (patientOpt.isPresent()) {
                    newOpd.setPatient(patientOpt.get());
                } else {
                    return new ResponseEntity<>("挂号失败: 找不到指定的患者信息", HttpStatus.BAD_REQUEST);
                }
            } else {
                return new ResponseEntity<>("挂号失败: 患者信息缺失", HttpStatus.BAD_REQUEST);
            }
            
            OPD savedOPD = opdService.saveOPD(newOpd);
            return new ResponseEntity<>(savedOPD, HttpStatus.CREATED);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("挂号失败: " + e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    // 获取待就诊患者列表
    @GetMapping("/waiting")
    public ResponseEntity<List<OPD>> getWaitingPatients() {
        // 1表示待就诊状态
        List<OPD> waitingPatients = opdService.getWaitingPatients(1);
        return new ResponseEntity<>(waitingPatients, HttpStatus.OK);
    }

    // 根据科室获取待就诊患者列表
    @GetMapping("/waiting/{dept}")
    public ResponseEntity<List<OPD>> getWaitingPatientsByDept(@PathVariable String dept) {
        // 1表示待就诊状态
        List<OPD> waitingPatients = opdService.getWaitingPatientsByDept(dept, 1);
        return new ResponseEntity<>(waitingPatients, HttpStatus.OK);
    }

    // 获取当前医生的待就诊患者列表
    @GetMapping("/waiting/my")
    public ResponseEntity<List<OPD>> getMyWaitingPatients() {
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
        
        // 1表示待就诊状态
        List<OPD> waitingPatients = opdService.getWaitingPatientsByDoctor(doctor.getDocId(), 1);
        return new ResponseEntity<>(waitingPatients, HttpStatus.OK);
    }

    // 叫号
    @PutMapping("/{id}/call")
    public ResponseEntity<OPD> callPatient(@PathVariable Integer id) {
        OPD calledOPD = opdService.callPatient(id);
        if (calledOPD != null) {
            return new ResponseEntity<>(calledOPD, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    // 过号
    @PutMapping("/{id}/skip")
    public ResponseEntity<OPD> skipPatient(@PathVariable Integer id) {
        OPD skippedOPD = opdService.skipPatient(id);
        if (skippedOPD != null) {
            return new ResponseEntity<>(skippedOPD, HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }
}
