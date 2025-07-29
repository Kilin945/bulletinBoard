<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告欄管理系統</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 4rem 0;
        }
        .feature-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: none;
            height: 100%;
        }
        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .feature-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
        }
        .stats-card {
            background: linear-gradient(45deg, #f093fb 0%, #f5576c 100%);
            color: white;
            border: none;
        }
        .bulletin-card {
            border-left: 4px solid #007bff;
            transition: all 0.3s ease;
        }
        .bulletin-card:hover {
            border-left-color: #0056b3;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <!-- 導航列 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-bullhorn"></i> 公告欄管理系統
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <div class="navbar-nav ms-auto">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/">首頁</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/list">公告列表</a>
                    <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/new">新增公告</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- 主要標題區 -->
    <section class="hero-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6">
                    <h1 class="display-4 fw-bold mb-4">
                        公告欄管理系統
                    </h1>
                    <p class="lead mb-4">
                        簡單易用的公告發佈與管理平台，支援富文本編輯、檔案上傳、分頁瀏覽等功能。
                    </p>
                    <div class="d-flex gap-3">
                        <a href="${pageContext.request.contextPath}/bulletins/list" 
                           class="btn btn-light btn-lg">
                            <i class="fas fa-list"></i> 瀏覽公告
                        </a>
                        <a href="${pageContext.request.contextPath}/bulletins/new" 
                           class="btn btn-outline-light btn-lg">
                            <i class="fas fa-plus"></i> 發佈公告
                        </a>
                    </div>
                </div>
                <div class="col-lg-6 text-center">
                    <i class="fas fa-bullhorn fa-10x opacity-50"></i>
                </div>
            </div>
        </div>
    </section>

    <div class="container my-5">
        <!-- 系統統計 -->
        <div class="row mb-5">
            <div class="col-md-4 mb-3">
                <div class="card stats-card text-center">
                    <div class="card-body">
                        <i class="fas fa-file-alt fa-3x mb-3"></i>
                        <h3 class="card-title">${totalBulletins}</h3>
                        <p class="card-text">總公告數</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card bg-success text-white text-center">
                    <div class="card-body">
                        <i class="fas fa-check-circle fa-3x mb-3"></i>
                        <h3 class="card-title">
                            <c:set var="validCount" value="0"/>
                            <c:forEach items="${bulletins}" var="bulletin">
                                <c:if test="${!bulletin.endDate.isBefore(now)}">
                                    <c:set var="validCount" value="${validCount + 1}"/>
                                </c:if>
                            </c:forEach>
                            ${validCount}
                        </h3>
                        <p class="card-text">有效公告</p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-3">
                <div class="card bg-warning text-white text-center">
                    <div class="card-body">
                        <i class="fas fa-clock fa-3x mb-3"></i>
                        <h3 class="card-title">${totalBulletins - validCount}</h3>
                    </div>
                </div>
            </div>
        </div>

        <!-- 功能特色 -->
        <div class="row mb-5">
            <div class="col-12 text-center mb-4">
                <h2 class="display-6 mb-3">系統特色</h2>
                <p class="text-muted">提供完整的公告管理功能</p>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="card-body">
                        <div class="feature-icon">
                            <i class="fas fa-edit text-white fa-2x"></i>
                        </div>
                        <h5 class="card-title">富文本編輯</h5>
                        <p class="card-text text-muted">
                            支援完整的富文本編輯功能，包含格式化、插入圖片、表格等。
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="card-body">
                        <div class="feature-icon">
                            <i class="fas fa-upload text-white fa-2x"></i>
                        </div>
                        <h5 class="card-title">檔案上傳</h5>
                        <p class="card-text text-muted">
                            支援多種檔案格式上傳，包含文件、圖片、壓縮檔等。
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="card-body">
                        <div class="feature-icon">
                            <i class="fas fa-search text-white fa-2x"></i>
                        </div>
                        <h5 class="card-title">搜尋功能</h5>
                        <p class="card-text text-muted">
                            快速搜尋公告標題，支援關鍵字模糊查詢。
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="card-body">
                        <div class="feature-icon">
                            <i class="fas fa-list text-white fa-2x"></i>
                        </div>
                        <h5 class="card-title">分頁瀏覽</h5>
                        <p class="card-text text-muted">
                            支援分頁顯示，提升大量資料的瀏覽體驗。
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="card-body">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt text-white fa-2x"></i>
                        </div>
                        <h5 class="card-title">響應式設計</h5>
                        <p class="card-text text-muted">
                            完美支援電腦、平板、手機等各種裝置瀏覽。
                        </p>
                    </div>
                </div>
            </div>
            <div class="col-md-4 mb-4">
                <div class="card feature-card text-center">
                    <div class="card-body">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt text-white fa-2x"></i>
                        </div>
                        <h5 class="card-title">安全可靠</h5>
                        <p class="card-text text-muted">
                            採用 Spring Security 和資料驗證，確保系統安全。
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 最新公告 -->
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="display-6 mb-0">最新公告</h2>
                    <a href="${pageContext.request.contextPath}/bulletins/list" 
                       class="btn btn-outline-primary">
                        查看全部 <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                
                <c:choose>
                    <c:when test="${empty bulletins}">
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">暫無公告</h5>
                            <p class="text-muted">目前還沒有任何公告</p>
                            <a href="${pageContext.request.contextPath}/bulletins/new" 
                               class="btn btn-primary">
                                <i class="fas fa-plus"></i> 發佈第一則公告
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <jsp:useBean id="now" class="java.time.LocalDate" scope="request"/>
                        <c:set var="now" value="<%= java.time.LocalDate.now() %>" scope="request"/>
                        
                        <c:forEach items="${bulletins}" var="bulletin" begin="0" end="4">
                            <div class="card bulletin-card mb-3">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h5 class="card-title mb-2">
                                                <a href="${pageContext.request.contextPath}/bulletins/view/${bulletin.id}" 
                                                   class="text-decoration-none">
                                                    ${bulletin.title}
                                                </a>
                                                <c:if test="${bulletin.endDate.isBefore(now)}">
                                                </c:if>
                                            </h5>
                                            <p class="text-muted mb-0">
                                                <i class="fas fa-user"></i> ${bulletin.publisher} |
                                                <i class="fas fa-calendar"></i> 
                                                <fmt:formatDate value="${bulletin.publishDate}" pattern="yyyy-MM-dd"/>
                                            </p>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <c:if test="${not empty bulletin.attachmentPath}">
                                                <span class="badge bg-info">
                                                    <i class="fas fa-paperclip"></i> 有附件
                                                </span>
                                            </c:if>
                                            <div class="mt-2">
                                                <a href="${pageContext.request.contextPath}/bulletins/view/${bulletin.id}" 
                                                   class="btn btn-sm btn-outline-primary">
                                                    查看詳情
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- 頁尾 -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5><i class="fas fa-bullhorn"></i> 公告欄管理系統</h5>
                    <p class="text-muted">簡單易用的公告發佈與管理平台</p>
                </div>
                <div class="col-md-6 text-end">
                    <p class="text-muted mb-0">
                        &copy; 2025 公告欄管理系統. 使用 Spring MVC + Hibernate 開發
                    </p>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>