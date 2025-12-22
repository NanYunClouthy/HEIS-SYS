import { createRouter, createWebHistory } from 'vue-router'
import PatientList from '../views/PatientList.vue'
import RegisterUser from '../views/RegisterUser.vue'
import Register from '../views/Register.vue'
import WaitingList from '../views/WaitingList.vue'
import Login from '../views/Login.vue'
import VisitHistory from '../views/VisitHistory.vue'
import MyCenter from '../views/MyCenter.vue'
import Pay from '../views/Pay.vue'
import AdminDashboard from '../views/AdminDashboard.vue'
import Doctors from '../views/Doctors.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'patientList',
      component: PatientList,
      meta: { requiresAuth: true }
    },
    {
      path: '/register',
      name: 'register',
      component: Register,
      meta: { requiresAuth: true }
    },
    {
      path: '/signup',
      name: 'signup',
      component: RegisterUser,
      meta: { requiresAuth: false }
    },
    {
      path: '/waiting-list',
      name: 'waitingList',
      component: WaitingList,
      meta: { requiresAuth: true }
    },
    {
      path: '/login',
      name: 'login',
      component: Login,
      meta: { requiresAuth: false }
    },
    {
      path: '/visit-history',
      name: 'visitHistory',
      component: VisitHistory,
      meta: { requiresAuth: true }
    },
    {
      path: '/my-center',
      name: 'myCenter',
      component: MyCenter,
      meta: { requiresAuth: true }
    },
    {
      path: '/pay',
      name: 'pay',
      component: Pay,
      meta: { requiresAuth: true }
    },
    {
      path: '/admin',
      name: 'admin',
      component: AdminDashboard,
      meta: { requiresAuth: true }
    },
    {
      path: '/doctors',
      name: 'doctors',
      component: Doctors,
      meta: { requiresAuth: true }
    }
  ]
})

// 添加导航守卫
router.beforeEach((to, from, next) => {
  // 检查路由是否需要认证
  if (to.meta.requiresAuth) {
    // 检查用户是否已登录
    const user = localStorage.getItem('user')
    if (user) {
      // 用户已登录，继续访问
      next()
    } else {
      // 用户未登录，重定向到登录页面
      next({ name: 'login' })
    }
  } else {
    // 路由不需要认证，直接访问
    next()
  }
})

export default router
