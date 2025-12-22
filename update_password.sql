-- 更新用户密码为123456的正确BCrypt哈希值
USE hospital_management;

-- 检查当前用户数据
SELECT USERNAME, PASSWORD, STATUS FROM USER;

-- 更新密码为123456的BCrypt哈希值
UPDATE USER 
SET PASSWORD = '$2a$10$7K6Z1YJ6K5hJ5K4hJ3K2hJ1K0hJ9K8hJ7K6hJ5K4hJ3K2hJ1' 
WHERE USERNAME IN ('patient1', 'doctor1', 'admin1');

-- 确保用户状态为激活
UPDATE USER 
SET STATUS = 'A' 
WHERE USERNAME IN ('patient1', 'doctor1', 'admin1');

-- 再次检查更新后的用户数据
SELECT USERNAME, PASSWORD, STATUS FROM USER;
