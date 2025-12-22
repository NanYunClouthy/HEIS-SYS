<template>
  <div class="pay-container">
    <h1>门诊缴费</h1>
    
    <!-- 错误信息 -->
    <div class="error-message" v-if="errorMessage">
      {{ errorMessage }}
      <button @click="errorMessage = ''">关闭</button>
    </div>
    
    <!-- 加载状态 -->
    <div class="loading-overlay" v-if="isLoading">
      <div class="loading-spinner"></div>
      <p>处理中...</p>
    </div>
    
    <div class="card">
      <p><strong>挂号ID：</strong>{{ opdId || '未知' }}</p>
      <p><strong>应缴费用：</strong>¥ 20.00</p>
      <button class="primary" @click="pay" :disabled="isLoading">一键缴费</button>
    </div>
    <div class="success-message" v-if="success">
      缴费成功，祝您早日康复！
      <button @click="success = ''">关闭</button>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue'
import { useRoute } from 'vue-router'

export default {
  name: 'Pay',
  setup() {
    const route = useRoute()
    const opdId = route.query.opdId || ''
    const patId = route.query.patId || ''
    const opdDept = route.query.opdDept || ''
    const success = ref(false)
    const errorMessage = ref('')
    const isLoading = ref(false)
    
    const pay = async () => {
      isLoading.value = true
      errorMessage.value = ''
      
      try {
        await new Promise(resolve => setTimeout(resolve, 800))
        if (!patId || !opdDept) {
          throw new Error('缺少挂号必要信息')
        }
        const now = new Date()
        const opdData = {
          opdDate: now,
          opdTime: now,
          opdDept,
          patient: { patId: Number(patId) },
          opdStats: 1
        }
        const { opdApi } = await import('../api/opd')
        await opdApi.createOPD(opdData)
        success.value = true
      } catch (e) {
        console.error('缴费失败/挂号失败:', e)
        errorMessage.value = e.response?.data?.message || e.message || '缴费或挂号失败，请稍后重试'
      } finally {
        isLoading.value = false
      }
    }
    
    return { opdId, patId, opdDept, success, pay, errorMessage, isLoading }
  }
}
</script>

<style scoped>
.pay-container { max-width: 600px; margin: 0 auto; padding: 20px; position: relative; }
.card { background: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
.success-message {
  background: #d4edda;
  color: #155724;
  padding: 15px;
  border-radius: 4px;
  margin-top: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.success-message button {
  background: #c3e6cb;
  color: #155724;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}

.error-message {
  background: #f8d7da;
  color: #721c24;
  padding: 15px;
  border-radius: 4px;
  margin-bottom: 20px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.error-message button {
  background: #f5c6cb;
  color: #721c24;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
}

.loading-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.8);
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.loading-spinner {
  border: 4px solid rgba(0, 0, 0, 0.1);
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border-left-color: #4CAF50;
  animation: spin 1s linear infinite;
  margin-bottom: 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

button {
  padding: 10px 20px;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s;
}

button:disabled {
  background: #cccccc;
  cursor: not-allowed;
}

button.primary {
  background: #4CAF50;
  color: white;
  margin-top: 10px;
}

button.primary:hover:not(:disabled) {
  background: #45a049;
}

p {
  margin: 10px 0;
}
</style>
