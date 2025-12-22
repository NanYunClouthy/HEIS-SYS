<template>
  <div class="doctors">
    <h1>医生信息管理</h1>
    
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
    
    <div class="toolbar">
      <button class="primary" @click="openAdd" :disabled="isLoading">新增医生</button>
    </div>
    <table>
      <thead>
        <tr>
          <th>ID</th><th>姓名</th><th>科室</th><th>职称</th><th>专长</th><th>操作</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="d in doctors" :key="d.docId">
          <td>{{ d.docId }}</td>
          <td>{{ d.docName }}</td>
          <td>{{ d.docDept }}</td>
          <td>{{ d.docTitle || '-' }}</td>
          <td>{{ d.docSpecialty || '-' }}</td>
          <td>
            <button class="warning" @click="openEdit(d)" :disabled="isLoading">编辑</button>
            <button class="danger" @click="remove(d.docId)" :disabled="isLoading">删除</button>
          </td>
        </tr>
      </tbody>
    </table>
    <div v-if="showModal" class="modal">
      <div class="modal-content">
        <h2>{{ isEdit ? '编辑医生' : '新增医生' }}</h2>
        <form @submit.prevent="save">
          <div>
            <label>姓名</label>
            <input v-model="form.docName" required>
          </div>
          <div>
            <label>科室</label>
            <input v-model="form.docDept" required>
          </div>
          <div>
            <label>职称</label>
            <input v-model="form.docTitle">
          </div>
          <div>
            <label>专长</label>
            <input v-model="form.docSpecialty">
          </div>
          <div class="actions">
            <button class="primary" type="submit" :disabled="isLoading">{{ isEdit ? '保存' : '创建' }}</button>
            <button type="button" @click="close" :disabled="isLoading">取消</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import axios from 'axios'

export default {
  name: 'Doctors',
  setup() {
    const api = axios.create({ 
      baseURL: 'http://localhost:8080/api', 
      withCredentials: true 
    })
    
    const doctors = ref([])
    const showModal = ref(false)
    const isEdit = ref(false)
    const form = ref({ docId: null, docName: '', docDept: '', docTitle: '', docSpecialty: '' })
    const errorMessage = ref('')
    const successMessage = ref('')
    const isLoading = ref(false)
    
    const fetch = async () => {
      isLoading.value = true
      errorMessage.value = ''
      
      try {
        const res = await api.get('/doctors')
        doctors.value = res.data
      } catch (error) {
        console.error('获取医生列表失败:', error)
        errorMessage.value = error.response?.data?.message || '获取医生列表失败，请稍后重试'
      } finally {
        isLoading.value = false
      }
    }
    
    const openAdd = () => {
      isEdit.value = false
      form.value = { docId: null, docName: '', docDept: '', docTitle: '', docSpecialty: '' }
      showModal.value = true
    }
    
    const openEdit = (d) => {
      isEdit.value = true
      form.value = { ...d }
      showModal.value = true
    }
    
    const save = async () => {
      isLoading.value = true
      errorMessage.value = ''
      successMessage.value = ''
      
      try {
        if (isEdit.value) {
          await api.put(`/doctors/${form.value.docId}`, form.value)
          successMessage.value = '医生信息更新成功'
        } else {
          await api.post('/doctors', form.value)
          successMessage.value = '医生信息新增成功'
        }
        showModal.value = false
        await fetch()
      } catch (error) {
        console.error('保存医生信息失败:', error)
        errorMessage.value = error.response?.data?.message || '保存医生信息失败，请稍后重试'
      } finally {
        isLoading.value = false
      }
    }
    
    const remove = async (id) => {
      if (!confirm('确认删除该医生？')) {
        return
      }
      
      isLoading.value = true
      errorMessage.value = ''
      successMessage.value = ''
      
      try {
        await api.delete(`/doctors/${id}`)
        successMessage.value = '医生信息删除成功'
        await fetch()
      } catch (error) {
        console.error('删除医生信息失败:', error)
        errorMessage.value = error.response?.data?.message || '删除医生信息失败，请稍后重试'
      } finally {
        isLoading.value = false
      }
    }
    
    const close = () => {
      showModal.value = false
    }
    
    onMounted(fetch)
    
    return { 
      doctors, 
      showModal, 
      isEdit, 
      form, 
      openAdd, 
      openEdit, 
      save, 
      remove, 
      close,
      errorMessage,
      successMessage,
      isLoading
    }
  }
}
</script>

<style scoped>
.doctors { max-width: 1000px; margin: 0 auto; padding: 20px; position: relative; }
table { width: 100%; border-collapse: collapse; background: white; border-radius: 6px; }
th, td { padding: 10px; border-bottom: 1px solid #eee; text-align: left; }
.toolbar { margin-bottom: 10px; }
.modal { position: fixed; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; }
.modal-content { background: #fff; padding: 20px; border-radius: 8px; width: 500px; }
.actions { display: flex; gap: 10px; margin-top: 10px; }

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
  margin-right: 5px;
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

button.warning {
  background: #ff9800;
  color: white;
}

button.warning:hover:not(:disabled) {
  background: #f57c00;
}

button.danger {
  background: #f44336;
  color: white;
}

button.danger:hover:not(:disabled) {
  background: #da190b;
}
</style>
