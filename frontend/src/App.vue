<template>
  <div id="app">
    <header>
      <h1>医院管理系统</h1>
      <nav>
        <router-link to="/">患者列表</router-link>
        <router-link to="/register">挂号</router-link>
        <router-link to="/waiting-list">候诊列表</router-link>
      </nav>
    </header>
    <main>
      <router-view />
    </main>
  </div>
</template>

<script setup>
// App.vue 根组件
</script>

<style>
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: Arial, sans-serif;
  line-height: 1.6;
  color: #333;
}

#app {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

header {
  background-color: #4CAF50;
  color: white;
  padding: 15px;
  margin-bottom: 20px;
  border-radius: 5px;
}

header h1 {
  text-align: center;
  font-size: 24px;
  margin-bottom: 15px;
}

nav {
  display: flex;
  justify-content: center;
  gap: 15px;
}

nav a {
  color: white;
  text-decoration: none;
  padding: 8px 16px;
  border-radius: 3px;
  background-color: rgba(255, 255, 255, 0.2);
  transition: background-color 0.3s;
}

nav a:hover {
  background-color: rgba(255, 255, 255, 0.3);
}

nav a.router-link-active {
  background-color: rgba(255, 255, 255, 0.4);
  font-weight: bold;
}

main {
  background-color: #f4f4f4;
  padding: 20px;
  border-radius: 5px;
}

button {
  padding: 8px 16px;
  margin: 5px;
  border: none;
  border-radius: 3px;
  cursor: pointer;
  font-size: 14px;
}

button:hover {
  opacity: 0.8;
}

button.primary {
  background-color: #4CAF50;
  color: white;
}

button.danger {
  background-color: #f44336;
  color: white;
}

button.warning {
  background-color: #ff9800;
  color: white;
}

form {
  background-color: white;
  padding: 20px;
  border-radius: 5px;
  margin-bottom: 20px;
}

form div {
  margin-bottom: 15px;
}

form label {
  display: block;
  margin-bottom: 5px;
  font-weight: bold;
}

form input, form select {
  width: 100%;
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 3px;
}

table {
  width: 100%;
  border-collapse: collapse;
  background-color: white;
  border-radius: 5px;
  overflow: hidden;
}

table th, table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

table th {
  background-color: #4CAF50;
  color: white;
}

table tr:hover {
  background-color: #f5f5f5;
}

.modal {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1000;
}

.modal-content {
  background-color: white;
  padding: 30px;
  border-radius: 5px;
  width: 90%;
  max-width: 500px;
}

.modal-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
}

.modal-header h2 {
  margin: 0;
  font-size: 20px;
}

.close {
  background: none;
  border: none;
  font-size: 24px;
  cursor: pointer;
  color: #aaa;
}

.close:hover {
  color: #333;
}
</style>