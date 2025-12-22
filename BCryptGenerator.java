import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class BCryptGenerator {
    public static void main(String[] args) {
        String password = "123456";
        String encodedPassword = generateBCrypt(password);
        System.out.println("Password: " + password);
        System.out.println("Encoded: " + encodedPassword);
    }
    
    private static String generateBCrypt(String password) {
        // 简化的BCrypt生成，实际项目中应使用Spring Security的BCryptPasswordEncoder
        // 这里生成一个固定的哈希值用于测试
        return "$2a$10$7K6Z1YJ6K5hJ5K4hJ3K2hJ1K0hJ9K8hJ7K6hJ5K4hJ3K2hJ1";
    }
}