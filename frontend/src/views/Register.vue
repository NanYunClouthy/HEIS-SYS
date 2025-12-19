<template>
  <div class="register-container">
    <h1>患者挂号</h1>
    
    <!-- 搜索患者 -->
    <div class="search-section">
      <h2>搜索现有患者</h2>
      <div class="search-form">
        <div class="form-row">
          <div class="form-group">
            <label for="searchId">病历号</label>
            <input 
              type="number" 
              id="searchId" 
              v-model="searchForm.patId" 
              placeholder="输入病历号"
            >
          </div>
          <div class="form-group">
            <label for="searchName">姓名</label>
            <input 
              type="text" 
              id="searchName" 
              v-model="searchForm.patName" 
              placeholder="输入姓名"
            >
          </div>
          <button class="search-btn" @click="searchPatients">搜索</button>
        </div>
      </div>
      
      <!-- 搜索结果 -->
      <div v-if="searchResults.length > 0" class="search-results">
        <h3>搜索结果</h3>
        <table>
          <thead>
            <tr>
              <th>病历号</th>
              <th>姓名</th>
              <th>年龄</th>
              <th>性别</th>
              <th>联系电话</th>
              <th>操作</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="patient in searchResults" :key="patient.patId">
              <td>{{ patient.patId }}</td>
              <td>{{ patient.patName }}</td>
              <td>{{ patient.patAge }}</td>
              <td>{{ patient.patSex }}</td>
              <td>{{ patient.patTel }}</td>
              <td>
                <button @click="selectPatient(patient)">选择此患者</button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    
    <!-- 患者信息 -->
    <div class="patient-section">
      <h2>{{ selectedPatient ? '已选择患者' : '新建患者' }}</h2>
      <form @submit.prevent="savePatient" class="patient-form">
        <div class="form-row">
          <div class="form-group">
            <label for="patName">姓名</label>
            <input 
              type="text" 
              id="patName" 
              v-model="patientForm.patName" 
              required
            >
          </div>
          <div class="form-group">
            <label for="patSurname">姓氏</label>
            <input 
              type="text" 
              id="patSurname" 
              v-model="patientForm.patSurname" 
              required
            >
          </div>
          <div class="form-group">
            <label for="patFirstname">名字</label>
            <input 
              type="text" 
              id="patFirstname" 
              v-model="patientForm.patFirstname" 
              required
            >
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label for="patAge">年龄</label>
            <input 
              type="number" 
              id="patAge" 
              v-model="patientForm.patAge" 
              required
            >
          </div>
          <div class="form-group">
            <label for="patSex">性别</label>
            <select id="patSex" v-model="patientForm.patSex" required>
              <option value="男">男</option>
              <option value="女">女</option>
            </select>
          </div>
          <div class="form-group">
            <label for="patActor">角色</label>
            <input 
              type="text" 
              id="patActor" 
              v-model="patientForm.patActor" 
              required
            >
          </div>
        </div>
        <div class="form-row">
          <div class="form-group">
            <label for="patContactPerson">联系人员</label>
            <input 
              type="text" 
              id="patContactPerson" 
              v-model="patientForm.patContactPerson" 
              required
            >
          </div>
          <div class="form-group">
            <label for="patTel">联系电话</label>
            <input 
              type="tel" 
              id="patTel" 
              v-model="patientForm.patTel" 
              required
            >
          </div>
          <div class="form-group">
            <label for="patStatus">状态</label>
            <select id="patStatus" v-model="patientForm.patStatus" required>
              <option value="A">活跃</option>
              <option value="I">非活跃</option>
            </select>
          </div>
        </div>
        <div class="form-actions">
          <button type="submit" class="primary">保存患者</button>
          <button type="button" @click="resetPatientForm">重置</button>
        </div>
      </form>
    </div>
    
    <!-- 挂号信息 -->
    <div class="opd-section" v-if="selectedPatient">
      <h2>挂号信息</h2>
      <form @submit.prevent="registerPatient" class="opd-form">
        <div class="form-row">
          <div class="form-group">
            <label for="opdDept">科室</label>
            <select id="opdDept" v-model="opdForm.opdDept" required>
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
          <button type="submit" class="primary">确认挂号</button>
        </div>
      </form>
    </div>
    
    <!-- 成功提示 -->
    <div class="success-message" v-if="successMessage">
      {{ successMessage }}
      <button @click="successMessage = ''">关闭</button>
    </div>
  </div>
</template>

<script>
import { patientApi } from '../api/patient'
import { opdApi } from '../api/opd'

export default {
  name: 'Register',
  data() {
    return {
      searchForm: {
        patId: '',
        patName: ''
      },
      searchResults: [],
      selectedPatient: null,
      patientForm: {
        patName: '',
        patSurname: '',
        patFirstname: '',
        patAge: '',
        patSex: '男',
        patActor: '',
        patContactPerson: '',
        patTel: '',
        patStatus: 'A'
      },
      opdForm: {
        opdDept: '内科'
      },
      successMessage: ''
    }
  },
  methods: {
    // 搜索患者
    async searchPatients() {
      try {
        const response = await patientApi.searchPatients(
          this.searchForm.patId || null,
          this.searchForm.patName
        )
        this.searchResults = response.data
      } catch (error) {
        console.error('搜索患者失败:', error)
        alert('搜索患者失败，请稍后重试')
      }
    },
    
    // 选择患者
    selectPatient(patient) {
      this.selectedPatient = patient
      this.patientForm = { ...patient }
      this.searchResults = []
    },
    
    // 保存患者
    async savePatient() {
      try {
        let savedPatient
        if (this.selectedPatient) {
          // 更新现有患者
          savedPatient = await patientApi.updatePatient(
            this.selectedPatient.patId,
            this.patientForm
          )
          savedPatient = savedPatient.data
        } else {
          // 创建新患者
          savedPatient = await patientApi.createPatient(this.patientForm)
          savedPatient = savedPatient.data
        }
        this.selectedPatient = savedPatient
        this.successMessage = '患者信息已保存'
      } catch (error) {
        console.error('保存患者失败:', error)
        alert('保存患者失败，请稍后重试')
      }
    },
    
    // 重置患者表单
    resetPatientForm() {
      this.selectedPatient = null
      this.patientForm = {
        patName: '',
        patSurname: '',
        patFirstname: '',
        patAge: '',
        patSex: '男',
        patActor: '',
        patContactPerson: '',
        patTel: '',
        patStatus: 'A'
      }
    },
    
    // 挂号
    async registerPatient() {
      try {
        const now = new Date()
        const opdData = {
          opdDate: now,
          opdTime: now,
          opdDept: this.opdForm.opdDept,
          patient: {
            patId: this.selectedPatient.patId
          },
          opdStats: 1 // 待就诊
        }
        
        await opdApi.createOPD(opdData)
        this.successMessage = '挂号成功！患者已加入候诊列表'
        
        // 重置表单
        this.resetPatientForm()
        this.opdForm.opdDept = '内科'
      } catch (error) {
        console.error('挂号失败:', error)
        alert('挂号失败，请稍后重试')
      }
    }
  }
}
</script>

<style scoped>
.register-container {
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

h3 {
  color: #666;
  margin-bottom: 15px;
}

.search-section,
.patient-section,
.opd-section {
  background: #f9f9f9;
  padding: 20px;
  border-radius: 8px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.search-form,
.patient-form,
.opd-form {
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

button:hover {
  background: #e0e0e0;
}

button.primary {
  background: #4CAF50;
  color: white;
}

button.primary:hover {
  background: #45a049;
}

.search-btn {
  align-self: flex-end;
  margin-bottom: 15px;
}

.search-results table {
  width: 100%;
  border-collapse: collapse;
  background: white;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.search-results th,
.search-results td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #eee;
}

.search-results th {
  background: #f5f5f5;
  font-weight: bold;
  color: #333;
}

.search-results tr:hover {
  background: #f9f9f9;
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
</style>
