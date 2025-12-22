package com.hospital.service;

import com.hospital.entity.User;
import java.util.List;
import java.util.Optional;

public interface UserService {
    List<User> getAllUsers();
    Optional<User> getUserById(Integer id);
    User saveUser(User user);
    void deleteUser(Integer id);
    User findByUsername(String username);
    boolean existsByUsername(String username);
}
