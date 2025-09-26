<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Products Management - GraphQL Store</title>
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
                <h2><i class="fas fa-box text-primary"></i> Products Management</h2>
                <p class="text-muted">Quản lý sản phẩm với GraphQL API</p>
            </div>
        </div>

        <!-- Controls -->
        <div class="row mb-4">
            <div class="col-md-6">
                <a href="/products?sort=price" class="btn btn-primary">
                    <i class="fas fa-sort-amount-up"></i> Sắp xếp theo giá (thấp → cao)
                </a>
                <a href="/products" class="btn btn-info">
                    <i class="fas fa-list"></i> Tất cả sản phẩm
                </a>
            </div>
            <div class="col-md-6">
                <form action="/products/filter" method="get" class="input-group">
                    <select class="form-select" name="categoryId">
                        <option value="">Chọn danh mục...</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.id}">${cat.name}</option>
                        </c:forEach>
                    </select>
                    <button class="btn btn-success" type="submit">
                        <i class="fas fa-filter"></i> Lọc theo danh mục
                    </button>
                </form>
            </div>
        </div>

        <!-- Add Product Form -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-plus"></i> Thêm sản phẩm mới
                        </h5>
                    </div>
                    <div class="card-body">
                        <form action="/products/add" method="post">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Tên sản phẩm</label>
                                        <input type="text" class="form-control" name="title" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Số lượng</label>
                                        <input type="number" class="form-control" name="quantity" required>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Giá</label>
                                        <input type="number" class="form-control" name="price" step="0.01" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label class="form-label">Mô tả</label>
                                        <textarea class="form-control" name="description" rows="3"></textarea>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Người dùng</label>
                                        <select class="form-select" name="userId" required>
                                            <c:forEach var="u" items="${users}">
                                                <option value="${u.id}">${u.fullname} (${u.email})</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Danh mục</label>
                                        <select class="form-select" name="categoryId" required>
                                            <c:forEach var="c" items="${categories}">
                                                <option value="${c.id}">${c.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-save"></i> Thêm sản phẩm
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Products List -->
        <div class="row">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-list"></i> Danh sách sản phẩm
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${empty products}">
                            <div class="text-center text-muted">
                                <i class="fas fa-inbox fa-2x"></i>
                                <p class="mt-2">Không có sản phẩm nào</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty products}">
                            <div class="table-responsive">
                                <table class="table table-striped">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên</th>
                                            <th>Số lượng</th>
                                            <th>Giá</th>
                                            <th>Mô tả</th>
                                            <th>Người dùng</th>
                                            <th>Danh mục</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="p" items="${products}">
                                            <tr>
                                                <td>${p.id}</td>
                                                <td><strong>${p.title}</strong></td>
                                                <td><span class="badge bg-info">${p.quantity}</span></td>
                                                <td><strong class="text-success">${p.price}</strong></td>
                                                <td>${p.description}</td>
                                                <td>${p.user.fullname}</td>
                                                <td><span class="badge bg-primary">${p.category.name}</span></td>
                                                <td>
                                                    <a href="/products/delete/${p.id}" class="btn btn-sm btn-danger">
                                                        <i class="fas fa-trash"></i>
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function fetchProductsSortedByPrice() {
    $.ajax({
        url: '/graphql',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            query: `
                query {
                    productsSortedByPriceAsc {
                        id title quantity price description
                        user { fullname }
                        category { name }
                    }
                }
            `
        }),
        success: function(res) {
            const products = res.data.productsSortedByPriceAsc;
            let html = '';
            products.forEach(p => {
                html += `<tr>
                    <td>${p.id}</td>
                    <td><strong>${p.title}</strong></td>
                    <td><span class="badge bg-info">${p.quantity}</span></td>
                    <td><strong class="text-success">${p.price}</strong></td>
                    <td>${p.description || ''}</td>
                    <td>${p.user ? p.user.fullname : ''}</td>
                    <td><span class="badge bg-primary">${p.category ? p.category.name : ''}</span></td>
                    <td>
                        <button class="btn btn-sm btn-danger" onclick="deleteProduct(${p.id})">
                            <i class="fas fa-trash"></i>
                        </button>
                    </td>
                </tr>`;
            });
            $("tbody").html(html);
        }
    });
}

// Gọi hàm khi bấm nút sắp xếp
$(document).on('click', '.btn-primary', function(e) {
    if($(this).text().includes('Sắp xếp')) {
        e.preventDefault();
        fetchProductsSortedByPrice();
    }
});

// Hàm xóa sản phẩm
function deleteProduct(id) {
    if(!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;
    $.ajax({
        url: '/graphql',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            query: `
                mutation { deleteProduct(id: ${id}) }
            `
        }),
        success: function() {
            fetchProductsSortedByPrice();
        }
    });
}
// Lọc sản phẩm theo category
function fetchProductsByCategory(categoryId) {
    $.ajax({
        url: '/graphql',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            query: `
                query {
                    productsByCategory(categoryId: ${categoryId}) {
                        id title quantity price description
                        user { fullname }
                        category { name }
                    }
                }
            `
        }),
        success: function(res) {
            const products = res.data.productsByCategory;
            let html = '';
            products.forEach(p => {
                html += `<tr>
                    <td>${p.id}</td>
                    <td><strong>${p.title}</strong></td>
                    <td><span class=\"badge bg-info\">${p.quantity}</span></td>
                    <td><strong class=\"text-success\">${p.price}</strong></td>
                    <td>${p.description || ''}</td>
                    <td>${p.user ? p.user.fullname : ''}</td>
                    <td><span class=\"badge bg-primary\">${p.category ? p.category.name : ''}</span></td>
                    <td>
                        <button class=\"btn btn-sm btn-danger\" onclick=\"deleteProduct(${p.id})\">
                            <i class=\"fas fa-trash\"></i>
                        </button>
                    </td>
                </tr>`;
            });
            $("tbody").html(html);
        }
    });
}

// Bắt sự kiện lọc theo category
$(document).on('submit', 'form[action="/products/filter"]', function(e) {
    e.preventDefault();
    var categoryId = $(this).find('select[name="categoryId"]').val();
    if(categoryId) fetchProductsByCategory(categoryId);
});

// Thêm sản phẩm mới qua GraphQL
$(document).on('submit', 'form[action="/products/add"]', function(e) {
    e.preventDefault();
    var form = $(this);
    var data = {
        title: form.find('input[name="title"]').val(),
        quantity: parseInt(form.find('input[name="quantity"]').val()),
        price: parseFloat(form.find('input[name="price"]').val()),
        description: form.find('textarea[name="description"]').val(),
        userId: parseInt(form.find('select[name="userId"]').val()),
        categoryId: parseInt(form.find('select[name="categoryId"]').val())
    };
    $.ajax({
        url: '/graphql',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
            query: `
                mutation($input: ProductInput!) {
                    createProduct(input: $input) {
                        id title quantity price description
                        user { fullname }
                        category { name }
                    }
                }
            `,
            variables: { input: data }
        }),
        success: function() {
            fetchProductsSortedByPrice();
            form[0].reset();
        }
    });
});

// TODO: CRUD user, category: có thể làm tương tự như trên (tạo form, gọi mutation createUser, updateUser, deleteUser, createCategory, ...)
</script>
</body>
</html>
