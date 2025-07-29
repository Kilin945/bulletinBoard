<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - 頁面不存在</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .error-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .error-number {
            font-size: 8rem;
            font-weight: bold;
            color: #667eea;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        .error-icon {
            color: #667eea;
            margin-bottom: 2rem;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-6 col-md-8">
                    <div class="card error-card">
                        <div class="card-body text-center p-5">
                            <i class="fas fa-search error-icon fa-4x"></i>
                            <div class="error-number">404</div>
                            <h2 class="mb-4">頁面不存在</h2>
                            <p class="text-muted mb-4">
                                抱歉，您要尋找的頁面不存在或已被移除。
                                <br>
                                請檢查網址是否正確，或返回首頁重新開始。
                            </p>
                            <c:if test="${not empty error}">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i> ${error}
                                </div>
                            </c:if>
                            <div class="d-flex gap-3 justify-content-center">
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                    <i class="fas fa-home"></i> 返回首頁
                                </a>
                                <a href="${pageContext.request.contextPath}/bulletins/list" class="btn btn-outline-primary">
                                    <i class="fas fa-list"></i> 公告列表
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>