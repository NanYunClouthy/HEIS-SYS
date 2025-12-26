import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const prescriptionApi = {
  // 创建处方
  createPrescription(prescription) {
    return apiClient.post('/prescriptions', prescription)
  },
  
  // 根据就诊ID获取处方
  getPrescriptionsByVisitId(visId) {
    return apiClient.get(`/prescriptions/visit/${visId}`)
  },
  
  // 根据ID获取处方
  getPrescriptionById(id) {
    return apiClient.get(`/prescriptions/${id}`)
  }
}
