<template>
  <div class="drug-management">
    <div class="page-header">
      <h1>药品库存管理</h1>
      <button class="primary-btn" @click="openAddModal">新增药品</button>
    </div>

    <!-- 错误/成功提示 -->
    <div v-if="errorMessage" class="message error">{{ errorMessage }}</div>
    <div v-if="successMessage" class="message success">{{ successMessage }}</div>

    <!-- 药品列表 -->
    <div class="drug-list">
      <div v-if="isLoading" class="loading">加载中...</div>
      <table v-else>
        <thead>
          <tr>
            <th>药品编码</th>
            <th>药品名称</th>
            <th>规格</th>
            <th>单位</th>
            <th>单价</th>
            <th>库存</th>
            <th>操作</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="drug in drugs" :key="drug.drugId">
            <td>{{ drug.drugCode }}</td>
            <td>{{ drug.drugName }}</td>
            <td>{{ drug.drugSpec }}</td>
            <td>{{ drug.drugUnit }}</td>
            <td>￥{{ drug.drugPrice }}</td>
            <td :class="{ 'low-stock': drug.drugStock < 10 }">
              {{ drug.drugStock }}
              <span v-if="drug.drugStock < 10" class="stock-warning">(库存紧张)</span>
            </td>
            <td>
              <button class="edit-btn" @click="openEditModal(drug)">编辑</button>
              <button class="delete-btn" @click="confirmDelete(drug)">删除</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- 新增/编辑模态框 -->
    <div v-if="showModal" class="modal-overlay">
      <div class="modal-content">
        <h2>{{ isEdit ? '编辑药品' : '新增药品' }}</h2>
        <form @submit.prevent="handleSubmit">
          <div class="form-group">
            <label>药品名称</label>
            <input v-model="form.drugName" required placeholder="如：阿莫西林胶囊">
          </div>
          <div class="form-group">
            <label>药品编码</label>
            <input v-model="form.drugCode" required placeholder="如：AMXL001">
          </div>
          <div class="form-group row">
            <div class="col">
              <label>单价 (元)</label>
              <input type="number" v-model.number="form.drugPrice" step="0.01" min="0" required>
            </div>
            <div class="col">
              <label>库存数量</label>
              <input type="number" v-model.number="form.drugStock" min="0" required>
            </div>
          </div>
          <div class="form-group row">
            <div class="col">
              <label>单位</label>
              <input v-model="form.drugUnit" required placeholder="如：盒">
            </div>
            <div class="col">
              <label>规格</label>
              <input v-model="form.drugSpec" placeholder="如：0.25g*24粒">
            </div>
          </div>
          
          <div class="modal-actions">
            <button type="button" class="cancel-btn" @click="closeModal">取消</button>
            <button type="submit" class="save-btn">保存</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { drugApi } from '../api/drug'

export default {
  name: 'DrugManagement',
  setup() {
    const drugs = ref([])
    const isLoading = ref(false)
    const showModal = ref(false)
    const isEdit = ref(false)
    const errorMessage = ref('')
    const successMessage = ref('')
    
    const form = ref({
      drugId: null,
      drugName: '',
      drugCode: '',
      drugPrice: 0,
      drugStock: 0,
      drugUnit: '',
      drugSpec: ''
    })

    const fetchDrugs = async () => {
      isLoading.value = true
      try {
        const res = await drugApi.getAllDrugs()
        drugs.value = res.data
      } catch (e) {
        console.error(e)
        errorMessage.value = '获取药品列表失败'
      } finally {
        isLoading.value = false
      }
    }

    const openAddModal = () => {
      isEdit.value = false
      resetForm()
      showModal.value = true
    }

    const openEditModal = (drug) => {
      isEdit.value = true
      form.value = { ...drug }
      showModal.value = true
    }

    const closeModal = () => {
      showModal.value = false
      resetForm()
    }

    const resetForm = () => {
      form.value = {
        drugId: null,
        drugName: '',
        drugCode: '',
        drugPrice: 0,
        drugStock: 0,
        drugUnit: '',
        drugSpec: ''
      }
      errorMessage.value = ''
      successMessage.value = ''
    }

    const handleSubmit = async () => {
      try {
        if (isEdit.value) {
          await drugApi.updateDrug(form.value.drugId, form.value)
          successMessage.value = '药品更新成功'
        } else {
          await drugApi.createDrug(form.value)
          successMessage.value = '药品添加成功'
        }
        closeModal()
        fetchDrugs()
        setTimeout(() => successMessage.value = '', 3000)
      } catch (e) {
        console.error(e)
        errorMessage.value = '操作失败: ' + (e.response?.data?.message || e.message)
      }
    }

    const confirmDelete = async (drug) => {
      if (!confirm(`确定要删除药品 "${drug.drugName}" 吗？`)) return
      
      try {
        await drugApi.deleteDrug(drug.drugId)
        successMessage.value = '药品已删除'
        fetchDrugs()
        setTimeout(() => successMessage.value = '', 3000)
      } catch (e) {
        console.error(e)
        errorMessage.value = '删除失败'
      }
    }

    onMounted(() => {
      fetchDrugs()
    })

    return {
      drugs,
      isLoading,
      showModal,
      isEdit,
      form,
      errorMessage,
      successMessage,
      fetchDrugs,
      openAddModal,
      openEditModal,
      closeModal,
      handleSubmit,
      confirmDelete
    }
  }
}
</script>

<style scoped>
.drug-management { max-width: 1200px; margin: 0 auto; padding: 20px; }
.page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
.primary-btn { background: #4CAF50; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; }
.primary-btn:hover { background: #45a049; }

table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
th, td { padding: 12px; text-align: left; border-bottom: 1px solid #eee; }
th { background: #f5f5f5; font-weight: bold; }
tr:hover { background: #fafafa; }

.low-stock { color: #f44336; font-weight: bold; }
.stock-warning { font-size: 12px; margin-left: 5px; }

.edit-btn, .delete-btn { padding: 5px 10px; border: none; border-radius: 3px; cursor: pointer; margin-right: 5px; }
.edit-btn { background: #2196F3; color: white; }
.delete-btn { background: #f44336; color: white; }

.modal-overlay { position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); display: flex; justify-content: center; align-items: center; z-index: 1000; }
.modal-content { background: white; padding: 30px; border-radius: 8px; width: 500px; max-width: 90%; }
.form-group { margin-bottom: 15px; }
.form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
.form-group input { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; } /* Ensure padding doesn't affect width */
.row { display: flex; gap: 15px; }
.col { flex: 1; }

.modal-actions { display: flex; justify-content: flex-end; gap: 10px; margin-top: 20px; }
.save-btn { background: #4CAF50; color: white; border: none; padding: 8px 20px; border-radius: 4px; cursor: pointer; }
.cancel-btn { background: #999; color: white; border: none; padding: 8px 20px; border-radius: 4px; cursor: pointer; }

.message { padding: 10px; margin-bottom: 15px; border-radius: 4px; }
.message.error { background: #f8d7da; color: #721c24; }
.message.success { background: #d4edda; color: #155724; }
</style>
