<template>
  <div class="register-container">
    <h1>患者挂号</h1>
    
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
    
    <!-- 患者信息 -->
    <div class="patient-info-section" v-if="patientInfo">
      <h2>患者信息</h2>
      <div class="patient-info">
        <div class="info-row">
          <div class="info-item">
            <strong>病历号：</strong>{{ patientInfo.patId }}
          </div>
          <div class="info-item">
            <strong>姓名：</strong>{{ patientInfo.patName }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>性别：</strong>{{ patientInfo.patSex }}
          </div>
          <div class="info-item">
            <strong>年龄：</strong>{{ patientInfo.patAge }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>联系电话：</strong>{{ patientInfo.patTel }}
          </div>
          <div class="info-item">
            <strong>联系人：</strong>{{ patientInfo.patContactPerson }}
          </div>
        </div>
      </div>
    </div>
    
    <!-- 挂号信息 -->
    <div class="register-section" v-if="patientInfo">
      <h2>挂号信息</h2>
      <form @submit.prevent="goPayFirst" class="register-form">
        <div class="form-row">
          <div class="form-group">
            <label for="opdDept">科室</label>
            <select id="opdDept" v-model="registerForm.opdDept" required :disabled="isLoading">
              <option value="内科">内科</option>
              <option value="外科">外科</option>
              <option value="儿科">儿科</option>
              <option value="妇产科">妇产科</option>
              <option value="眼科">眼科</option>
              <option value="耳鼻喉科">耳鼻喉科</option>
              <option value="口腔科">口腔科</option>
              <option value="皮肤科">皮肤科</option>
            </select>
          </div>
        </div>
        <div class="form-actions">
          <button type="submit" class="primary" :disabled="isLoading">确认挂号</button>
        </div>
      </form>
    </div>
    
    <!-- 未登录提示 -->
    <div class="not-logged-in" v-if="!user">
      <h2>请先登录</h2>
      <p>您需要先登录才能进行挂号操作</p>
      <router-link to="/login" class="login-link">前往登录</router-link>
    </div>
    
    <!-- 非患者角色提示 -->
    <div class="not-patient" v-if="user && role !== 'PATIENT'">
      <h2>权限不足</h2>
      <p>只有患者才能进行挂号操作</p>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { patientApi } from '../api/patient'
import { opdApi } from '../api/opd'

export default {
  name: 'Register',
  setup() {
    const router = useRouter()
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const role = (user?.role || '').toUpperCase()
    const patientInfo = ref({})
    const registerForm = ref({
      opdDept: '内科'
    })
    const errorMessage = ref('')
    const successMessage = ref('')
    const isLoading = ref(false)
    
    // 获取患者信息
    const fetchPatientInfo = async () => {
      if (!user || role !== 'PATIENT') return
      
      try {
        // 从用户名中提取患者ID，例如 'pation1' -> 1
        const username = user.username || ''
        const patientId = parseInt(username.replace(/[^0-9]/g, ''))
        
        if (patientId) {
          const res = await patientApi.getPatientById(patientId)
          patientInfo.value = res.data || {}
        } else {
          errorMessage.value = '无法从用户名中提取患者ID'
        }
      } catch (e) {
        console.error('获取患者信息失败:', e)
        errorMessage.value = e.response?.data?.message || '获取患者信息失败，请稍后重试'
      }
    }
    
    // 先付款后挂号：跳转到付款页
    const goPayFirst = async () => {
      if (!patientInfo.value.patId) {
        errorMessage.value = '患者信息未获取，请稍后重试'
        return
      }
      router.push({ 
        path: '/pay', 
        query: { 
          patId: patientInfo.value.patId, 
          opdDept: registerForm.value.opdDept 
        } 
      })
    }
    
    onMounted(() => {
      fetchPatientInfo()
    })
    
    return {
      user,
      role,
      patientInfo,
      registerForm,
      errorMessage,
      successMessage,
      isLoading,
      goPayFirst
    }
  }
}
</script>

<style scoped>
.register-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
  position: relative;
}

h1 {
  text-align: center;
  color: #333;
}

h2 {
  color: #555;
  margin-top: 30px;
  margin-bottom: 20px;
  border-bottom: 1px solid #eee;
  padding-bottom: 10px;
}

.patient-info-section,
.register-section {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* 患者信息样式 */
.patient-info {
  display: flex;
  flex-direction: column;
  gap: 15px;
}

.info-row {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.info-item {
  flex: 1;
  min-width: 200px;
  padding: 10px;
  background: white;
  border-radius: 4px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.info-item strong {
  color: #555;
  margin-right: 8px;
}

/* 挂号表单样式 */
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
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

input:focus, select:focus {
  outline: none;
  border-color: #4CAF50;
  box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
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
  background: #f0f0f0;
  color: #333;
  transition: background-color 0.3s;
}

button:hover:not(:disabled) {
  background: #e0e0e0;
}

button:disabled {
  background: #cccccc;
  cursor: not-allowed;
}

button.primary {
  background: #4CAF50;
  color: white;
}

button.primary:hover:not(:disabled) {
  background: #45a049;
}

/* 提示信息样式 */
.not-logged-in,
.not-patient {
  text-align: center;
  padding: 40px;
  background: #f9f9f9;
  border-radius: 8px;
  margin-top: 40px;
}

.login-link {
  display: inline-block;
  margin-top: 20px;
  padding: 10px 20px;
  background: #4CAF50;
  color: white;
  text-decoration: none;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.login-link:hover {
  background: #45a049;
}

/* 消息样式 */
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

/* 加载状态样式 */
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
