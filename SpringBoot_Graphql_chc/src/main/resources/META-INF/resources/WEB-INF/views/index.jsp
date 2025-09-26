<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>GraphQL Store Management</title>
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
                <h1 class="text-center mb-4">
                    <i class="fas fa-chart-line text-primary"></i>
                    GraphQL Store Management System
                </h1>
                <p class="text-center text-muted mb-5">
                    Quản lý sản phẩm, người dùng và danh mục với GraphQL API
                </p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body text-center">
                        <i class="fas fa-box fa-3x text-primary mb-3"></i>
                        <h5 class="card-title">Products</h5>
                        <p class="card-text">Quản lý sản phẩm, xem theo giá, theo danh mục</p>
                        <a href="/products" class="btn btn-primary">
                            <i class="fas fa-arrow-right"></i> Quản lý Products
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body text-center">
                        <i class="fas fa-users fa-3x text-success mb-3"></i>
                        <h5 class="card-title">Users</h5>
                        <p class="card-text">Quản lý người dùng và mối quan hệ với danh mục</p>
                        <a href="/users" class="btn btn-success">
                            <i class="fas fa-arrow-right"></i> Quản lý Users
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-body text-center">
                        <i class="fas fa-tags fa-3x text-warning mb-3"></i>
                        <h5 class="card-title">Categories</h5>
                        <p class="card-text">Quản lý danh mục sản phẩm</p>
                        <a href="/categories" class="btn btn-warning">
                            <i class="fas fa-arrow-right"></i> Quản lý Categories
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row mt-5">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0">
                            <i class="fas fa-info-circle"></i> GraphQL Endpoints
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-play text-success"></i> GraphQL Playground</h6>
                                <p><a href="/graphiql" target="_blank" class="btn btn-sm btn-outline-success">Mở GraphiQL</a></p>
                                
                                <h6><i class="fas fa-code text-primary"></i> GraphQL Endpoint</h6>
                                <code>/graphql</code>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-list text-info"></i> Các Query chính:</h6>
                                <ul class="list-unstyled">
                                    <li><code>productsSortedByPriceAsc</code></li>
                                    <li><code>productsByCategory</code></li>
                                    <li><code>users, categories, products</code></li>
                                </ul>
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
