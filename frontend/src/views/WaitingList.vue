<template>
  <div class="waiting-list-container">
    <h1>医生候诊列表</h1>
    
    <!-- 科室选择 -->
    <div class="department-selector">
      <label for="dept">选择科室：</label>
      <select id="dept" v-model="selectedDept">
        <option value="">所有科室</option>
        <option value="内科">内科</option>
        <option value="外科">外科</option>
        <option value="儿科">儿科</option>
        <option value="妇产科">妇产科</option>
        <option value="眼科">眼科</option>
        <option value="耳鼻喉科">耳鼻喉科</option>
        <option value="口腔科">口腔科</option>
        <option value="皮肤科">皮肤科</option>
      </select>
      <button @click="fetchWaitingPatients">刷新列表</button>
    </div>
    
    <!-- 候诊列表 -->
    <div class="waiting-patients">
      <h2>待就诊患者</h2>
      <div v-if="waitingPatients.length === 0" class="no-patients">
        暂无待就诊患者
      </div>
      <table v-else>
        <thead>
          <tr>
            <th>挂号ID</th>
            <th>病历号</th>
            <th>姓名</th>
            <th>年龄</th>
            <th>性别</th>
            <th>科室</th>
            <th>挂号时间</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="patient in waitingPatients" :key="patient.opdId">
            <td>{{ patient.opdId }}</td>
            <td>{{ patient.patient.patId }}</td>
            <td>{{ patient.patient.patName }}</td>
            <td>{{ patient.patient.patAge }}</td>
            <td>{{ patient.patient.patSex }}</td>
            <td>{{ patient.opdDept }}</td>
            <td>{{ formatDateTime(patient.opdTime) }}</td>
            <td class="actions">
              <button class="call-btn" @click="callPatient(patient)">叫号</button>
              <button class="skip-btn" @click="skipPatient(patient)">过号</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    
    <!-- 就诊中患者 -->
    <div class="current-patient" v-if="currentPatient">
      <h2>当前就诊患者</h2>
      <div class="patient-info">
        <p><strong>姓名：</strong>{{ currentPatient.patient.patName }}</p>
        <p><strong>病历号：</strong>{{ currentPatient.patient.patId }}</p>
        <p><strong>年龄：</strong>{{ currentPatient.patient.patAge }}岁</p>
        <p><strong>性别：</strong>{{ currentPatient.patient.patSex }}</p>
        <p><strong>科室：</strong>{{ currentPatient.opdDept }}</p>
        <p><strong>联系电话：</strong>{{ currentPatient.patient.patTel }}</p>
      </div>
      <div class="consultation-form">
        <h3>就诊记录</h3>
        <div class="form-group">
          <label>病例描述</label>
          <textarea v-model="consultationForm.visCaseDesc" rows="4" placeholder="请输入病例描述"></textarea>
        </div>
        <div class="form-group">
          <label>诊断结果</label>
          <input v-model="consultationForm.visDiagnosis" placeholder="请输入诊断结果">
        </div>
        <div class="form-group">
          <label>备注</label>
          <textarea v-model="consultationForm.visNote" rows="3" placeholder="备注（可选）"></textarea>
        </div>
        <div class="actions">
          <button class="primary" @click="submitConsultation">保存并过号</button>
          <button class="warning" @click="skipPatient(currentPatient)">直接过号</button>
        </div>
      </div>
    </div>
    
    <!-- 成功提示 -->
    <div class="success-message" v-if="successMessage">
      {{ successMessage }}
      <button @click="successMessage = ''">关闭</button>
    </div>
  </div>
</template>

<script>
import { opdApi } from '../api/opd'
import { doctorApi } from '../api/doctor'
import { visitApi } from '../api/visit'

export default {
  name: 'WaitingList',
  data() {
    return {
      selectedDept: '',
      waitingPatients: [],
      currentPatient: null,
      successMessage: '',
      errorMessage: '',
      isLoading: false,
      refreshInterval: null,
      doctorInfo: null,
      consultationForm: {
        visCaseDesc: '',
        visDiagnosis: '',
        visNote: ''
      }
    }
  },
  mounted() {
    this.initDoctorDept()
    // 设置自动刷新，每5秒刷新一次
    this.refreshInterval = setInterval(() => {
      this.fetchWaitingPatients()
    }, 5000)
  },
  beforeUnmount() {
    // 清除自动刷新
    if (this.refreshInterval) {
      clearInterval(this.refreshInterval)
    }
  },
  methods: {
    async initDoctorDept() {
      this.isLoading = true
      this.errorMessage = ''
      try {
        const res = await doctorApi.me()
        this.doctorInfo = res.data
        if (this.doctorInfo?.docDept) {
          this.selectedDept = this.doctorInfo.docDept
        }
        await this.fetchWaitingPatients()
      } catch (e) {
        console.error('获取医生信息失败:', e)
        await this.fetchWaitingPatients()
      } finally {
        this.isLoading = false
      }
    },
    // 格式化日期时间
    formatDateTime(dateTime) {
      const date = new Date(dateTime)
      return date.toLocaleString('zh-CN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'
      })
    },
    
    // 获取待就诊患者列表
    async fetchWaitingPatients() {
      this.isLoading = true
      this.errorMessage = ''
      try {
        let response
        if (this.selectedDept) {
          response = await opdApi.getWaitingPatientsByDept(this.selectedDept)
        } else {
          response = await opdApi.getWaitingPatients()
        }
        this.waitingPatients = response.data
      } catch (error) {
        console.error('获取候诊列表失败:', error)
        this.errorMessage = '获取候诊列表失败: ' + (error.response?.data?.message || error.message)
      } finally {
        this.isLoading = false
      }
    },
    
    // 叫号
    async callPatient(patient) {
      this.errorMessage = ''
      try {
        await opdApi.callPatient(patient.opdId)
        this.currentPatient = patient
        this.successMessage = `已叫号：${patient.patient.patName}，请编写就诊记录`
        this.consultationForm = { visCaseDesc: '', visDiagnosis: '', visNote: '' }
      } catch (error) {
        console.error('叫号失败:', error)
        this.errorMessage = '叫号失败: ' + (error.response?.data?.message || error.message)
      }
    },
    
    // 过号
    async skipPatient(patient) {
      this.errorMessage = ''
      try {
        await opdApi.skipPatient(patient.opdId)
        this.successMessage = `已过号：${patient.patient.patName}`
        this.currentPatient = null
        // 刷新候诊列表
        this.fetchWaitingPatients()
      } catch (error) {
        console.error('过号失败:', error)
        this.errorMessage = '过号失败: ' + (error.response?.data?.message || error.message)
      }
    },
    async submitConsultation() {
      if (!this.currentPatient || !this.doctorInfo) {
        this.errorMessage = '缺少当前患者或医生信息'
        return
      }
      this.errorMessage = ''
      try {
        const now = new Date()
        const body = {
          patient: { patId: this.currentPatient.patient.patId },
          visDocId: this.doctorInfo.docId,
          visCaseDesc: this.consultationForm.visCaseDesc,
          visDiagnosis: this.consultationForm.visDiagnosis,
          visCreatedBy: this.doctorInfo.docName || 'doctor',
          visCreatedDate: now,
          visLastModifiedBy: this.doctorInfo.docName || 'doctor',
          visLastModifiedDate: now,
          visNote: this.consultationForm.visNote || null
        }
        await visitApi.create(body)
        await this.skipPatient(this.currentPatient)
        this.successMessage = '就诊记录已保存并过号'
        this.consultationForm = { visCaseDesc: '', visDiagnosis: '', visNote: '' }
      } catch (error) {
        console.error('保存就诊记录失败:', error)
        this.errorMessage = '保存就诊记录失败: ' + (error.response?.data?.message || error.message)
      }
    }
  }
}
</script>

<style scoped>
.waiting-list-container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
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

.department-selector {
  display: flex;
  align-items: center;
  margin-bottom: 20px;
  padding: 15px;
  background: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.department-selector label {
  margin-right: 10px;
  font-weight: bold;
  color: #666;
}

.department-selector select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  margin-right: 15px;
  font-size: 14px;
}

.department-selector button {
  padding: 8px 16px;
  background: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  transition: background-color 0.3s;
}

.department-selector button:hover {
  background: #45a049;
}

.waiting-patients, .current-patient {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.no-patients {
  text-align: center;
  padding: 30px;
  color: #999;
  font-style: italic;
}

table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

th, td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

th {
  background: #f5f5f5;
  font-weight: bold;
  color: #333;
}

tr:hover {
  background: #f9f9f9;
}

.actions {
  display: flex;
  gap: 10px;
}

.call-btn, .skip-btn {
  padding: 6px 12px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 13px;
  transition: background-color 0.3s;
}

.call-btn {
  background: #4CAF50;
  color: white;
}

.call-btn:hover {
  background: #45a049;
}

.skip-btn {
  background: #f44336;
  color: white;
}

.skip-btn:hover {
  background: #da190b;
}

.current-patient .patient-info {
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.current-patient p {
  margin: 10px 0;
  font-size: 16px;
}

.current-patient strong {
  color: #333;
  margin-right: 10px;
}

.success-message {
  background: #d4edda;
  color: #155724;
  padding: 15px;
  border-radius: 4px;
  margin-top: 20px;
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

/* 错误信息样式 */
.error-message {
  background: #f8d7da;
  color: #721c24;
  padding: 15px;
  border-radius: 4px;
  margin-top: 20px;
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
.loading {
  text-align: center;
  padding: 30px;
  color: #666;
  font-style: italic;
  font-size: 18px;
}
</style>
