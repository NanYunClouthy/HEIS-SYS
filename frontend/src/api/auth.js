import axios from 'axios'

const apiClient = axios.create({
  baseURL: 'http://localhost:8080/api',
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

export const authApi = {
  // 登录
  login(username, password) {
    return apiClient.post('/auth/login', { username, password })
  },
  
  // 注销
  logout() {
    return apiClient.post('/auth/logout')
  },
  
  // 获取当前用户信息
  getCurrentUser() {
    return apiClient.get('/auth/me')
  }
}
