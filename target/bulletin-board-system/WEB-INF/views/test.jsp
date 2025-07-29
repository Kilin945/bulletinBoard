<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>系統測試</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body text-center">
                        <h1 class="card-title text-success">✅ 系統測試</h1>
                        <p class="card-text">${message}</p>
                        <hr>
                        <p><strong>Tomcat:</strong> 正常運行</p>
                        <p><strong>Spring MVC:</strong> 正常運行</p>
                        <p><strong>JSP:</strong> 正常運行</p>
                        <div class="mt-3">
                            <a href="/bulletin-board/bulletins/list" class="btn btn-primary">前往公告列表</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>