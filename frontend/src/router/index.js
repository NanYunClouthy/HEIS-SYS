import { createRouter, createWebHistory } from 'vue-router'
import PatientList from '../views/PatientList.vue'
import Register from '../views/Register.vue'
import WaitingList from '../views/WaitingList.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'patientList',
      component: PatientList
    },
    {
      path: '/register',
      name: 'register',
      component: Register
    },
    {
      path: '/waiting-list',
      name: 'waitingList',
      component: WaitingList
    }
  ]
})

export default router