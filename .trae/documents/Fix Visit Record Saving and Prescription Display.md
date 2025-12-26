# 修复就诊记录保存失败与处方显示问题

我将分两步解决您遇到的问题：

## 1. 修复医生保存就诊记录失败 (500 Error)

从错误日志来看，前端在提交 `visCreatedDate` 和 `visLastModifiedDate` 时，可能因为日期格式或时区问题导致后端 JSON 反序列化失败。此外，`OPDVisitHistory` 实体中的 `doctor` 字段现在是必填的关联对象，而前端可能只传了 ID 或格式不对。

*   **前端修复 (`WaitingList.vue`)**:
    *   修改 `submitConsultation` 方法，确保 `visDocId` 转换为后端期望的 `doctor` 对象结构（`{ docId: ... }`）。
    *   **移除前端生成的日期**: 让后端处理创建时间和修改时间，避免前端传值格式不兼容。后端通常会在实体类上使用 `@PrePersist` 或在 Service 层自动设置当前时间。

*   **后端修复 (`OPDVisitHistoryController.java` / `OPDVisitHistory.java`)**:
    *   确认实体类中日期字段的注解（`@Temporal` 或 `@JsonFormat`）是否正确。
    *   在 Controller 或 Service 层手动设置日期，如果前端不传的话。

## 2. 修复患者端处方信息不显示

虽然我们在 `VisitHistory.vue` 中添加了处方显示的 UI 代码，但可能因为数据加载时机或关联查询的问题导致没有显示。

*   **后端确认 (`PrescriptionController.java`)**:
    *   确认 `getPrescriptionsByVisit` 接口是否能正确返回数据。
    *   检查 `Prescription` 实体是否正确关联了 `PrescriptionDetail` 和 `Drug`，避免懒加载（Lazy Loading）导致序列化时数据缺失。

*   **前端修复 (`VisitHistory.vue`)**:
    *   检查 `viewVisitDetail` 方法。目前代码是点击详情时才去异步加载处方。需要确保加载完成后正确赋值给 `selectedPrescriptions`。
    *   **关键点**: 检查 `v-if="selectedPrescriptions && selectedPrescriptions.length > 0"` 的判断逻辑，以及数据结构是否匹配（例如后端返回的是数组，前端是否直接使用了）。

## 执行计划

1.  **修改 `WaitingList.vue`**: 修正提交给后端的 JSON 数据结构（特别是 Doctor 关联和日期）。
2.  **修改 `OPDVisitHistoryController.java`**: 增强数据接收的健壮性，在后端补全必要字段。
3.  **验证 `VisitHistory.vue`**: 再次检查处方数据的获取和渲染逻辑。

我将首先修复 `WaitingList.vue` 中的数据提交格式，这是导致 500 错误的直接原因。
