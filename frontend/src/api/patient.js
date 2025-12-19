import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  headers: {
    'Content-Type': 'application/json'
  }
})

export const patientApi = {
  // 获取所有患者
  getAllPatients() {
    return apiClient.get('/patients')
  },
  
  // 根据ID获取患者
  getPatientById(id) {
    return apiClient.get(`/patients/${id}`)
  },
  
  // 创建患者
  createPatient(patient) {
    return apiClient.post('/patients', patient)
  },
  
  // 更新患者
  updatePatient(id, patient) {
    return apiClient.put(`/patients/${id}`, patient)
  },
  
  // 删除患者
  deletePatient(id) {
    return apiClient.delete(`/patients/${id}`)
  },
  
  // 通过姓名搜索患者
  searchPatientsByName(name) {
    return apiClient.get(`/patients/search/name?name=${encodeURIComponent(name)}`)
  },
  
  // 通过病历号或姓名搜索患者
  searchPatients(id, name) {
    return apiClient.get(`/patients/search?id=${id || ''}&name=${encodeURIComponent(name || '')}`)
  }
}