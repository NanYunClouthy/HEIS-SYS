<template>
  <div class="login-container">
    <div class="login-box">
      <h1>医院管理系统</h1>
      <h2>用户登录</h2>
      
      <!-- 错误信息 -->
      <div class="error-message" v-if="errorMessage">
        {{ errorMessage }}
        <button @click="errorMessage = ''">关闭</button>
      </div>
      
      <!-- 加载状态 -->
      <div class="loading-overlay" v-if="isLoading">
        <div class="loading-spinner"></div>
        <p>登录中...</p>
      </div>
      
      <!-- 登录表单 -->
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="username">用户名</label>
          <input 
            type="text" 
            id="username" 
            v-model="loginForm.username" 
            placeholder="请输入用户名"
            required
            autofocus
            :disabled="isLoading"
          >
        </div>
        <div class="form-group">
          <label for="password">密码</label>
          <input 
            type="password" 
            id="password" 
            v-model="loginForm.password" 
            placeholder="请输入密码"
            required
            :disabled="isLoading"
          >
        </div>
        <div class="form-group">
          <label for="role">角色</label>
          <select id="role" v-model="loginForm.role" required :disabled="isLoading">
            <option value="">请选择角色</option>
            <option value="patient">患者</option>
            <option value="doctor">医生</option>
            <option value="admin">管理员</option>
          </select>
        </div>
        <button type="submit" class="login-btn" :disabled="isLoading">
          <span v-if="isLoading">登录中...</span>
          <span v-else>登录</span>
        </button>
      </form>
      
      <!-- 注册按钮 -->
      <div class="register-link">
        <p>还没有账号？</p>
        <router-link to="/signup" class="register-btn">立即注册</router-link>
      </div>
      
      <!-- 示例账号信息 -->
      <div class="sample-accounts">
        <h3>示例账号</h3>
        <div class="account-item">
          <p><strong>患者：</strong>patient1 / 123456</p>
        </div>
        <div class="account-item">
          <p><strong>医生：</strong>doctor1 / 123456</p>
        </div>
        <div class="account-item">
          <p><strong>管理员：</strong>admin1 / 123456</p>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import { authApi } from '../api/auth'
import { useRouter } from 'vue-router'

export default {
  name: 'Login',
  setup() {
    const router = useRouter()
    
    const loginForm = ref({
      username: '',
      password: '',
      role: ''
    })
    
    const errorMessage = ref('')
    const isLoading = ref(false)
    
    const handleLogin = async () => {
      isLoading.value = true
      errorMessage.value = ''
      
      // 表单验证
      if (!loginForm.value.username || !loginForm.value.password || !loginForm.value.role) {
        errorMessage.value = '请填写完整的登录信息'
        isLoading.value = false
        return
      }
      
      try {
        console.log('登录请求:', {
          username: loginForm.value.username,
          password: loginForm.value.password
        })
        
        const response = await authApi.login(loginForm.value.username, loginForm.value.password)
        
        console.log('登录响应:', response)
        
        // 登录成功，存储用户信息
        const userInfo = {
          ...response.data,
          role: loginForm.value.role // 存储用户选择的角色
        }
        localStorage.setItem('user', JSON.stringify(userInfo))
        window.dispatchEvent(new Event('loginStateChanged'))
        
        // 根据角色跳转到相应页面
        if (loginForm.value.role === 'patient') {
          router.push('/my-center')
        } else if (loginForm.value.role === 'doctor') {
          router.push('/waiting-list')
        } else if (loginForm.value.role === 'admin') {
          router.push('/')
        } else {
          router.push('/')
        }
      } catch (error) {
        console.error('登录失败:', error)
        errorMessage.value = error.response?.data?.message || '登录失败，请检查用户名和密码是否正确'
      } finally {
        isLoading.value = false
      }
    }
    
    return {
      loginForm,
      errorMessage,
      isLoading,
      handleLogin
    }
  }
}
</script>

<style scoped>
.login-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background-color: #f4f4f4;
  padding: 20px;
}

.login-box {
  background-color: white;
  padding: 40px;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 400px;
}

h1 {
  text-align: center;
  color: #4CAF50;
  margin-bottom: 10px;
  font-size: 24px;
}

h2 {
  text-align: center;
  color: #555;
  margin-bottom: 30px;
  font-size: 20px;
}

.form-group {
  margin-bottom: 20px;
}

label {
  display: block;
  margin-bottom: 8px;
  font-weight: bold;
  color: #666;
}

input, select {
  width: 100%;
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 16px;
  transition: border-color 0.3s;
}

input:focus, select:focus {
  outline: none;
  border-color: #4CAF50;
  box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
}

.login-btn {
  width: 100%;
  padding: 12px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.login-btn:hover:not(:disabled) {
  background-color: #45a049;
}

.login-btn:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.error-message {
  background-color: #f8d7da;
  color: #721c24;
  padding: 12px;
  border-radius: 4px;
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.error-message button {
  background: #f5c6cb;
  color: #721c24;
  border: none;
  padding: 4px 8px;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  margin: 0;
}

.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.loading-spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border-left-color: #4CAF50;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.sample-accounts {
  margin-top: 30px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.sample-accounts h3 {
  margin-bottom: 15px;
  color: #666;
  font-size: 16px;
}

.account-item {
  margin-bottom: 10px;
  padding: 10px;
  background-color: #f9f9f9;
  border-radius: 4px;
}

.account-item p {
  margin: 0;
  font-size: 14px;
}

/* 注册链接样式 */
.register-link {
  margin-top: 20px;
  text-align: center;
}

.register-link p {
  margin-bottom: 10px;
  color: #666;
  font-size: 14px;
}

.register-btn {
  display: inline-block;
  padding: 10px 20px;
  background-color: #f0f0f0;
  color: #333;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  text-decoration: none;
  transition: all 0.3s;
}

.register-btn:hover {
  background-color: #e0e0e0;
  border-color: #4CAF50;
}
</style>
