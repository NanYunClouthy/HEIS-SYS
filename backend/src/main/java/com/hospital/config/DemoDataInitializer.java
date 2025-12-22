package com.hospital.config;

import com.hospital.entity.User;
import com.hospital.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Arrays;
import java.util.List;

@Configuration
public class DemoDataInitializer implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(DemoDataInitializer.class);

    private static final List<String> DEMO_USERNAMES = Arrays.asList("admin1", "doctor1", "patient1");
    private static final String DEMO_PASSWORD = "123456";

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) {
        for (String username : DEMO_USERNAMES) {
            User user = userRepository.findByUsername(username);
            if (user != null) {
                String encoded = passwordEncoder.encode(DEMO_PASSWORD);
                user.setPassword(encoded);
                userRepository.save(user);
                logger.info("Initialized password for demo user '{}' to default.", username);
            } else {
                logger.warn("Demo user '{}' not found in database.", username);
            }
        }
    }
}
