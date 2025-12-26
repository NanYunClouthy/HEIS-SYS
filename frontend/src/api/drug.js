import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const drugApi = {
  // 获取所有药品
  getAllDrugs() {
    return apiClient.get('/drugs')
  },
  
  // 根据ID获取药品
  getDrugById(id) {
    return apiClient.get(`/drugs/${id}`)
  },

  // 创建药品
  createDrug(drug) {
    return apiClient.post('/drugs', drug)
  },

  // 更新药品
  updateDrug(id, drug) {
    return apiClient.put(`/drugs/${id}`, drug)
  },

  // 删除药品
  deleteDrug(id) {
    return apiClient.delete(`/drugs/${id}`)
  }
}
