package com.hospital.service.impl;

import com.hospital.entity.User;
import com.hospital.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;

@Service
public class UserDetailsServiceImpl implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // 从数据库获取用户
        User user = userRepository.findByUsername(username);
        if (user == null) {
            throw new UsernameNotFoundException("User not found with username: " + username);
        }

        // 确保用户状态为激活
        boolean isEnabled = "A".equals(user.getStatus());
        if (!isEnabled) {
            throw new UsernameNotFoundException("User account is disabled: " + username);
        }

        // 转换角色为权限
        Set<GrantedAuthority> authorities = user.getRoles().stream()
                .map(role -> {
                    String name = role.getRoleName();
                    String authority = name != null && name.startsWith("ROLE_") ? name : "ROLE_" + name;
                    return new SimpleGrantedAuthority(authority);
                })
                .collect(Collectors.toSet());

        // 返回Spring Security User对象
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                isEnabled,
                true,
                true,
                true,
                authorities
        );
    }
}
