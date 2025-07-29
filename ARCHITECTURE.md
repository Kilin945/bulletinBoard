# 佈告欄系統架構說明文件

## 專案概述

這是一個基於 **SpringMVC + Hibernate + Bootstrap** 的佈告欄管理系統，部署在 **GCP CentOS** 環境中。

**專案網址**：http://34.9.25.6:8080/bulletin-board/  
**GitHub**：https://github.com/Kilin945/bulletinBoard.git

---

## 技術架構圖

```
瀏覽器 (Browser)
     ↓ HTTP Request
Apache Tomcat (Web Container)
     ↓
SpringMVC (Web Framework)
     ↓
Service Layer (業務邏輯層)
     ↓
DAO Layer (資料存取層)
     ↓
Hibernate (ORM Framework)
     ↓
MariaDB/MySQL (資料庫)
```

---

## 技術棧詳解

### 1. 前端技術

#### **Bootstrap 5.3**
- **作用**：CSS 框架，提供響應式設計和美觀的 UI 組件
- **特點**：
  - 響應式網格系統
  - 豐富的 UI 組件（按鈕、表格、表單等）
  - 移動設備優先的設計理念

#### **JSP (JavaServer Pages)**
- **作用**：伺服器端頁面技術，動態生成 HTML
- **特點**：
  - 可嵌入 Java 程式碼
  - 支援 JSTL 標籤庫
  - 與 Spring 框架整合良好

#### **JSTL (JSP Standard Tag Library)**
- **作用**：提供標準化的 JSP 標籤
- **常用標籤**：
  ```jsp
  <c:forEach>    <!-- 迴圈 -->
  <c:if>         <!-- 條件判斷 -->
  <c:choose>     <!-- 多重條件 -->
  <fmt:formatDate> <!-- 日期格式化 -->
  ```

#### **CKEditor 5**
- **作用**：富文本編輯器
- **功能**：支援文字格式化、表格、列表等

### 2. 後端框架

#### **Spring MVC**
- **作用**：Web 應用程式框架，實現 MVC 架構模式
- **核心組件**：
  - **Controller**：處理 HTTP 請求
  - **Model**：數據模型
  - **View**：視圖層（JSP）

#### **核心概念**：
```java
@Controller  // 控制器註解
@RequestMapping("/bulletins")  // URL 對應
public class BulletinController {
    
    @GetMapping("/list")  // GET 請求處理
    public String list(Model model) {
        // 業務邏輯
        return "bulletin/list";  // 返回視圖名稱
    }
}
```

#### **Hibernate**
- **作用**：ORM（物件關聯對應）框架
- **功能**：
  - 將 Java 物件對應到資料庫表
  - 自動生成 SQL 語句
  - 管理資料庫連接和事務

#### **核心概念**：
```java
@Entity  // 實體註解
@Table(name = "bulletin_board")  // 對應資料庫表
public class Bulletin {
    @Id  // 主鍵
    @GeneratedValue(strategy = GenerationType.IDENTITY)  // 自動生成
    private Long id;
    
    @Column(name = "title")  // 對應資料庫欄位
    private String title;
}
```

### 3. 資料庫

#### **MariaDB/MySQL**
- **作用**：關聯式資料庫管理系統
- **表結構**：
```sql
CREATE TABLE bulletin_board (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    publisher VARCHAR(100) NOT NULL,
    publish_date DATE NOT NULL,
    end_date DATE NOT NULL,
    content TEXT NOT NULL,
    attachment_path VARCHAR(500),
    attachment_filename VARCHAR(255)
);
```

### 4. 建構工具

#### **Maven**
- **作用**：專案管理和建構工具
- **功能**：
  - 依賴管理（pom.xml）
  - 編譯和打包
  - 生成 WAR 檔案

---

## 專案結構詳解

```
src/
├── main/
│   ├── java/com/bulletinboard/
│   │   ├── controller/          # 控制器層
│   │   │   ├── BulletinController.java
│   │   │   └── HomeController.java
│   │   ├── service/             # 服務層
│   │   │   ├── BulletinService.java
│   │   │   └── impl/BulletinServiceImpl.java
│   │   ├── dao/                 # 資料存取層
│   │   │   ├── BulletinDAO.java
│   │   │   └── impl/SimpleBulletinDAOImpl.java
│   │   ├── model/               # 實體模型
│   │   │   └── Bulletin.java
│   │   └── converter/           # 類型轉換器
│   │       └── StringToLocalDateConverter.java
│   ├── resources/
│   │   ├── applicationContext.xml    # Spring 容器設定
│   │   └── hibernate.cfg.xml         # Hibernate 設定
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── dispatcher-servlet.xml # SpringMVC 設定
│       │   ├── web.xml               # Web 應用程式設定
│       │   └── views/                # JSP 視圖
│       │       └── bulletin/
│       │           ├── list.jsp     # 列表頁面
│       │           ├── form.jsp     # 新增/編輯頁面
│       │           └── view.jsp     # 詳情頁面
│       └── index.jsp
```

---

## 分層架構說明

### 1. 控制器層 (Controller Layer)
**檔案**：`BulletinController.java`

**職責**：
- 接收 HTTP 請求
- 呼叫服務層處理業務邏輯
- 返回視圖和數據

**範例**：
```java
@GetMapping("/list")
public String list(@RequestParam(defaultValue = "1") int page,
                   @RequestParam(required = false) String search,
                   Model model) {
    // 呼叫服務層獲取數據
    List<Bulletin> bulletins = bulletinService.getBulletinsByPage(page, 10);
    model.addAttribute("bulletins", bulletins);
    return "bulletin/list";  // 返回 JSP 視圖
}
```

### 2. 服務層 (Service Layer)
**檔案**：`BulletinServiceImpl.java`

**職責**：
- 實現業務邏輯
- 協調多個 DAO 操作
- 處理事務管理

**範例**：
```java
@Override
public Bulletin createBulletin(Bulletin bulletin, MultipartFile attachmentFile) throws Exception {
    // 處理附件上傳
    if (attachmentFile != null && !attachmentFile.isEmpty()) {
        saveAttachment(bulletin, attachmentFile);
    }
    // 保存到資料庫
    return bulletinDAO.save(bulletin);
}
```

### 3. 資料存取層 (DAO Layer)
**檔案**：`SimpleBulletinDAOImpl.java`

**職責**：
- 與資料庫交互
- 執行 CRUD 操作
- 管理 Hibernate Session

**範例**：
```java
@Override
public Bulletin save(Bulletin bulletin) {
    Session session = sessionFactory.openSession();
    try {
        session.beginTransaction();
        session.saveOrUpdate(bulletin);
        session.getTransaction().commit();
        return bulletin;
    } finally {
        session.close();
    }
}
```

### 4. 實體層 (Model Layer)
**檔案**：`Bulletin.java`

**職責**：
- 定義數據結構
- 對應資料庫表
- 提供業務方法

**範例**：
```java
@Entity
@Table(name = "bulletin_board")
public class Bulletin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "title", nullable = false, length = 200)
    private String title;
    
    // 業務方法
    public boolean isExpired() {
        return endDate.isBefore(LocalDate.now());
    }
}
```

---

## 設定檔詳解

### 1. pom.xml (Maven 設定)
**作用**：定義專案依賴和建構設定

**重要依賴**：
```xml
<!-- SpringMVC -->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-webmvc</artifactId>
    <version>5.3.23</version>
</dependency>

<!-- Hibernate -->
<dependency>
    <groupId>org.hibernate</groupId>
    <artifactId>hibernate-core</artifactId>
    <version>5.6.15.Final</version>
</dependency>

<!-- MySQL 驅動 -->
<dependency>
    <groupId>com.mysql</groupId>
    <artifactId>mysql-connector-j</artifactId>
    <version>8.0.33</version>
</dependency>
```

### 2. web.xml (Web 應用程式設定)
**作用**：定義 Servlet 和過濾器

**核心設定**：
```xml
<!-- SpringMVC 前端控制器 -->
<servlet>
    <servlet-name>dispatcher</servlet-name>
    <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
    <load-on-startup>1</load-on-startup>
</servlet>

<!-- URL 對應 -->
<servlet-mapping>
    <servlet-name>dispatcher</servlet-name>
    <url-pattern>/</url-pattern>
</servlet-mapping>
```

### 3. dispatcher-servlet.xml (SpringMVC 設定)
**作用**：定義 SpringMVC 組件

**重要設定**：
```xml
<!-- 啟用註解驅動 -->
<mvc:annotation-driven/>

<!-- 組件掃描 -->
<context:component-scan base-package="com.bulletinboard"/>

<!-- 視圖解析器 -->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
    <property name="prefix" value="/WEB-INF/views/"/>
    <property name="suffix" value=".jsp"/>
</bean>
```

### 4. hibernate.cfg.xml (Hibernate 設定)
**作用**：定義資料庫連接和 Hibernate 行為

**核心設定**：
```xml
<!-- 資料庫連接 -->
<property name="hibernate.connection.url">
    jdbc:mysql://localhost:3306/bulletin_board_system?useUnicode=true&amp;characterEncoding=UTF-8&amp;serverTimezone=Asia/Taipei
</property>
<property name="hibernate.connection.username">root</property>
<property name="hibernate.connection.password">a87654331</property>

<!-- 實體類對應 -->
<mapping class="com.bulletinboard.model.Bulletin"/>
```

---

## 資料流程說明

### 1. 顯示公告列表
```
1. 使用者訪問 /bulletins/list
2. BulletinController.list() 方法被呼叫
3. 呼叫 BulletinService.getBulletinsByPage()
4. 呼叫 BulletinDAO.findByPage()
5. Hibernate 生成 SQL：SELECT * FROM bulletin_board LIMIT...
6. 返回 List<Bulletin> 到 Controller
7. Controller 將數據放入 Model
8. 返回 "bulletin/list" 視圖名稱
9. 視圖解析器解析為 /WEB-INF/views/bulletin/list.jsp
10. JSP 渲染 HTML 返回給瀏覽器
```

### 2. 新增公告
```
1. 使用者提交表單到 /bulletins
2. BulletinController.create() 方法被呼叫
3. Spring 自動將表單數據綁定到 Bulletin 物件
4. 呼叫 BulletinService.createBulletin()
5. 處理附件上傳（如果有）
6. 呼叫 BulletinDAO.save()
7. Hibernate 生成 SQL：INSERT INTO bulletin_board...
8. 重定向到列表頁面
```

---

## 關鍵技術概念

### 1. MVC 架構模式
- **Model**：Bulletin 實體類，代表數據和業務邏輯
- **View**：JSP 頁面，負責展示數據
- **Controller**：BulletinController，處理用戶請求

### 2. 依賴注入 (Dependency Injection)
```java
@Autowired
private BulletinService bulletinService;  // Spring 自動注入
```

### 3. ORM 對應
- **物件**：Bulletin Java 類
- **表**：bulletin_board 資料庫表
- **欄位對應**：@Column 註解

### 4. 事務管理
```java
Session session = sessionFactory.openSession();
session.beginTransaction();  // 開始事務
// 資料庫操作
session.getTransaction().commit();  // 提交事務
```

---

## 部署架構

### 1. 本地開發環境
- **作業系統**：macOS
- **IDE**：VS Code
- **資料庫**：MySQL/MariaDB
- **應用伺服器**：Tomcat (開發模式)

### 2. 生產環境
- **雲端平台**：Google Cloud Platform (GCP)
- **作業系統**：CentOS Stream 9
- **資料庫**：MariaDB
- **應用伺服器**：Tomcat 9
- **網路**：外部 IP 34.9.25.6:8080

### 3. 部署流程
```
1. 本地開發和測試
2. Maven 打包：mvn clean package
3. 生成 bulletin-board.war
4. 上傳到 GCP CentOS VM
5. 複製到 Tomcat webapps 目錄
6. 重啟 Tomcat 服務
7. 自動解壓和部署
8. 對外提供服務
```

---

## 常見問題和解決方案

### 1. 資料庫連接問題
**問題**：`Access denied for user 'root'@'localhost'`
**解決**：檢查 hibernate.cfg.xml 中的用戶名密碼

### 2. 日期格式化問題
**問題**：`Cannot convert LocalDate to Date`
**解決**：使用 StringToLocalDateConverter 自動轉換

### 3. 事務管理問題
**問題**：`Cannot unwrap to requested type [javax.sql.DataSource]`
**解決**：使用手動 Session 管理而非自動事務

### 4. 附件上傳問題
**問題**：文件上傳失敗
**解決**：配置 multipart resolver 和檔案路徑

---

## 擴展建議

### 1. 功能擴展
- 用戶權限管理
- 公告分類功能
- 搜索和排序優化
- 郵件通知功能

### 2. 技術升級
- 升級到 Spring Boot
- 使用 Spring Data JPA
- 添加 Redis 快取
- 實現 RESTful API

### 3. 部署優化
- 使用 Docker 容器化
- 實現 CI/CD 自動部署
- 負載均衡和高可用
- 監控和日誌管理

---

## 總結

這個專案展示了經典的 **Java Web 開發模式**：

1. **SpringMVC** 提供了優雅的 MVC 架構
2. **Hibernate** 簡化了資料庫操作
3. **Bootstrap** 提供了現代化的前端體驗
4. **Maven** 統一了專案管理
5. **GCP** 提供了可靠的雲端部署環境

通過這個專案，您已經掌握了企業級 Java Web 應用程式的核心技術棧和開發流程。

---

**專案作者**：完成於 2025年7月29日  
**技術支援**：Claude Code  
**專案網址**：http://34.9.25.6:8080/bulletin-board/