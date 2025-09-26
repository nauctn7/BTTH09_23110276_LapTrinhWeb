<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Users Management - GraphQL Store</title>
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
                <h2><i class="fas fa-users text-success"></i> Users Management</h2>
                <p class="text-muted">Quản lý người dùng và mối quan hệ với danh mục</p>
            </div>
        </div>

        <!-- Add User Form -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-plus"></i> Thêm người dùng mới
                        </h5>
                    </div>
                    <div class="card-body">
                        <form id="addUserForm">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Họ tên</label>
                                        <input type="text" class="form-control" id="userFullname" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Email</label>
                                        <input type="email" class="form-control" id="userEmail" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Mật khẩu</label>
                                        <input type="password" class="form-control" id="userPassword" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Số điện thoại</label>
                                        <input type="tel" class="form-control" id="userPhone">
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Thêm người dùng
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Users List -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-list"></i> Danh sách người dùng
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty users}">
                            <div class="text-center text-muted">
                                <i class="fas fa-user-slash fa-2x"></i>
                                <p class="mt-2">Không có người dùng nào</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty users}">
                            <div class="row">
                                <c:forEach var="user" items="${users}">
                                    <div class="col-md-6 mb-3">
                                        <div class="card">
                                            <div class="card-body">
                                                <h6 class="card-title">
                                                    <i class="fas fa-user text-primary"></i> ${user.fullname}
                                                </h6>
                                                <p class="card-text">
                                                    <small class="text-muted">
                                                        <i class="fas fa-envelope"></i> ${user.email}<br>
                                                        <i class="fas fa-phone"></i> ${user.phone}
                                                    </small>
                                                </p>

                                                <div class="mb-2">
                                                    <strong>Danh mục:</strong>
                                                    <c:if test="${empty user.categories}">
                                                        <span class="text-muted">Chưa có</span>
                                                    </c:if>
                                                    <c:forEach var="cat" items="${user.categories}">
                                                        <span class="badge bg-primary me-1">${cat.name}</span>
                                                    </c:forEach>
                                                </div>

                                                <div class="mb-2">
                                                    <strong>Sản phẩm:</strong>
                                                    <c:if test="${empty user.products}">
                                                        <span class="text-muted">Chưa có</span>
                                                    </c:if>
                                                    <c:forEach var="prod" items="${user.products}">
                                                        <span class="badge bg-success me-1">${prod.title}</span>
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
