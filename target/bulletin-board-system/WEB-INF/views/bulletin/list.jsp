<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="zh-TW">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>公告欄管理系統 - 公告列表</title>
                <!-- Bootstrap CSS -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Font Awesome -->
                <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
                <style>
                    .table-actions {
                        white-space: nowrap;
                    }


                    .search-box {
                        max-width: 300px;
                    }
                </style>
            </head>

            <body>
                <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
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

                <div class="container mt-4">
                    <!-- 頁面標題和操作區 -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <h2><i class="fas fa-list"></i> 公告列表</h2>
                            <p class="text-muted">共 ${totalBulletins} 筆公告</p>
                        </div>
                        <div class="col-md-6 text-end">
                            <a href="${pageContext.request.contextPath}/bulletins/new" class="btn btn-success">
                                <i class="fas fa-plus"></i> 新增公告
                            </a>
                        </div>
                    </div>

                    <!-- 搜尋表單 -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <form method="get" action="${pageContext.request.contextPath}/bulletins/list"
                                class="d-flex">
                                <input type="text" name="search" class="form-control search-box me-2"
                                    placeholder="搜尋標題..." value="${search}">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="fas fa-search"></i> 搜尋
                                </button>
                                <c:if test="${not empty search}">
                                    <a href="${pageContext.request.contextPath}/bulletins/list"
                                        class="btn btn-outline-secondary ms-2">
                                        <i class="fas fa-times"></i> 清除
                                    </a>
                                </c:if>
                            </form>
                        </div>
                    </div>

                    <!-- 成功/錯誤訊息 -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle"></i> ${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- 公告表格 -->
                    <div class="card">
                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty bulletins}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">暫無公告</h5>
                                        <p class="text-muted">
                                            <c:choose>
                                                <c:when test="${not empty search}">
                                                    找不到包含「${search}」的公告
                                                </c:when>
                                                <c:otherwise>
                                                    目前還沒有任何公告，請點擊上方「新增公告」按鈕來建立第一筆公告。
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover">
                                            <thead class="table-light">
                                                <tr>
                                                    <th>標題</th>
                                                    <th>發佈日期</th>
                                                    <th>截止日期</th>
                                                    <th>公佈者</th>
                                                    <th>附件</th>
                                                    <th class="table-actions">操作</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${bulletins}" var="bulletin">
                                                    <tr>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/bulletins/view/${bulletin.id}"
                                                                class="text-decoration-none">
                                                                ${bulletin.title}
                                                            </a>
                                                        </td>
                                                        <td>
                                                            ${bulletin.publishDate}
                                                        </td>
                                                        <td>
                                                            ${bulletin.endDate}
                                                        </td>
                                                        <td>${bulletin.publisher}</td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${not empty bulletin.attachmentPath}">
                                                                    <a href="${pageContext.request.contextPath}/bulletins/download/${bulletin.attachmentPath}"
                                                                        class="btn btn-sm btn-outline-info">
                                                                        <i class="fas fa-download"></i> 下載
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">無</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="table-actions">
                                                            <div class="btn-group" role="group">
                                                                <a href="${pageContext.request.contextPath}/bulletins/view/${bulletin.id}"
                                                                    class="btn btn-sm btn-outline-primary" title="查看">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/bulletins/edit/${bulletin.id}"
                                                                    class="btn btn-sm btn-outline-warning" title="編輯">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <button type="button"
                                                                    class="btn btn-sm btn-outline-danger" title="刪除"
                                                                    onclick="confirmDelete(${bulletin.id}, '${bulletin.title}')">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- 分頁 -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="分頁導航" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <!-- 上一頁 -->
                                <li class="page-item ${currentPage == 0 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage - 1}&search=${search}">
                                        <i class="fas fa-chevron-left"></i> 上一頁
                                    </a>
                                </li>

                                <!-- 頁碼 -->
                                <c:forEach begin="0" end="${totalPages - 1}" var="page">
                                    <c:if test="${page >= currentPage - 2 && page <= currentPage + 2}">
                                        <li class="page-item ${page == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${page}&search=${search}">${page + 1}</a>
                                        </li>
                                    </c:if>
                                </c:forEach>

                                <!-- 下一頁 -->
                                <li class="page-item ${currentPage >= totalPages - 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="?page=${currentPage + 1}&search=${search}">
                                        下一頁 <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>

                            <div class="text-center text-muted">
                                第 ${currentPage + 1} 頁，共 ${totalPages} 頁
                            </div>
                        </nav>
                    </c:if>
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

                </script>
            </body>

            </html>