<template>
  <div id="app">
    <header>
      <h1>医院管理系统</h1>
      <nav>
        <!-- 公共导航 -->
        
        
        <!-- 患者导航 -->
        <router-link v-if="hasRole('PATIENT')" to="/my-center">个人中心</router-link>
        <router-link v-if="hasRole('PATIENT')" to="/register">挂号</router-link>
        <router-link v-if="hasRole('PATIENT')" to="/visit-history">就诊记录</router-link>
        
        <!-- 医生导航 -->
        <router-link v-if="hasRole('DOCTOR')" to="/waiting-list">候诊列表</router-link>
        <router-link v-if="hasRole('DOCTOR')" to="/visit-history">就诊记录</router-link>
        
        <!-- 管理员导航 -->
        <router-link v-if="hasRole('ADMIN')" to="/admin">管理后台</router-link>
        <router-link v-if="hasRole('ADMIN')" to="/">患者管理</router-link>
        <router-link v-if="hasRole('ADMIN')" to="/doctors">医生管理</router-link>
        <router-link v-if="hasRole('ADMIN')" to="/waiting-list">候诊列表</router-link>
        <router-link v-if="hasRole('ADMIN')" to="/admin/drugs">药品管理</router-link>
        <router-link v-if="hasRole('ADMIN')" to="/visit-history">就诊记录</router-link>
        
        <!-- 登录/注销按钮 -->
        <router-link v-if="!isLoggedIn" to="/login" class="login-btn">登录</router-link>
        <button v-if="isLoggedIn" @click="handleLogout" class="logout-btn">注销</button>
      </nav>
    </header>
    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { authApi } from './api/auth'

const router = useRouter()

// 登录状态
const isLoggedIn = ref(false)
const user = ref(null)

// 检查登录状态
const checkLoginStatus = () => {
  const savedUser = localStorage.getItem('user')
  if (savedUser) {
    user.value = JSON.parse(savedUser)
    isLoggedIn.value = true
  }
  else {
    user.value = null
    isLoggedIn.value = false
  }
}

// 检查用户是否有特定角色
const hasRole = (role) => {
  if (!user.value) return false
  if (user.value.roles && Array.isArray(user.value.roles)) {
    return user.value.roles.some(r => r.authority === `ROLE_${role}`)
  }
  if (user.value.role) {
    const r = (user.value.role || '').toUpperCase()
    return r === role
  }
  return false
}

// 处理注销
const handleLogout = async () => {
  try {
    await authApi.logout()
    localStorage.removeItem('user')
    isLoggedIn.value = false
    user.value = null
    router.push('/login')
  } catch (error) {
    console.error('注销失败:', error)
    // 无论API是否成功，都清除本地存储
    localStorage.removeItem('user')
    isLoggedIn.value = false
    user.value = null
    router.push('/login')
  }
}

// 初始化
onMounted(() => {
  checkLoginStatus()
  window.addEventListener('storage', (e) => {
    if (e.key === 'user') {
      checkLoginStatus()
    }
  })
  window.addEventListener('loginStateChanged', () => {
    checkLoginStatus()
  })
})
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: Arial, sans-serif;
  line-height: 1.6;
  color: #333;
}

#app {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

header {
  background-color: #4CAF50;
  color: white;
  padding: 15px;
  margin-bottom: 20px;
  border-radius: 5px;
}

header h1 {
  text-align: center;
  font-size: 24px;
  margin-bottom: 15px;
}

nav {
  display: flex;
  justify-content: center;
  gap: 15px;
}

nav a {
  color: white;
  text-decoration: none;
  padding: 8px 16px;
  border-radius: 3px;
  background-color: rgba(255, 255, 255, 0.2);
  transition: background-color 0.3s;
}

nav a:hover {
  background-color: rgba(255, 255, 255, 0.3);
}

nav a.router-link-active {
  background-color: rgba(255, 255, 255, 0.4);
  font-weight: bold;
}

nav .login-btn {
  background-color: #2196F3;
}

nav button.logout-btn {
  padding: 8px 16px;
  background-color: #f44336;
  color: white;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  transition: background-color 0.3s;
}

nav button.logout-btn:hover {
  background-color: rgba(244, 67, 54, 0.8);
  opacity: 0.8;
}

main {
  background-color: #f4f4f4;
  padding: 20px;
  border-radius: 5px;
}

button {
  padding: 8px 16px;
  margin: 5px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  font-size: 14px;
}

button:hover {
  opacity: 0.8;
}

button.primary {
  background-color: #4CAF50;
  color: white;
}

button.danger {
  background-color: #f44336;
  color: white;
}

button.warning {
  background-color: #ff9800;
  color: white;
}

form {
  background-color: white;
  padding: 20px;
  border-radius: 5px;
  margin-bottom: 20px;
}

form div {
  margin-bottom: 15px;
}

form label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

form input, form select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 3px;
}

table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  border-radius: 5px;
  overflow: hidden;
}

table th, table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

table th {
  background-color: #4CAF50;
  color: white;
}

table tr:hover {
  background-color: #f5f5f5;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  padding: 30px;
  border-radius: 5px;
  width: 90%;
  max-width: 500px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-header h2 {
  margin: 0;
  font-size: 20px;
}

.close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #aaa;
}

.close:hover {
  color: #333;
}
</style>
