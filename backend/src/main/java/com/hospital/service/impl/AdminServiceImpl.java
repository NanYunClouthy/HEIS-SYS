package com.hospital.service.impl;

import com.hospital.entity.Admin;
import com.hospital.repository.AdminRepository;
import com.hospital.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private AdminRepository adminRepository;

    @Override
    public List<Admin> getAllAdmins() {
        return adminRepository.findAll();
    }

    @Override
    public Optional<Admin> getAdminById(Integer id) {
        return adminRepository.findById(id);
    }

    @Override
    public Admin saveAdmin(Admin admin) {
        return adminRepository.save(admin);
    }

    @Override
    public void deleteAdmin(Integer id) {
        adminRepository.deleteById(id);
    }

    @Override
    public Admin getAdminByUserId(Integer userId) {
        return adminRepository.findByUserUserId(userId);
    }
}
