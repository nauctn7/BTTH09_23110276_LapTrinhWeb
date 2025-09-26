<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Categories Management - GraphQL Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container">
            <a class="navbar-brand" href="/">
                <i class="fas fa-store"></i> GraphQL Store
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="/products">Products</a>
                <a class="nav-link" href="/users">Users</a>
                <a class="nav-link" href="/categories">Categories</a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <h2><i class="fas fa-tags text-warning"></i> Categories Management</h2>
                <p class="text-muted">Quản lý danh mục sản phẩm</p>
            </div>
        </div>

        <!-- Add Category Form -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-plus"></i> Thêm danh mục mới
                        </h5>
                    </div>
                    <div class="card-body">
                        <form id="addCategoryForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Tên danh mục</label>
                                        <input type="text" class="form-control" id="categoryName" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Hình ảnh</label>
                                        <input type="text" class="form-control" id="categoryImages" placeholder="image.png">
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Thêm danh mục
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Categories List -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-list"></i> Danh sách danh mục
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty categories}">
                            <div class="text-center text-muted">
                                <i class="fas fa-folder-open fa-2x"></i>
                                <p class="mt-2">Không có danh mục nào</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty categories}">
                            <div class="row">
                                <c:forEach var="category" items="${categories}">
                                    <div class="col-md-6 mb-3">
                                        <div class="card">
                                            <div class="card-body">
                                                <h6 class="card-title">
                                                    <i class="fas fa-tag text-warning"></i> ${category.name}
                                                </h6>

                                                <c:choose>
                                                    <c:when test="${not empty category.images}">
                                                        <img src="${category.images}" 
                                                             class="img-thumbnail mb-2" 
                                                             style="width: 50px; height: 50px;" 
                                                             alt="${category.name}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-image text-muted fa-2x mb-2"></i>
                                                    </c:otherwise>
                                                </c:choose>

                                                <div class="mb-2">
                                                    <strong>Người dùng:</strong>
                                                    <c:if test="${empty category.users}">
                                                        <span class="text-muted">Chưa có</span>
                                                    </c:if>
                                                    <c:forEach var="user" items="${category.users}">
                                                        <span class="badge bg-success me-1">${user.fullname}</span>
                                                    </c:forEach>
                                                </div>

                                                <div class="mb-2">
                                                    <strong>Sản phẩm:</strong>
                                                    <c:if test="${empty category.products}">
                                                        <span class="text-muted">Chưa có</span>
                                                    </c:if>
                                                    <c:forEach var="prod" items="${category.products}">
                                                        <span class="badge bg-primary me-1">${prod.title}</span>
                                                    </c:forEach>
                                                </div>

                                                <button class="btn btn-sm btn-danger">
                                                    <i class="fas fa-trash"></i> Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
