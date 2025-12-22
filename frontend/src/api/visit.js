import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const visitApi = {
  create(history) {
    return apiClient.post('/opd-visit-histories', history)
  },
  getAll() {
    return apiClient.get('/opd-visit-histories')
  },
  byPatient(patId) {
    return apiClient.get(`/opd-visit-histories/patient/${patId}`)
  },
  byDoctor(docId) {
    return apiClient.get(`/opd-visit-histories/doctor/${docId}`)
  }
}
