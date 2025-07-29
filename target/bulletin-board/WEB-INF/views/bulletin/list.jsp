<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告列表 - 佈告欄系統</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">佈告欄系統</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/list">所有公告</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1>公告列表</h1>
                    <a href="${pageContext.request.contextPath}/bulletins/new" class="btn btn-primary">新增公告</a>
                </div>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- 搜索表單 -->
                <form method="get" class="mb-4">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="input-group">
                                <input type="text" name="search" class="form-control" placeholder="搜索公告標題..." value="${search}">
                                <button class="btn btn-outline-secondary" type="submit">搜索</button>
                                <c:if test="${not empty search}">
                                    <a href="${pageContext.request.contextPath}/bulletins/list" class="btn btn-outline-danger">清除</a>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </form>

                <!-- 公告列表 -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            公告列表
                            <c:if test="${not empty search}">
                                - 搜索: "${search}"
                            </c:if>
                            <span class="badge bg-secondary ms-2">共 ${totalCount} 條</span>
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${empty bulletins}">
                                <div class="text-center py-5">
                                    <h5 class="text-muted">沒有找到公告</h5>
                                    <p class="text-muted">
                                        <c:choose>
                                            <c:when test="${not empty search}">
                                                請嘗試其他搜索關鍵字或
                                                <a href="${pageContext.request.contextPath}/bulletins/list">查看所有公告</a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/bulletins/new">新增第一個公告</a>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th width="8%">ID</th>
                                                <th width="30%">標題</th>
                                                <th width="15%">發布者</th>
                                                <th width="12%">發布日期</th>
                                                <th width="12%">截止日期</th>
                                                <th width="8%">附件</th>
                                                <th width="15%">操作</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="bulletin" items="${bulletins}">
                                                <tr>
                                                    <td>${bulletin.id}</td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/bulletins/${bulletin.id}" class="text-decoration-none">
                                                            ${bulletin.title}
                                                        </a>
                                                    </td>
                                                    <td>${bulletin.publisher}</td>
                                                    <td>
                                                        ${bulletin.publishDate}
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty bulletin.endDate}">
                                                                ${bulletin.endDate}
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">無期限</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:if test="${not empty bulletin.attachmentFilename}">
                                                            <i class="bi bi-paperclip text-success"></i>
                                                        </c:if>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group btn-group-sm" role="group">
                                                            <a href="${pageContext.request.contextPath}/bulletins/${bulletin.id}" class="btn btn-outline-primary">查看</a>
                                                            <a href="${pageContext.request.contextPath}/bulletins/${bulletin.id}/edit" class="btn btn-outline-secondary">編輯</a>
                                                            <form method="post" action="${pageContext.request.contextPath}/bulletins/${bulletin.id}/delete" class="d-inline" 
                                                                  onsubmit="return confirm('確定要刪除這個公告嗎？')">
                                                                <button type="submit" class="btn btn-outline-danger">刪除</button>
                                                            </form>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- 分頁導航 -->
                                <c:if test="${totalPages > 1}">
                                    <div class="card-footer">
                                        <nav aria-label="公告分頁">
                                            <ul class="pagination justify-content-center mb-0">
                                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage - 1}<c:if test='${not empty search}'>&search=${search}</c:if>">上一頁</a>
                                                </li>
                                                
                                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                    <c:choose>
                                                        <c:when test="${pageNum == currentPage}">
                                                            <li class="page-item active">
                                                                <span class="page-link">${pageNum}</span>
                                                            </li>
                                                        </c:when>
                                                        <c:when test="${pageNum <= 3 || pageNum > totalPages - 3 || (pageNum >= currentPage - 1 && pageNum <= currentPage + 1)}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="?page=${pageNum}<c:if test='${not empty search}'>&search=${search}</c:if>">${pageNum}</a>
                                                            </li>
                                                        </c:when>
                                                        <c:when test="${pageNum == 4 && currentPage > 5}">
                                                            <li class="page-item disabled">
                                                                <span class="page-link">...</span>
                                                            </li>
                                                        </c:when>
                                                        <c:when test="${pageNum == totalPages - 3 && currentPage < totalPages - 4}">
                                                            <li class="page-item disabled">
                                                                <span class="page-link">...</span>
                                                            </li>
                                                        </c:when>
                                                    </c:choose>
                                                </c:forEach>
                                                
                                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                                    <a class="page-link" href="?page=${currentPage + 1}<c:if test='${not empty search}'>&search=${search}</c:if>">下一頁</a>
                                                </li>
                                            </ul>
                                        </nav>
                                        <div class="text-center text-muted mt-2">
                                            第 ${currentPage} 頁，共 ${totalPages} 頁，總計 ${totalCount} 條記錄
                                        </div>
                                    </div>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>