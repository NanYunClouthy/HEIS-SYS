# API 检查脚本编写计划

我将编写一个 Python 脚本 `check_api.py`，用于自动化测试后端 API 的患者挂号流程。这将帮助我们快速验证修复效果并排查 400/500 错误。

## 脚本功能流程

1. **用户登录 (`POST /auth/login`)**: 使用示例患者账号 (`patient1` / `123456`) 登录，获取 Session。
2. **获取患者信息 (`GET /patients/me`)**: 验证能否正确通过 Session 获取当前患者的 `patId`。
3. **创建挂号 (`POST /opds`)**:

   * 构造完整的 JSON 数据包，包含 `opdDate`, `opdTime`, `opdDept`, `patient: {patId: ...}`, `opdStats`。

   * 发送请求并检查响应状态码。

   * **重点检测**: 如果返回 400 或 500，打印详细的响应内容以定位字段缺失或格式错误。
4. **结果输出**: 在控制台打印每一步的成功/失败状态及关键数据。

## 技术实现

* 使用 Python 的 `requests` 库来处理 HTTP 请求和 Cookie/Session 管理。

* 脚本将保存在项目根目录下，方便您直接运行。

## 验证目标

* 确认后端是否能正确接收并解析 `OPD` 实体 JSON。

* 确认权限配置是否允许患者访问 `/patients/me` 和 `POST /opds`。

* 确认数据库外键关联（Patient -> User）是否正常工作。

