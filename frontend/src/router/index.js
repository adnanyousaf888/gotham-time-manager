import { createRouter, createWebHistory } from 'vue-router'

// Import your components exactly as they are named in your sidebar
import User from '../components/User.vue'
import ClockManager from '../components/ClockManager.vue'
import WorkingTimes from '../components/WorkingTimes.vue'
import ChartManager from '../components/ChartManager.vue'
import FeedbackForm from '../components/FeedbackForm.vue'
import ManagerFeedbackDashboard from '../components/ManagerFeedbackDashboard.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/user',
      name: 'user',
      component: User
    },
    {
      path: '/clock',
      name: 'clock',
      component: ClockManager
    },
    {
      path: '/working-times',
      name: 'working-times',
      component: WorkingTimes
    },
    {
      path: '/dashboard',
      name: 'dashboard',
      component: ChartManager
    },
    {
      path: '/feedback',
      name: 'feedback',
      component: FeedbackForm
    },
    {
      path: '/admin/inbox',
      name: 'manager-dashboard',
      component: ManagerFeedbackDashboard
    },
    {
      // Fallback: automatically takes you to the User page when you load the app
      path: '/',
      redirect: '/user'
    }
  ]
})

export default router
