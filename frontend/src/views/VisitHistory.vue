<template>
  <div class="visit-history-container">
    <h1>{{ role === 'PATIENT' ? '我的就诊记录' : '就诊记录管理' }}</h1>
    
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
    
    <!-- 就诊记录列表 -->
    <div class="visit-list-section" v-if="visitHistories.length > 0">
      <h2>{{ role === 'PATIENT' ? '我的就诊记录列表' : '就诊记录列表' }}</h2>
      <div class="visit-list">
        <table>
          <thead>
            <tr>
              <th>记录ID</th>
              <th>患者姓名</th>
              <th>科室</th>
              <th>诊断结果</th>
              <th>就诊日期</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="visit in visitHistories" 
              :key="visit.visId"
              @click="viewVisitDetail(visit)"
              class="visit-row"
            >
              <td>{{ visit.visId }}</td>
              <td>{{ visit.patient?.patName || '未知' }}</td>
              <td>{{ visit.doctor?.docDept || '未知' }}</td>
              <td>{{ visit.visDiagnosis || '暂无' }}</td>
              <td>{{ formatDate(visit.visCreatedDate) }}</td>
              <td>
                <button class="detail-btn" @click.stop="viewVisitDetail(visit)">查看详情</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
    <!-- 无记录提示 -->
    <div class="no-records" v-else-if="!isLoading">
      <p>{{ role === 'PATIENT' ? '您暂无就诊记录' : '暂无就诊记录' }}</p>
    </div>
    
    <!-- 就诊记录详情 -->
    <div class="visit-detail-section" v-if="selectedVisit">
      <div class="detail-header">
        <h2>就诊记录详情</h2>
        <button class="close-btn" @click="closeDetail">关闭详情</button>
      </div>
      <div class="detail-content">
        <div class="detail-row">
          <div class="detail-item">
            <strong>记录ID：</strong>{{ selectedVisit.visId }}
          </div>
          <div class="detail-item">
            <strong>就诊日期：</strong>{{ formatDate(selectedVisit.visCreatedDate) }}
          </div>
        </div>
        
        <div class="detail-row">
          <div class="detail-item">
            <strong>患者姓名：</strong>{{ selectedVisit.patient?.patName || '未知' }}
          </div>
          <div class="detail-item">
            <strong>病历号：</strong>{{ selectedVisit.patient?.patId || '未知' }}
          </div>
        </div>
        
        <div class="detail-row">
          <div class="detail-item">
            <strong>性别：</strong>{{ selectedVisit.patient?.patSex || '未知' }}
          </div>
          <div class="detail-item">
            <strong>年龄：</strong>{{ selectedVisit.patient?.patAge || '未知' }}
          </div>
        </div>
        
        <div class="detail-row">
          <div class="detail-item">
            <strong>科室：</strong>{{ selectedVisit.doctor?.docDept || '未知' }}
          </div>
          <div class="detail-item">
            <strong>主治医生：</strong>{{ selectedVisit.doctor?.docName || '未知' }}
          </div>
        </div>
        
        <div class="detail-section">
          <h3>病例描述</h3>
          <div class="detail-text">{{ selectedVisit.visCaseDesc || '暂无描述' }}</div>
        </div>
        
        <div class="detail-section">
          <h3>诊断结果</h3>
          <div class="detail-text">{{ selectedVisit.visDiagnosis || '暂无诊断' }}</div>
        </div>
        
        <div class="detail-section" v-if="selectedPrescriptions && selectedPrescriptions.length > 0">
          <h3>处方信息</h3>
          <div v-for="pres in selectedPrescriptions" :key="pres.presId" class="prescription-item">
             <div class="pres-header">
                <span>处方ID: {{ pres.presId }}</span>
                <span>总金额: ¥{{ pres.presTotalAmount }}</span>
                <span>状态: {{ pres.presStatus === 1 ? '未支付' : (pres.presStatus === 2 ? '已支付' : '其他') }}</span>
             </div>
             <table class="pres-table">
               <thead>
                 <tr>
                   <th>药品名称</th>
                   <th>数量</th>
                   <th>单价</th>
                   <th>小计</th>
                 </tr>
               </thead>
               <tbody>
                 <tr v-for="detail in pres.details" :key="detail.detailId">
                   <td>{{ detail.drug?.drugName || '未知药品' }}</td>
                   <td>{{ detail.detailQuantity }}</td>
                   <td>¥{{ detail.drug?.drugPrice }}</td>
                   <td>¥{{ detail.detailAmount }}</td>
                 </tr>
               </tbody>
             </table>
          </div>
        </div>

        <div class="detail-section" v-if="selectedVisit.visNote">
          <h3>备注</h3>
          <div class="detail-text">{{ selectedVisit.visNote }}</div>
        </div>
      </div>
    </div>
    
    <!-- 非患者角色的记录编写功能 -->
    <div class="write-record-section" v-if="user?.role === 'DOCTOR'">
      <h2>编写就诊记录</h2>
      <form @submit.prevent="saveVisitHistory" class="visit-form">
        <div class="form-row">
          <div class="form-group">
            <label for="visCaseDesc">病例描述</label>
            <textarea 
              id="visCaseDesc" 
              v-model="visitForm.visCaseDesc" 
              placeholder="请输入病例描述"
              rows="5"
              required
              :disabled="isLoading"
            ></textarea>
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label for="visDiagnosis">诊断结果</label>
            <input 
              type="text" 
              id="visDiagnosis" 
              v-model="visitForm.visDiagnosis" 
              placeholder="请输入诊断结果"
              required
              :disabled="isLoading"
            >
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label for="visNote">备注</label>
            <textarea 
              id="visNote" 
              v-model="visitForm.visNote" 
              placeholder="请输入备注"
              rows="3"
              :disabled="isLoading"
            ></textarea>
          </div>
        </div>
        <div class="form-actions">
          <button type="submit" class="save-btn" :disabled="isLoading">保存就诊记录</button>
          <button type="button" class="cancel-btn" @click="resetForm" :disabled="isLoading">取消</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { visitApi } from '../api/visit'
import { patientApi } from '../api/patient'
import { prescriptionApi } from '../api/prescription'
import axios from 'axios'

export default {
  name: 'VisitHistory',
  setup() {
    const user = JSON.parse(localStorage.getItem('user') || '{}')
    const role = (user?.role || '').toUpperCase()
    const visitHistories = ref([])
    const selectedVisit = ref(null)
    const selectedPrescriptions = ref([]) // 存储当前选中的处方
    const visitForm = ref({
      visCaseDesc: '',
      visDiagnosis: '',
      visNote: ''
    })
    const successMessage = ref('')
    const errorMessage = ref('')
    const isLoading = ref(false)
    
    // 格式化日期
    const formatDate = (d) => {
      if (!d) return ''
      const date = new Date(d)
      return date.toLocaleString('zh-CN', { 
        year: 'numeric', 
        month: '2-digit', 
        day: '2-digit', 
        hour: '2-digit', 
        minute: '2-digit' 
      })
    }
    
    // 获取就诊记录
    const fetchVisitHistories = async () => {
      isLoading.value = true
      errorMessage.value = ''
      
      try {
        let response
        if (role === 'PATIENT') {
          const patRes = await patientApi.getMe()
          const patId = patRes.data?.patId
          if (!patId) throw new Error('未找到患者ID')
          response = await visitApi.byPatient(patId)
        } else if (role === 'DOCTOR') {
          const docRes = await axios.get('http://localhost:8080/api/doctors/me', { withCredentials: true })
          const docId = docRes.data?.docId
          if (!docId) throw new Error('未找到医生ID')
          response = await visitApi.byDoctor(docId)
        } else {
          response = await visitApi.getAll()
        }
        
        visitHistories.value = response.data || []
      } catch (e) {
        console.error('获取就诊记录失败:', e)
        errorMessage.value = e.response?.data?.message || '获取就诊记录失败，请稍后重试'
        visitHistories.value = []
      } finally {
        isLoading.value = false
      }
    }
    
    // 查看就诊记录详情
    const viewVisitDetail = async (visit) => {
      selectedVisit.value = visit
      selectedPrescriptions.value = [] // 重置处方列表
      try {
        const res = await prescriptionApi.getPrescriptionsByVisitId(visit.visId)
        if (res.data && res.data.length > 0) {
          selectedPrescriptions.value = res.data
        } else {
          selectedPrescriptions.value = []
        }
      } catch (e) {
        console.error('获取处方详情失败:', e)
        selectedPrescriptions.value = []
      }
    }
    
    // 关闭详情
    const closeDetail = () => {
      selectedVisit.value = null
    }
    
    // 保存就诊记录
    const saveVisitHistory = async () => {
      isLoading.value = true
      errorMessage.value = ''
      successMessage.value = ''
      
      try {
        // 这里需要调用就诊记录API，暂时模拟保存成功
        await new Promise(resolve => setTimeout(resolve, 1000))
        
        // 显示成功提示
        successMessage.value = '就诊记录保存成功'
        
        // 重置表单
        resetForm()
        
        // 重新获取就诊记录
        fetchVisitHistories()
      } catch (error) {
        console.error('保存就诊记录失败:', error)
        errorMessage.value = error.response?.data?.message || '保存就诊记录失败，请稍后重试'
      } finally {
        isLoading.value = false
      }
    }
    
    // 重置表单
    const resetForm = () => {
      visitForm.value = {
        visCaseDesc: '',
        visDiagnosis: '',
        visNote: ''
      }
    }
    
    onMounted(() => {
      fetchVisitHistories()
    })
    
    return {
      user,
      role,
      visitHistories,
      selectedVisit,
      selectedPrescriptions,
      visitForm,
      successMessage,
      errorMessage,
      isLoading,
      formatDate,
      fetchVisitHistories,
      viewVisitDetail,
      closeDetail,
      saveVisitHistory,
      resetForm
    }
  }
}
</script>

<style scoped>
.visit-history-container {
  max-width: 1200px;
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

h3 {
  color: #666;
  margin-bottom: 15px;
}

/* 列表样式 */
.visit-list-section {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.visit-list table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.visit-list th,
.visit-list td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.visit-list th {
  background: #f5f5f5;
  font-weight: bold;
  color: #333;
}

.visit-row {
  cursor: pointer;
  transition: background-color 0.3s;
}

.visit-row:hover {
  background: #f9f9f9;
}

.detail-btn {
  padding: 6px 12px;
  background: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 12px;
  transition: background-color 0.3s;
}

.detail-btn:hover {
  background: #45a049;
}

/* 详情样式 */
.visit-detail-section {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.detail-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.close-btn {
  padding: 8px 16px;
  background: #f0f0f0;
  color: #333;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.close-btn:hover {
  background: #e0e0e0;
}

.detail-content {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.detail-row {
  display: flex;
  gap: 20px;
  flex-wrap: wrap;
}

.detail-item {
  flex: 1;
  min-width: 200px;
  padding: 10px;
  background: white;
  border-radius: 4px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.detail-section {
  background: white;
  padding: 20px;
  border-radius: 4px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.detail-text {
  line-height: 1.6;
  color: #555;
  white-space: pre-wrap;
}

/* 无记录提示 */
.no-records {
  text-align: center;
  padding: 40px;
  background: #f9f9f9;
  border-radius: 8px;
  color: #999;
}

/* 表单样式 */
.write-record-section {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.visit-form {
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

input, textarea {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
  transition: border-color 0.3s;
}

input:focus, textarea:focus {
  outline: none;
  border-color: #4CAF50;
  box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
}

input:disabled, textarea:disabled {
  background-color: #f5f5f5;
  cursor: not-allowed;
}

textarea {
  resize: vertical;
}

.form-actions {
  margin-top: 20px;
  display: flex;
  gap: 10px;
}

.save-btn {
  padding: 10px 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.save-btn:hover:not(:disabled) {
  background: #45a049;
}

.cancel-btn {
  padding: 10px 20px;
  background-color: #f0f0f0;
  color: #333;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

.cancel-btn:hover:not(:disabled) {
  background: #e0e0e0;
}

button:disabled {
  background: #cccccc;
  cursor: not-allowed;
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

.prescription-item {
  margin-top: 15px;
  border: 1px solid #eee;
  padding: 10px;
  border-radius: 4px;
}

.pres-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  font-weight: bold;
  background: #f5f5f5;
  padding: 8px;
  border-radius: 4px;
}

.pres-table {
  width: 100%;
  border-collapse: collapse;
}

.pres-table th, .pres-table td {
  padding: 8px;
  border-bottom: 1px solid #eee;
  text-align: left;
}
</style>
