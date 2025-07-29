<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告欄管理系統 - ${bulletin.title}</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .bulletin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
        }
        .bulletin-meta {
            background-color: #f8f9fa;
            border-left: 4px solid #007bff;
            padding: 1rem;
        }
        .bulletin-content {
            line-height: 1.8;
            font-size: 1.1rem;
        }
        .expired-notice {
            background-color: #f8d7da;
            border-left: 4px solid #dc3545;
            color: #721c24;
        }
        .attachment-card {
            background-color: #e7f3ff;
            border: 1px solid #b8daff;
        }
        .print-hidden {
            display: none;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .print-hidden {
                display: block !important;
            }
            .bulletin-header {
                background: #333 !important;
                -webkit-print-color-adjust: exact;
            }
        }
    </style>
</head>
<body>
    <!-- 導航列 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary no-print">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-bullhorn"></i> 公告欄管理系統
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/list">公告列表</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/new">新增公告</a>
            </div>
        </div>
    </nav>

    <!-- 公告標題區 -->
    <div class="bulletin-header">
        <div class="container">
            <div class="row">
                <div class="col">
                    <h1 class="display-6 mb-0">${bulletin.title}</h1>
                    <c:if test="${isExpired}">
                        <span class="badge bg-danger fs-6 mt-2">
                            <i class="fas fa-exclamation-triangle"></i> 已過期
                        </span>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <!-- 麵包屑導航 -->
        <nav aria-label="breadcrumb" class="no-print">
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="${pageContext.request.contextPath}/bulletins/list">
                        <i class="fas fa-list"></i> 公告列表
                    </a>
                </li>
                <li class="breadcrumb-item active">公告詳情</li>
            </ol>
        </nav>

        <!-- 過期提醒 -->
        <c:if test="${isExpired}">
            <div class="alert expired-notice" role="alert">
                <i class="fas fa-exclamation-triangle"></i>
                <strong>注意：</strong>此公告已於 
                <fmt:formatDate value="${bulletin.endDate}" pattern="yyyy年MM月dd日"/> 過期。
            </div>
        </c:if>

        <div class="row">
            <!-- 主要內容 -->
            <div class="col-lg-8">
                <!-- 公告資訊卡片 -->
                <div class="card mb-4">
                    <div class="card-body">
                        <!-- 基本資訊 -->
                        <div class="bulletin-meta mb-4">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">
                                        <i class="fas fa-user"></i> 公佈者
                                    </h6>
                                    <p class="mb-3">${bulletin.publisher}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">
                                        <i class="fas fa-calendar-alt"></i> 發佈日期
                                    </h6>
                                    <p class="mb-3">
                                        ${bulletin.publishDate}
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted mb-1">
                                        <i class="fas fa-calendar-times"></i> 截止日期
                                    </h6>
                                    <p class="mb-0">
                                        ${bulletin.endDate}
                                    </p>
                                </div>
                            </div>
                        </div>

                        <!-- 公告內容 -->
                        <div class="bulletin-content">
                            <h5 class="mb-3">
                                <i class="fas fa-file-text"></i> 公告內容
                            </h5>
                            <c:choose>
                                <c:when test="${not empty bulletin.content}">
                                    <div class="content-area">
                                        ${bulletin.content}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p class="text-muted fst-italic">此公告暫無詳細內容。</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 側邊欄 -->
            <div class="col-lg-4">
                <!-- 操作按鈕 -->
                <div class="card mb-4 no-print">
                    <div class="card-header">
                        <h6 class="card-title mb-0">
                            <i class="fas fa-cogs"></i> 操作選項
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="d-grid gap-2">
                            <a href="${pageContext.request.contextPath}/bulletins/edit/${bulletin.id}" 
                               class="btn btn-warning">
                                <i class="fas fa-edit"></i> 編輯公告
                            </a>
                            <button type="button" class="btn btn-danger" 
                                    onclick="confirmDelete(${bulletin.id}, '${bulletin.title}')">
                                <i class="fas fa-trash"></i> 刪除公告
                            </button>
                            <button type="button" class="btn btn-info" onclick="window.print()">
                                <i class="fas fa-print"></i> 列印公告
                            </button>
                            <a href="${pageContext.request.contextPath}/bulletins/list" 
                               class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> 返回列表
                            </a>
                        </div>
                    </div>
                </div>

                <!-- 附件下載 -->
                <c:if test="${not empty bulletin.attachmentPath}">
                    <div class="card attachment-card">
                        <div class="card-header">
                            <h6 class="card-title mb-0">
                                <i class="fas fa-paperclip"></i> 附件下載
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="text-center">
                                <i class="fas fa-file fa-3x text-primary mb-3"></i>
                                <p class="mb-2">${bulletin.attachmentPath}</p>
                                <a href="${pageContext.request.contextPath}/bulletins/download/${bulletin.attachmentPath}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-download"></i> 下載附件
                                </a>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- 公告統計 -->
                <div class="card mt-4 no-print">
                    <div class="card-header">
                        <h6 class="card-title mb-0">
                            <i class="fas fa-chart-bar"></i> 公告資訊
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row text-center">
                            <div class="col-6">
                                <div class="border-end">
                                    <h4 class="text-primary">#${bulletin.id}</h4>
                                    <small class="text-muted">公告編號</small>
                                </div>
                            </div>
                            <div class="col-6">
                                <h4 class="${isExpired ? 'text-danger' : 'text-success'}">
                                    <c:choose>
                                        <c:when test="${isExpired}">已過期</c:when>
                                        <c:otherwise>有效</c:otherwise>
                                    </c:choose>
                                </h4>
                                <small class="text-muted">狀態</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 列印專用標題 -->
    <div class="print-hidden text-center mt-4">
        <hr>
        <p class="text-muted">公告欄管理系統 - 列印時間：<script>document.write(new Date().toLocaleString());</script></p>
    </div>

    <!-- 刪除確認 Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">確認刪除</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>確定要刪除公告「<span id="deleteTitle"></span>」嗎？</p>
                    <p class="text-danger">此操作無法復原！</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <form method="post" id="deleteForm" style="display: inline;">
                        <button type="submit" class="btn btn-danger">確認刪除</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 刪除確認功能
        function confirmDelete(id, title) {
            document.getElementById('deleteTitle').textContent = title;
            document.getElementById('deleteForm').action = 
                '${pageContext.request.contextPath}/bulletins/delete/' + id;
            
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }

        // 列印樣式優化
        window.addEventListener('beforeprint', function() {
            document.body.classList.add('printing');
        });

        window.addEventListener('afterprint', function() {
            document.body.classList.remove('printing');
        });
    </script>
    </body>
</html>