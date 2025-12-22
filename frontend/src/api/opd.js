import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const opdApi = {
  // 获取所有OPD记录
  getAllOPDs() {
    return apiClient.get('/opds')
  },
  
  // 根据ID获取OPD记录
  getOPDById(id) {
    return apiClient.get(`/opds/${id}`)
  },
  
  // 创建OPD记录（挂号）
  createOPD(opd) {
    return apiClient.post('/opds', opd)
  },
  
  // 获取待就诊患者列表
  getWaitingPatients() {
    return apiClient.get('/opds/waiting')
  },
  
  // 根据科室获取待就诊患者列表
  getWaitingPatientsByDept(dept) {
    return apiClient.get(`/opds/waiting/${dept}`)
  },
  
  // 叫号
  callPatient(id) {
    return apiClient.put(`/opds/${id}/call`)
  },
  
  // 过号
  skipPatient(id) {
    return apiClient.put(`/opds/${id}/skip`)
  }
}
