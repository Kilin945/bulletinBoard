<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>公告欄管理系統 - <c:choose><c:when test="${action == 'create'}">新增公告</c:when><c:otherwise>編輯公告</c:otherwise></c:choose></title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <!-- Rich Text Editor -->
    <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
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
        <!-- 頁面標題 -->
        <div class="row mb-4">
            <div class="col">
                <h2>
                    <c:choose>
                        <c:when test="${action == 'create'}">
                            <i class="fas fa-plus"></i> 新增公告
                        </c:when>
                        <c:otherwise>
                            <i class="fas fa-edit"></i> 編輯公告
                        </c:otherwise>
                    </c:choose>
                </h2>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/bulletins/list">公告列表</a>
                        </li>
                        <li class="breadcrumb-item active">
                            <c:choose>
                                <c:when test="${action == 'create'}">新增公告</c:when>
                                <c:otherwise>編輯公告</c:otherwise>
                            </c:choose>
                        </li>
                    </ol>
                </nav>
            </div>
        </div>

        <!-- 錯誤訊息 -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle"></i> ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- 表單卡片 -->
        <div class="card">
            <div class="card-body">
                <form method="post" enctype="multipart/form-data" id="bulletinForm"
                      action="<c:choose>
                                <c:when test='${action == \"create\"}'>${pageContext.request.contextPath}/bulletins/create</c:when>
                                <c:otherwise>${pageContext.request.contextPath}/bulletins/update/${bulletin.id}</c:otherwise>
                              </c:choose>">
                    
                    <!-- 標題 -->
                    <div class="mb-3">
                        <label for="title" class="form-label">
                            <i class="fas fa-heading"></i> 標題 <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="title" name="title" 
                               value="${bulletin.title}" required maxlength="200"
                               placeholder="請輸入公告標題">
                        <div class="form-text">最多 200 個字元</div>
                    </div>

                    <!-- 公佈者 -->
                    <div class="mb-3">
                        <label for="publisher" class="form-label">
                            <i class="fas fa-user"></i> 公佈者 <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="publisher" name="publisher" 
                               value="${bulletin.publisher}" required maxlength="100"
                               placeholder="請輸入公佈者名稱">
                        <div class="form-text">最多 100 個字元</div>
                    </div>

                    <!-- 日期區域 -->
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="publishDate" class="form-label">
                                    <i class="fas fa-calendar-alt"></i> 發佈日期 <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="publishDate" name="publishDate" 
                                       value="${bulletin.publishDate}" 
                                       required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="endDate" class="form-label">
                                    <i class="fas fa-calendar-times"></i> 截止日期 <span class="text-danger">*</span>
                                </label>
                                <input type="date" class="form-control" id="endDate" name="endDate" 
                                       value="${bulletin.endDate}" 
                                       required>
                                <div class="form-text">截止日期不能早於發佈日期</div>
                            </div>
                        </div>
                    </div>

                    <!-- 公告內容 -->
                    <div class="mb-3">
                        <label for="content" class="form-label">
                            <i class="fas fa-file-text"></i> 公告內容
                        </label>
                        <textarea class="form-control" id="content" name="content" rows="10"
                                  placeholder="請輸入公告內容...">${bulletin.content}</textarea>
                        <div class="form-text">支援富文本編輯</div>
                    </div>

                    <!-- 附件上傳 -->
                    <div class="mb-3">
                        <label for="attachmentFile" class="form-label">
                            <i class="fas fa-paperclip"></i> 附件
                        </label>
                        <input type="file" class="form-control" id="attachmentFile" name="attachmentFile"
                               accept=".pdf,.doc,.docx,.xls,.xlsx,.ppt,.pptx,.zip,.rar,.jpg,.jpeg,.png,.gif">
                        
                        <!-- 顯示現有附件 -->
                        <c:if test="${not empty bulletin.attachmentPath && action != 'create'}">
                            <div class="mt-2">
                                <div class="alert alert-info">
                                    <i class="fas fa-info-circle"></i> 
                                    目前附件：
                                    <a href="${pageContext.request.contextPath}/bulletins/download/${bulletin.attachmentPath}" 
                                       class="alert-link">
                                        ${bulletin.attachmentPath}
                                    </a>
                                    <br>
                                    <small class="text-muted">如需更換附件，請選擇新檔案；若不選擇檔案則保留原附件。</small>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="form-text">
                            支援檔案類型：PDF、Office文件、圖片、壓縮檔等，檔案大小限制 50MB
                        </div>
                    </div>

                    <!-- 按鈕區域 -->
                    <div class="d-flex justify-content-between">
                        <div>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i> 
                                <c:choose>
                                    <c:when test="${action == 'create'}">建立公告</c:when>
                                    <c:otherwise>更新公告</c:otherwise>
                                </c:choose>
                            </button>
                            <button type="reset" class="btn btn-secondary ms-2">
                                <i class="fas fa-undo"></i> 重設
                            </button>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/bulletins/list" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left"></i> 返回列表
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // 初始化 TinyMCE 富文本編輯器
        tinymce.init({
            selector: '#content',
            height: 300,
            menubar: false,
            plugins: [
                'advlist', 'autolink', 'lists', 'link', 'image', 'charmap', 'preview',
                'anchor', 'searchreplace', 'visualblocks', 'code', 'fullscreen',
                'insertdatetime', 'media', 'table', 'help', 'wordcount'
            ],
            toolbar: 'undo redo | blocks | bold italic forecolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
            content_style: 'body { font-family: -apple-system, BlinkMacSystemFont, San Francisco, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 14px; }'
        });

        // 表單驗證
        document.getElementById('bulletinForm').addEventListener('submit', function(e) {
            const publishDate = new Date(document.getElementById('publishDate').value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            if (endDate < publishDate) {
                e.preventDefault();
                alert('截止日期不能早於發佈日期！');
                return false;
            }
        });

        // 檔案大小驗證
        document.getElementById('attachmentFile').addEventListener('change', function(e) {
            const file = e.target.files[0];
            if (file && file.size > 50 * 1024 * 1024) { // 50MB
                alert('檔案大小不能超過 50MB！');
                e.target.value = '';
            }
        });
    </script>
</body>
</html>