# GraphQL Store Management System

Hệ thống quản lý cửa hàng sử dụng Spring Boot 3 + GraphQL với giao diện JSP và AJAX.

## 🚀 Tính năng chính

### 1. GraphQL API
- **Hiển thị sản phẩm theo giá tăng dần**: `productsSortedByPriceAsc`
- **Lấy sản phẩm theo danh mục**: `productsByCategory(categoryId: ID!)`
- **CRUD đầy đủ cho User, Product, Category**
- **Quan hệ N-N giữa User và Category**

### 2. Giao diện Web
- **Trang chủ**: Dashboard với thông tin tổng quan
- **Quản lý sản phẩm**: CRUD + lọc theo danh mục + sắp xếp theo giá + upload hình ảnh
- **Quản lý người dùng**: CRUD người dùng
- **Quản lý danh mục**: CRUD danh mục sản phẩm + upload hình ảnh

## 🛠️ Công nghệ sử dụng

- **Backend**: Spring Boot 3, Spring Data JPA, Spring GraphQL
- **Database**: SQL Server
- **Frontend**: JSP, Bootstrap 5, Font Awesome, AJAX
- **Build Tool**: Maven

## 📋 Yêu cầu hệ thống

- Java 17+
- Maven 3.6+
- SQL Server
- IDE hỗ trợ Spring Boot (IntelliJ IDEA, Eclipse, VS Code)

## 🚀 Hướng dẫn chạy

### 1. Cấu hình Database
Cập nhật thông tin kết nối trong `src/main/resources/application.properties`:

```properties
spring.datasource.url=jdbc:sqlserver://YOUR_SERVER;instanceName=MSSQLSERVER01;databaseName=Graphql;encrypt=false;trustServerCertificate=true
spring.datasource.username=YOUR_USERNAME
spring.datasource.password=YOUR_PASSWORD
```

### 2. Chạy ứng dụng
```bash
# Clone project
git clone <repository-url>
cd SpringBoot_Graphql

# Chạy ứng dụng
mvn spring-boot:run
```

### 3. Truy cập ứng dụng
- **Trang chủ**: http://localhost:8080
- **GraphQL Playground**: http://localhost:8080/graphiql
- **GraphQL Endpoint**: http://localhost:8080/graphql

## 📊 Cấu trúc Database

### Bảng Users
- `id` (Primary Key)
- `fullname` (Tên đầy đủ)
- `email` (Email, unique)
- `password` (Mật khẩu)
- `phone` (Số điện thoại)

### Bảng Categories
- `id` (Primary Key)
- `name` (Tên danh mục)
- `images` (Đường dẫn hình ảnh)

### Bảng Products
- `id` (Primary Key)
- `title` (Tên sản phẩm)
- `quantity` (Số lượng)
- `description` (Mô tả)
- `price` (Giá)
- `image` (Đường dẫn hình ảnh)
- `user_id` (Foreign Key -> Users)
- `category_id` (Foreign Key -> Categories)

### Bảng User_Categories (N-N)
- `user_id` (Foreign Key -> Users)
- `category_id` (Foreign Key -> Categories)

## 🔧 GraphQL Queries

### Queries chính
```graphql
# Lấy tất cả sản phẩm sắp xếp theo giá tăng dần
query {
  productsSortedByPriceAsc {
    id
    title
    price
    category { name }
    user { fullname }
  }
}

# Lấy sản phẩm theo danh mục
query {
  productsByCategory(categoryId: "1") {
    id
    title
    price
    category { name }
  }
}

# Lấy tất cả users
query {
  users {
    id
    fullname
    email
    phone
  }
}

# Lấy tất cả categories
query {
  categories {
    id
    name
    images
  }
}
```

### Mutations chính
```graphql
# Tạo sản phẩm mới
mutation {
  createProduct(input: {
    title: "iPhone 15"
    quantity: 10
    price: 25000000
    description: "Latest iPhone"
    userId: "1"
    categoryId: "1"
  }) {
    id
    title
  }
}

# Cập nhật sản phẩm
mutation {
  updateProduct(id: "1", input: {
    title: "iPhone 15 Pro"
    quantity: 5
    price: 30000000
    description: "Updated description"
    userId: "1"
    categoryId: "1"
  }) {
    id
    title
  }
}

# Xóa sản phẩm
mutation {
  deleteProduct(id: "1")
}
```

## 🎨 Giao diện

### Trang chủ
- Dashboard với thống kê tổng quan
- Navigation đến các trang quản lý
- Thông tin về GraphQL endpoints

### Trang Products
- Form thêm/sửa sản phẩm với validation
- Bộ lọc theo danh mục
- Hiển thị sản phẩm theo giá tăng dần
- Format giá tiền VND
- Responsive design

### Trang Users
- CRUD người dùng
- Form validation
- Giao diện thân thiện

### Trang Categories
- CRUD danh mục
- Quản lý hình ảnh
- Interface đơn giản

## 🔍 Tính năng nổi bật

1. **Sắp xếp sản phẩm theo giá**: Tự động sắp xếp từ thấp đến cao
2. **Lọc theo danh mục**: Dễ dàng tìm kiếm sản phẩm theo category
3. **Upload hình ảnh**: Upload file hình ảnh cho sản phẩm và danh mục
4. **Preview hình ảnh**: Xem trước hình ảnh trước khi lưu
5. **Format giá tiền**: Hiển thị giá theo định dạng VND
6. **Responsive design**: Tương thích mọi thiết bị
7. **Real-time updates**: Cập nhật dữ liệu ngay lập tức với AJAX
8. **GraphQL Playground**: Test API trực tiếp trên browser

## 📁 File Upload API

### Upload File
```http
POST /api/upload
Content-Type: multipart/form-data

file: [image file]
```

**Response:**
```json
{
  "success": true,
  "message": "Upload thành công",
  "filename": "uuid-filename.jpg",
  "originalName": "original.jpg",
  "size": 12345,
  "url": "/uploads/uuid-filename.jpg"
}
```

### Delete File
```http
DELETE /api/upload/{filename}
```

**Response:**
```json
{
  "success": true,
  "message": "Xóa file thành công"
}
```

## 📝 Ghi chú

- Dữ liệu mẫu được tạo tự động khi khởi động ứng dụng
- GraphQL schema được định nghĩa trong `src/main/resources/graphql/schema.graphqls`
- Tất cả API calls sử dụng AJAX với fetch API
- Giao diện sử dụng Bootstrap 5 và Font Awesome icons

## 🤝 Đóng góp

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Tạo Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
