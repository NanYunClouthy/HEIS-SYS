<template>
  <div class="my-center">
    <h1>个人中心</h1>
    
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
    
    <div class="section">
      <h2>个人信息</h2>
      <div class="info">
        <p><strong>用户名：</strong>{{ user?.username }}</p>
        <p><strong>角色：</strong>{{ roleLabel }}</p>
      </div>
    </div>
    
    <!-- 患者详细信息 -->
    <div class="section" v-if="role === 'PATIENT'">
      <h2>患者信息</h2>
      <div class="patient-info">
        <div class="info-row">
          <div class="info-item">
            <strong>病历号：</strong>{{ patientInfo?.patId || '未获取' }}
          </div>
          <div class="info-item">
            <strong>姓名：</strong>{{ patientInfo?.patName || '未获取' }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>性别：</strong>{{ patientInfo?.patSex || '未获取' }}
          </div>
          <div class="info-item">
            <strong>年龄：</strong>{{ patientInfo?.patAge || '未获取' }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>联系电话：</strong>{{ patientInfo?.patTel || '未获取' }}
          </div>
          <div class="info-item">
            <strong>联系人：</strong>{{ patientInfo?.patContactPerson || '未获取' }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>状态：</strong>{{ patientInfo?.patStatus === 'A' ? '活跃' : '非活跃' }}
          </div>
        </div>
      </div>
    </div>
    
    <!-- 医生详细信息 -->
    <div class="section" v-if="role === 'DOCTOR'">
      <h2>医生信息</h2>
      <div class="doctor-info">
        <div class="info-row">
          <div class="info-item">
            <strong>医生姓名：</strong>{{ doctorInfo?.docName || '未获取' }}
          </div>
          <div class="info-item">
            <strong>科室：</strong>{{ doctorInfo?.docDept || '未获取' }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>职称：</strong>{{ doctorInfo?.docTitle || '未获取' }}
          </div>
          <div class="info-item">
            <strong>专长：</strong>{{ doctorInfo?.docSpecialty || '未获取' }}
          </div>
        </div>
        <div class="info-row">
          <div class="info-item">
            <strong>状态：</strong>{{ doctorInfo?.docStatus === 'A' ? '活跃' : '非活跃' }}
          </div>
        </div>
      </div>
    </div>
    
    <!-- 根据用户是否有患者信息显示提示 -->
    <div class="section" v-if="role === 'PATIENT' && !patientInfo?.patId">
      <h2>患者信息</h2>
      <div class="empty">未绑定病历号，请联系管理员完善信息</div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { visitApi } from '../api/visit'
import { opdApi } from '../api/opd'
import { patientApi } from '../api/patient'
import { useRouter } from 'vue-router'

export default {
  name: 'MyCenter',
  setup() {
    const router = useRouter()
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const role = (user?.role || '').toUpperCase()
    const roleLabel = role ? (role === 'PATIENT' ? '患者' : role === 'DOCTOR' ? '医生' : '管理员') : '未知'
    const histories = ref([])
    const opdDept = ref('内科')
    const errorMessage = ref('')
    const successMessage = ref('')
    const isLoading = ref(false)
    const patientInfo = ref({})
    const doctorInfo = ref({})

    const formatDate = (d) => {
      if (!d) return ''
      const date = new Date(d)
      return date.toLocaleString('zh-CN', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' })
    }

    // 获取患者信息
    const fetchPatientInfo = async () => {
      if (role !== 'PATIENT') return
      try {
        const res = await patientApi.getMe()
        patientInfo.value = res.data || {}
      } catch (e) {
        console.error('获取患者信息失败:', e)
        errorMessage.value = e.response?.data?.message || '获取患者信息失败，请稍后重试'
      }
    }

    // 获取医生信息
    const fetchDoctorInfo = async () => {
      if (role !== 'DOCTOR') return
      
      try {
        // 这里可以根据实际情况获取医生信息
        // 目前假设医生信息已经包含在user对象中
        doctorInfo.value = user.doctorInfo || {}
      } catch (e) {
        console.error('获取医生信息失败:', e)
        errorMessage.value = e.response?.data?.message || '获取医生信息失败，请稍后重试'
      }
    }

    const fetchHistories = async (patId) => {
      if (!patId) return
      
      isLoading.value = true
      errorMessage.value = ''
      
      try {
        const res = await visitApi.byPatient(patId)
        histories.value = res.data || []
      } catch (e) {
        console.error('获取就诊记录失败:', e)
        errorMessage.value = e.response?.data?.message || '获取就诊记录失败，请稍后重试'
        histories.value = []
      } finally {
        isLoading.value = false
      }
    }

    // 个人中心不再提供快速挂号

    onMounted(() => {
      if (user?.role === 'PATIENT') {
        fetchPatientInfo()
      } else if (user?.role === 'DOCTOR') {
        fetchDoctorInfo()
      }
    })

    return {
      user,
      role,
      roleLabel,
      patientInfo,
      doctorInfo,
      histories,
      opdDept,
      formatDate,
      errorMessage,
      successMessage,
      isLoading
    }
  }
}
</script>

<style scoped>
.my-center { max-width: 1000px; margin: 0 auto; padding: 20px; position: relative; }
.section { background: #f9f9f9; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
.info p { margin: 8px 0; }
.bind-form { display: flex; gap: 10px; align-items: center; }
.empty { color: #999; }
table { width: 100%; border-collapse: collapse; background: white; }
th, td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; }

/* 患者和医生信息样式 */
.patient-info, .doctor-info {
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

button {
  padding: 8px 16px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
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
</style>
