<template>
  <div class="patient-list">
    <div class="page-header">
      <h2>患者管理</h2>
      <button class="primary" @click="openAddModal">添加患者</button>
    </div>

    <!-- 错误信息 -->
    <div v-if="errorMessage" class="error-message">
      {{ errorMessage }}
    </div>

    <!-- 加载状态 -->
    <div v-if="isLoading" class="loading">
      加载中...
    </div>

    <!-- 患者表单 -->
    <div v-if="showModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h2>{{ isEdit ? '编辑患者' : '添加患者' }}</h2>
          <button class="close" @click="closeModal">&times;</button>
        </div>
        <form @submit.prevent="savePatient">
          <div>
            <label for="patName">患者姓名</label>
            <input type="text" id="patName" v-model="formData.patName" required>
          </div>
          <div>
            <label for="patSurname">姓氏</label>
            <input type="text" id="patSurname" v-model="formData.patSurname" required>
          </div>
          <div>
            <label for="patFirstname">名字</label>
            <input type="text" id="patFirstname" v-model="formData.patFirstname" required>
          </div>
          <div>
            <label for="patAge">年龄</label>
            <input type="number" id="patAge" v-model.number="formData.patAge" required>
          </div>
          <div>
            <label for="patSex">性别</label>
            <select id="patSex" v-model="formData.patSex" required>
              <option value="男">男</option>
              <option value="女">女</option>
            </select>
          </div>
          <div>
            <label for="patActor">角色</label>
            <input type="text" id="patActor" v-model="formData.patActor" required>
          </div>
          <div>
            <label for="patContactPerson">联系人员</label>
            <input type="text" id="patContactPerson" v-model="formData.patContactPerson" required>
          </div>
          <div>
            <label for="patTel">联系电话</label>
            <input type="tel" id="patTel" v-model="formData.patTel" required>
          </div>
          <div>
            <label for="patStatus">状态</label>
            <select id="patStatus" v-model="formData.patStatus" required>
              <option value="A">活跃</option>
              <option value="I">非活跃</option>
            </select>
          </div>
          <div class="form-actions">
            <button type="submit" class="primary">{{ isEdit ? '更新' : '添加' }}</button>
            <button type="button" @click="closeModal">取消</button>
          </div>
        </form>
      </div>
    </div>

    <!-- 患者列表 -->
    <table v-if="!isLoading && patients.length > 0">
      <thead>
        <tr>
          <th>ID</th>
          <th>姓名</th>
          <th>年龄</th>
          <th>性别</th>
          <th>联系电话</th>
          <th>状态</th>
          <th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="patient in patients" :key="patient.patId">
          <td>{{ patient.patId }}</td>
          <td>{{ patient.patName }}</td>
          <td>{{ patient.patAge }}</td>
          <td>{{ patient.patSex }}</td>
          <td>{{ patient.patTel }}</td>
          <td>{{ patient.patStatus === 'A' ? '活跃' : '非活跃' }}</td>
          <td>
            <button class="warning" @click="openEditModal(patient)">编辑</button>
            <button class="danger" @click="deletePatient(patient.patId)">删除</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- 空状态 -->
    <div v-if="!isLoading && patients.length === 0" class="empty-state">
      暂无患者数据
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { patientApi } from '../api/patient'

const patients = ref([])
const showModal = ref(false)
const isEdit = ref(false)
const isLoading = ref(false)
const errorMessage = ref('')
const formData = ref({
  patName: '',
  patSurname: '',
  patFirstname: '',
  patAge: 0,
  patSex: '男',
  patActor: '患者',
  patContactPerson: '',
  patTel: '',
  patStatus: 'A'
})

// 获取所有患者
const fetchPatients = async () => {
  isLoading.value = true
  errorMessage.value = ''
  
  try {
    const response = await patientApi.getAllPatients()
    patients.value = response.data
    console.log('患者列表:', response.data)
  } catch (error) {
    console.error('获取患者列表失败:', error)
    errorMessage.value = '获取患者列表失败: ' + (error.response?.data?.message || error.message)
  } finally {
    isLoading.value = false
  }
}

// 打开添加模态框
const openAddModal = () => {
  isEdit.value = false
  resetForm()
  showModal.value = true
}

// 打开编辑模态框
const openEditModal = (patient) => {
  isEdit.value = true
  formData.value = { ...patient }
  showModal.value = true
}

// 关闭模态框
const closeModal = () => {
  showModal.value = false
  resetForm()
}

// 重置表单
const resetForm = () => {
  formData.value = {
    patName: '',
    patSurname: '',
    patFirstname: '',
    patAge: 0,
    patSex: '男',
    patActor: '患者',
    patContactPerson: '',
    patTel: '',
    patStatus: 'A'
  }
}

// 保存患者
const savePatient = async () => {
  try {
    if (isEdit.value) {
      await patientApi.updatePatient(formData.value.patId, formData.value)
      alert('患者更新成功')
    } else {
      await patientApi.createPatient(formData.value)
      alert('患者添加成功')
    }
    closeModal()
    fetchPatients()
  } catch (error) {
    console.error('保存患者失败:', error)
    alert('保存患者失败')
  }
}

// 删除患者
const deletePatient = async (id) => {
  if (confirm('确定要删除这个患者吗？')) {
    try {
      await patientApi.deletePatient(id)
      alert('患者删除成功')
      fetchPatients()
    } catch (error) {
      console.error('删除患者失败:', error)
      alert('删除患者失败')
    }
  }
}

// 初始加载
onMounted(() => {
  fetchPatients()
})
</script>

<style scoped>
.patient-list {
  background-color: white;
  padding: 20px;
  border-radius: 5px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.page-header h2 {
  margin: 0;
  color: #333;
}

.form-actions {
  display: flex;
  justify-content: flex-end;
  gap: 10px;
  margin-top: 20px;
}
</style>