<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>佈告欄系統</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">佈告欄系統</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/list">所有公告</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/bulletins/new">新增公告</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h1 class="mb-4">歡迎使用佈告欄系統</h1>
                
                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>
                
                <div class="row">
                    <div class="col-md-8">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0">最新公告</h5>
                                <a href="${pageContext.request.contextPath}/bulletins/list" class="btn btn-sm btn-outline-primary">查看全部</a>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty recentBulletins}">
                                        <div class="list-group list-group-flush">
                                            <c:forEach var="bulletin" items="${recentBulletins}">
                                                <div class="list-group-item">
                                                    <div class="d-flex w-100 justify-content-between">
                                                        <h6 class="mb-1">
                                                            <a href="${pageContext.request.contextPath}/bulletins/${bulletin.id}" class="text-decoration-none">
                                                                ${bulletin.title}
                                                            </a>
                                                        </h6>
                                                        <small class="text-muted">
                                                            <fmt:formatDate value="${bulletin.publishDate}" pattern="yyyy/MM/dd"/>
                                                        </small>
                                                    </div>
                                                    <p class="mb-1 text-muted">發布者: ${bulletin.publisher}</p>
                                                    <c:if test="${not empty bulletin.content}">
                                                        <small class="text-muted">
                                                            ${bulletin.content.length() > 100 ? bulletin.content.substring(0, 100) + '...' : bulletin.content}
                                                        </small>
                                                    </c:if>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">目前沒有公告</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-md-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">系統資訊</h5>
                            </div>
                            <div class="card-body">
                                <p class="card-text">總公告數: <strong>${totalCount}</strong></p>
                                <hr>
                                <div class="d-grid gap-2">
                                    <a href="${pageContext.request.contextPath}/bulletins/new" class="btn btn-primary">
                                        新增公告
                                    </a>
                                    <a href="${pageContext.request.contextPath}/bulletins/list" class="btn btn-outline-secondary">
                                        管理公告
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>