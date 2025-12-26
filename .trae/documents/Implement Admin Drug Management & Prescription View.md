# 管理员药品管理与处方详情显示计划

我将分两部分来完成您的需求：

## 1. 药品管理界面开发 (Frontend)

我将为管理员创建一个全新的药品管理模块，支持查看库存和添加新药。

* **API 更新**:

  * 修改 `frontend/src/api/drug.js`，补充完整的 CRUD 方法：`createDrug`, `updateDrug`, `deleteDrug`。

* **新页面开发**:

  * 创建 `frontend/src/views/DrugManagement.vue`。

  * **功能**:

    * 展示药品列表表格（名称、编码、单价、库存、单位、规格）。

    * 提供"添加药品"按钮，弹出模态框填写新药信息。

    * (可选) 提供简单的库存修改或编辑功能。

* **路由配置**:

  * 在 `frontend/src/router/index.js` 中添加 `/admin/drugs` 路由。

  * 在 `frontend/src/views/AdminDashboard.vue` 中添加"药品管理"卡片入口。

## 2. 全角色就诊记录增强

确保所有用户（患者、医生、管理员）在查看就诊记录详情时，都能看到处方信息。

* **验证与确认**:

  * 我将在 `VisitHistory.vue` 中再次确认处方详情的显示逻辑。

  * 根据上一轮的修改，`VisitHistory.vue` 已经具备了展示处方的能力（通过 `prescriptionApi.getPrescriptionsByVisitId` 获取）。

  * 我将确保这个组件被所有角色复用，并且没有权限问题阻碍数据加载。

## 执行步骤

1. 更新 `drug.js` API 文件。
2. 创建 `DrugManagement.vue` 页面。
3. 配置路由和入口。
4. 检查并微调 `VisitHistory.vue` (如果需要)。
5. 创建新python脚本文件测试后端药品增删查改功能是否正常

