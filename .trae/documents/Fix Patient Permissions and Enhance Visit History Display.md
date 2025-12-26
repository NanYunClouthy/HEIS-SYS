# 修复患者权限与就诊记录显示问题

我将修复患者无法获取医生列表的权限问题，并完善就诊记录中科室显示和处方详情的功能。

## 1. 后端修复 (Backend)

*   **权限配置 (`SecurityConfig.java`)**:
    *   修改安全策略，允许所有认证用户（包括患者）访问 `GET /doctors/**` 接口，以便在挂号时获取医生列表。

*   **实体映射 (`OPDVisitHistory.java`)**:
    *   将 `visDocId` (Integer) 字段重构为 `doctor` (@ManyToOne) 关联关系。
    *   这样后端在返回就诊记录时，会自动包含医生的详细信息（如姓名、科室），解决前端显示"未知"的问题。

## 2. 前端修复 (Frontend)

*   **就诊记录页面 (`VisitHistory.vue`)**:
    *   **科室显示**: 更新数据绑定路径，从 `visit.opd.opdDept` 改为 `visit.doctor.docDept`，确保正确显示科室。
    *   **处方详情**: 在查看详情的模态框中新增一个区域，用于展示该次就诊关联的处方信息。
        *   展示内容：药品名称、单价、数量、小计。
        *   计算并显示处方总金额。

## 执行步骤
1.  修改 `SecurityConfig.java` 放开医生列表查询权限。
2.  修改 `OPDVisitHistory.java` 建立与 Doctor 的关联。
3.  修改 `VisitHistory.vue` 适配新的数据结构并添加处方展示 UI。
