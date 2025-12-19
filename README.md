# 医院管理系统（HEIS SYS）

## 项目简介

医院管理系统是一个基于前后端分离架构的现代化医院管理平台，采用Vue3作为前端框架，Spring Boot作为后端框架，MySQL作为数据库。

## 技术栈

### 后端
- **框架**：Spring Boot 2.7.18
- **数据库**：MySQL 5.7
- **ORM框架**：Spring Data JPA
- **构建工具**：Maven
- **其他**：Lombok

### 前端
- **框架**：Vue 3
- **路由**：Vue Router 4
- **HTTP客户端**：Axios
- **构建工具**：Vite

## 项目结构

```
HEIS SYS/
├── backend/                # 后端Spring Boot项目
│   ├── src/main/java/com/hospital/  # 后端Java代码
│   │   ├── controller/     # 控制器层
│   │   ├── entity/         # 实体类
│   │   ├── repository/     # 数据访问层
│   │   ├── service/        # 业务逻辑层
│   │   └── HospitalApplication.java  # 主启动类
│   ├── src/main/resources/ # 资源文件
│   │   └── application.yml # 配置文件
│   └── pom.xml             # Maven配置文件
├── frontend/               # 前端Vue3项目
│   ├── src/                # 前端源代码
│   │   ├── api/            # API服务
│   │   ├── assets/         # 静态资源
│   │   ├── components/     # 组件
│   │   ├── router/         # 路由配置
│   │   ├── views/          # 页面视图
│   │   ├── App.vue         # 根组件
│   │   └── main.js         # 入口文件
│   ├── index.html          # HTML模板
│   ├── package.json        # 依赖配置
│   └── vite.config.js      # Vite配置
├── database.txt            # 数据库建库脚本
├── start-all.ps1           # 一键启动脚本
└── README.md               # 项目说明文档
```

## 快速开始

### 1. 环境准备

- **JDK**：8或更高版本
- **Maven**：3.6或更高版本
- **MySQL**：5.7
- **Node.js**：14或更高版本
- **npm**：6或更高版本

### 2. 数据库配置

1. 启动MySQL服务
2. 创建数据库：
   ```sql
   CREATE DATABASE hospital_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   ```
3. 执行建库脚本：
   ```bash
   mysql -u root -p hospital_management < database.txt
   ```

### 3. 使用一键启动脚本

在项目根目录下，双击运行 `start-all.ps1` 脚本，或在PowerShell中执行：

```powershell
.\start-all.ps1
```

脚本会自动检查环境并启动前后端服务。

### 4. 手动启动（可选）

#### 后端启动

```bash
cd backend
mvn spring-boot:run
```

后端服务将运行在：`http://localhost:8080/api`

#### 前端启动

```bash
cd frontend
npm install
npm run dev
```

前端服务将运行在：`http://localhost:3000`

## 功能模块

### 已实现功能

- **患者管理**：
  - 患者列表展示
  - 添加患者
  - 编辑患者
  - 删除患者

### 待扩展功能

- 医生管理
- 药品管理
- 门诊管理
- 住院管理
- 收费管理
- 统计报表

## API接口

### 患者管理接口

| 方法 | URL | 功能 |
|------|-----|------|
| GET | /api/patients | 获取所有患者 |
| GET | /api/patients/{id} | 根据ID获取患者 |
| POST | /api/patients | 创建患者 |
| PUT | /api/patients/{id} | 更新患者 |
| DELETE | /api/patients/{id} | 删除患者 |

## 访问地址

- **前端页面**：http://localhost:3000
- **后端API**：http://localhost:8080/api
- **API文档**：待添加

## 注意事项

1. 确保MySQL数据库服务已启动
2. 确保数据库配置正确（`backend/src/main/resources/application.yml`）
3. 首次启动前端项目时，需要安装依赖
4. 如需修改端口号，请修改对应的配置文件

## 开发说明

### 后端开发

1. 后端代码位于 `backend/src/main/java/com/hospital/`
2. 遵循MVC设计模式
3. 使用Spring Data JPA简化数据库操作
4. 所有API支持跨域访问

### 前端开发

1. 前端代码位于 `frontend/src/`
2. 使用Vue 3 Composition API
3. 路由配置位于 `frontend/src/router/index.js`
4. API服务位于 `frontend/src/api/`

## 许可证

MIT License

## 联系方式

如有问题或建议，请联系项目维护者。
