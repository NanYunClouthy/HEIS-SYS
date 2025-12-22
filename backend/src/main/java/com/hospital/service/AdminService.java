package com.hospital.service;

import com.hospital.entity.Admin;
import java.util.List;
import java.util.Optional;

public interface AdminService {
    List<Admin> getAllAdmins();
    Optional<Admin> getAdminById(Integer id);
    Admin saveAdmin(Admin admin);
    void deleteAdmin(Integer id);
    Admin getAdminByUserId(Integer userId);
}
