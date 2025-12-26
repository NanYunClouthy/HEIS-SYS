# 系统功能完善计划：特定医生挂号与专属候诊列表

我将按照您的要求，分前后端两部分来实现"选择特定医生挂号"和"医生仅查看名下挂号"的功能。

## 1. 后端开发 (Backend)

我们将扩展 API 以支持按科室查询医生和按医生查询候诊列表。

*   **Repository 层**:
    *   `DoctorRepository`: 新增 `findByDocDept(String docDept)` 方法，用于获取特定科室的医生列表。
    *   `OPDRepository`: 新增 `findByDoctorDocIdAndOpdStats(Integer docId, Integer opdStats)` 方法，用于获取特定医生的候诊记录。

*   **Service 层**:
    *   `DoctorService`: 增加 `getDoctorsByDept` 业务逻辑。
    *   `OPDService`: 增加 `getWaitingPatientsByDoctor` 业务逻辑。

*   **Controller 层**:
    *   `DoctorController`: 新增 `GET /doctors/dept/{dept}` 接口，供前端挂号页面调用。
    *   `OPDController`: 新增 `GET /opds/waiting/my` 接口。该接口将自动从登录 Session 中获取当前医生身份，并返回其名下的待就诊患者列表，确保数据安全和隔离。

## 2. 前端开发 (Frontend)

*   **API 模块更新**:
    *   `src/api/doctor.js`: 添加 `getDoctorsByDept` 方法。
    *   `src/api/opd.js`: 添加 `getWaitingPatientsByDoctor` 方法。

*   **患者挂号页面 (`Register.vue` & `Pay.vue`)**:
    *   **挂号页**: 在选择科室后，动态加载该科室的医生列表供患者选择。
    *   **支付页**: 接收选择的医生 ID，并在确认支付后将其包含在挂号数据中提交给后端。

*   **医生候诊页面 (`WaitingList.vue`)**:
    *   **移除科室选择器**: 删除手动选择科室的功能。
    *   **自动加载**: 页面加载时直接调用新的 `getWaitingPatientsByDoctor` 接口，仅展示挂在当前登录医生名下的患者。

## 执行顺序
1.  修改 Backend (Repository -> Service -> Controller)。
2.  修改 Frontend API 文件。
3.  修改前端页面 (`Register.vue`, `Pay.vue`, `WaitingList.vue`)。
4.  验证功能。
