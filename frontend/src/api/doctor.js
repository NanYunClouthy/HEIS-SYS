import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const doctorApi = {
  me() {
    return apiClient.get('/doctors/me')
  },
  getDoctorsByDept(dept) {
    return apiClient.get(`/doctors/dept/${dept}`)
  }
}
