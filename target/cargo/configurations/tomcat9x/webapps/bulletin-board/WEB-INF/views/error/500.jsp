<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - 伺服器錯誤</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        .error-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
        }
        .error-number {
            font-size: 8rem;
            font-weight: bold;
            color: #f5576c;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }
        .error-icon {
            color: #f5576c;
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
                            <i class="fas fa-exclamation-triangle error-icon fa-4x"></i>
                            <div class="error-number">500</div>
                            <h2 class="mb-4">伺服器錯誤</h2>
                            <p class="text-muted mb-4">
                                抱歉，伺服器發生內部錯誤，暫時無法處理您的請求。
                                <br>
                                請稍後再試，或聯繫系統管理員。
                            </p>
                            <c:if test="${not empty error}">
                                <div class="alert alert-danger">
                                    <i class="fas fa-bug"></i> 錯誤詳情：${error}
                                </div>
                            </c:if>
                            <div class="d-flex gap-3 justify-content-center">
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                    <i class="fas fa-home"></i> 返回首頁
                                </a>
                                <button type="button" class="btn btn-outline-primary" onclick="window.history.back()">
                                    <i class="fas fa-arrow-left"></i> 返回上頁
                                </button>
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