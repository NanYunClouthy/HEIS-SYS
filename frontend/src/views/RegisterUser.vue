<template>
  <div class="register-user-container">
    <h1>用户注册</h1>
    
    <!-- 错误信息 -->
    <div class="error-message" v-if="errorMessage">
      {{ errorMessage }}
      <button @click="errorMessage = ''">关闭</button>
    </div>
    
    <!-- 成功信息 -->
    <div class="success-message" v-if="successMessage">
      {{ successMessage }}
      <button @click="successMessage = ''">关闭</button>
    </div>
    
    <!-- 加载状态 -->
    <div class="loading-overlay" v-if="isLoading">
      <div class="loading-spinner"></div>
      <p>处理中...</p>
    </div>
    
    <div class="register-form-container">
      <form @submit.prevent="handleRegister" class="register-form">
        <div class="form-row">
          <div class="form-group">
            <label for="username">用户名</label>
            <input 
              type="text" 
              id="username" 
              v-model="registerForm.username" 
              placeholder="请输入用户名"
              required
              :disabled="isLoading"
            >
          </div>
          <div class="form-group">
            <label for="password">密码</label>
            <input 
              type="password" 
              id="password" 
              v-model="registerForm.password" 
              placeholder="请输入密码"
              required
              :disabled="isLoading"
            >
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label for="passwordConfirm">确认密码</label>
            <input 
              type="password" 
              id="passwordConfirm" 
              v-model="registerForm.passwordConfirm" 
              placeholder="请再次输入密码"
              required
              :disabled="isLoading"
            >
          </div>
          <div class="form-group">
            <label for="role">角色</label>
            <select id="role" v-model="registerForm.role" required :disabled="isLoading">
              <option value="">请选择角色</option>
              <option value="patient">患者</option>
              <option value="doctor">医生</option>
            </select>
          </div>
        </div>
        
        <!-- 患者专用信息 -->
        <div v-if="registerForm.role === 'patient'" class="patient-info">
          <h3>患者信息</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="patName">姓名</label>
              <input 
                type="text" 
                id="patName" 
                v-model="registerForm.patName" 
                placeholder="请输入姓名"
                required
                :disabled="isLoading"
              >
            </div>
            <div class="form-group">
              <label for="patAge">年龄</label>
              <input 
                type="number" 
                id="patAge" 
                v-model="registerForm.patAge" 
                placeholder="请输入年龄"
                required
                :disabled="isLoading"
              >
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="patSex">性别</label>
              <select id="patSex" v-model="registerForm.patSex" required :disabled="isLoading">
                <option value="男">男</option>
                <option value="女">女</option>
              </select>
            </div>
            <div class="form-group">
              <label for="patTel">联系电话</label>
              <input 
                type="tel" 
                id="patTel" 
                v-model="registerForm.patTel" 
                placeholder="请输入联系电话"
                required
                :disabled="isLoading"
              >
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="patId">病历号</label>
              <input 
                type="number" 
                id="patId" 
                v-model="registerForm.patId" 
                placeholder="自动生成"
                readonly
                :disabled="isLoading"
              >
            </div>
            <div class="form-group">
              <label for="patContactPerson">联系人</label>
              <input 
                type="text" 
                id="patContactPerson" 
                v-model="registerForm.patContactPerson" 
                placeholder="请输入联系人姓名"
                required
                :disabled="isLoading"
              >
            </div>
          </div>
        </div>
        
        <!-- 医生专用信息 -->
        <div v-if="registerForm.role === 'doctor'" class="doctor-info">
          <h3>医生信息</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="docName">姓名</label>
              <input 
                type="text" 
                id="docName" 
                v-model="registerForm.docName" 
                placeholder="请输入姓名"
                required
                :disabled="isLoading"
              >
            </div>
            <div class="form-group">
              <label for="docDept">科室</label>
              <input 
                type="text" 
                id="docDept" 
                v-model="registerForm.docDept" 
                placeholder="请输入科室"
                required
                :disabled="isLoading"
              >
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="docTitle">职称</label>
              <input 
                type="text" 
                id="docTitle" 
                v-model="registerForm.docTitle" 
                placeholder="请输入职称"
                required
                :disabled="isLoading"
              >
            </div>
            <div class="form-group">
              <label for="docSpecialty">专长</label>
              <input 
                type="text" 
                id="docSpecialty" 
                v-model="registerForm.docSpecialty" 
                placeholder="请输入专长"
                required
                :disabled="isLoading"
              >
            </div>
          </div>
        </div>
        
        <div class="form-actions">
          <button type="submit" class="primary" :disabled="isLoading">注册</button>
          <button type="button" @click="resetForm" :disabled="isLoading">重置</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'

// 创建API客户端
const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export default {
  name: 'RegisterUser',
  setup() {
    const router = useRouter()
    
    const registerForm = ref({
      username: '',
      password: '',
      passwordConfirm: '',
      role: '',
      // 患者信息
      patName: '',
      patAge: '',
      patSex: '男',
      patTel: '',
      patId: null,
      patContactPerson: '',
      // 医生信息
      docName: '',
      docDept: '',
      docTitle: '',
      docSpecialty: ''
    })
    
    const errorMessage = ref('')
    const successMessage = ref('')
    const isLoading = ref(false)
    
    // 自动生成病历号
    const generatePatId = async () => {
      try {
        // 获取当前最大病历号
        const response = await apiClient.get('/patients/max-id')
        const maxId = response.data || 2 // 如果没有返回数据，从3开始
        registerForm.value.patId = maxId + 1
      } catch (error) {
        console.error('获取最大病历号失败:', error)
        // 如果获取失败，默认从3开始
        registerForm.value.patId = 3
      }
    }
    
    // 处理注册
    const handleRegister = async () => {
      isLoading.value = true
      errorMessage.value = ''
      successMessage.value = ''
      
      // 表单验证
      if (registerForm.value.password !== registerForm.value.passwordConfirm) {
        errorMessage.value = '两次输入的密码不一致'
        isLoading.value = false
        return
      }
      
      // 验证必填字段
      if (registerForm.value.role === 'patient') {
        if (!registerForm.value.patName || !registerForm.value.patAge || !registerForm.value.patSex || !registerForm.value.patTel || !registerForm.value.patContactPerson) {
          errorMessage.value = '请填写完整的患者信息'
          isLoading.value = false
          return
        }
      } else if (registerForm.value.role === 'doctor') {
        if (!registerForm.value.docName || !registerForm.value.docDept || !registerForm.value.docTitle || !registerForm.value.docSpecialty) {
          errorMessage.value = '请填写完整的医生信息'
          isLoading.value = false
          return
        }
      }
      
      try {
        // 准备注册数据
        const registerData = {
          username: registerForm.value.username,
          password: registerForm.value.password,
          role: registerForm.value.role
        }
        
        // 添加角色特定信息
        if (registerForm.value.role === 'patient') {
          registerData.patientInfo = {
            patName: registerForm.value.patName,
            patAge: registerForm.value.patAge,
            patSex: registerForm.value.patSex,
            patTel: registerForm.value.patTel,
            patId: registerForm.value.patId,
            patContactPerson: registerForm.value.patContactPerson,
            patStatus: 'A'
          }
        } else if (registerForm.value.role === 'doctor') {
          registerData.doctorInfo = {
            docName: registerForm.value.docName,
            docDept: registerForm.value.docDept,
            docTitle: registerForm.value.docTitle,
            docSpecialty: registerForm.value.docSpecialty,
            docStatus: 'A'
          }
        }
        
        // 调用注册API
        const response = await apiClient.post('/auth/register', registerData)
        
        successMessage.value = '注册成功！请登录'
        
        // 重置表单
        resetForm()
        
        // 3秒后跳转到登录页面
        setTimeout(() => {
          router.push('/login')
        }, 3000)
        
      } catch (error) {
        console.error('注册失败:', error)
        errorMessage.value = error.response?.data?.message || '注册失败，请稍后重试'
      } finally {
        isLoading.value = false
      }
    }
    
    // 重置表单
    const resetForm = () => {
      registerForm.value = {
        username: '',
        password: '',
        passwordConfirm: '',
        role: '',
        patName: '',
        patAge: '',
        patSex: '男',
        patTel: '',
        patId: null,
        patContactPerson: '',
        docName: '',
        docDept: '',
        docTitle: '',
        docSpecialty: ''
      }
    }
    
    // 监听角色变化，当角色为患者时自动生成病历号
    const handleRoleChange = () => {
      if (registerForm.value.role === 'patient') {
        generatePatId()
      }
    }
    
    onMounted(() => {
      // 监听角色变化
      registerForm.value.role = ''
    })
    
    return {
      registerForm,
      errorMessage,
      successMessage,
      isLoading,
      handleRegister,
      resetForm,
      handleRoleChange
    }
  }
}
</script>

<style scoped>
.register-user-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  position: relative;
}

.register-form-container {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.register-form {
  display: flex;
  flex-direction: column;
}

.form-row {
  display: flex;
  gap: 15px;
  margin-bottom: 15px;
  flex-wrap: wrap;
}

.form-group {
  flex: 1;
  min-width: 200px;
  display: flex;
  flex-direction: column;
}

label {
  margin-bottom: 5px;
  font-weight: bold;
  color: #666;
}

input, select {
  padding: 10px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.3s;
}

input:focus, select:focus {
  outline: none;
  border-color: #4CAF50;
  box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
}

input:disabled, select:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
}

.form-actions {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}

button {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

button:hover:not(:disabled) {
  opacity: 0.8;
}

button:disabled {
  background: #cccccc;
  cursor: not-allowed;
}

button.primary {
  background: #4CAF50;
  color: white;
}

.patient-info, .doctor-info {
  margin-top: 20px;
  padding-top: 20px;
  border-top: 1px solid #eee;
}

.patient-info h3, .doctor-info h3 {
  margin-bottom: 15px;
  color: #555;
}

.error-message {
  background: #f8d7da;
  color: #721c24;
  padding: 15px;
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
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}

.success-message {
  background: #d4edda;
  color: #155724;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.success-message button {
  background: #c3e6cb;
  color: #155724;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
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
</style>