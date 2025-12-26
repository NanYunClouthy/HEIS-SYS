<template>
  <div class="admin-dashboard">
    <h1>管理后台</h1>
    <div class="grid">
      <div class="card">
        <h2>患者管理</h2>
        <router-link class="primary" to="/">进入患者列表</router-link>
      </div>
      <div class="card">
        <h2>医生候诊</h2>
        <router-link class="primary" to="/waiting-list">进入候诊列表</router-link>
      </div>
      <div class="card">
        <h2>就诊记录</h2>
        <router-link class="primary" to="/visit-history">查看就诊记录</router-link>
      </div>
      <div class="card">
        <h2>药品管理</h2>
        <router-link class="primary" to="/admin/drugs">管理库存</router-link>
      </div>
    </div>
  </div>
</template>

<script>
export default { name: 'AdminDashboard' }
</script>

<style scoped>
.admin-dashboard { max-width: 1000px; margin: 0 auto; padding: 20px; }
.grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 16px; }
.card { background: #f9f9f9; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
.primary { display: inline-block; padding: 8px 16px; background: #4CAF50; color: #fff; border-radius: 4px; text-decoration: none; margin-top: 10px; }
</style>
