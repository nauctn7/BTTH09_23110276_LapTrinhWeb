# Hướng dẫn Debug

## 🔍 Các bước kiểm tra lỗi

### 1. Kiểm tra Console Browser
1. Mở Developer Tools (F12)
2. Vào tab Console
3. Thử upload file và xem log
4. Kiểm tra các lỗi JavaScript

### 2. Kiểm tra Network Tab
1. Vào tab Network trong Developer Tools
2. Thử upload file
3. Kiểm tra request `/api/upload`
4. Xem response status và content

### 3. Kiểm tra GraphQL
1. Vào tab Network
2. Thử lưu sản phẩm
3. Kiểm tra request `/graphql`
4. Xem response có lỗi gì không

### 4. Kiểm tra Server Logs
1. Chạy ứng dụng với: `mvn spring-boot:run`
2. Xem console output
3. Kiểm tra lỗi Java

## 🛠️ Các lỗi thường gặp

### Lỗi Upload File
- **403 Forbidden**: Kiểm tra quyền ghi thư mục `uploads/`
- **404 Not Found**: Kiểm tra endpoint `/api/upload`
- **500 Internal Server Error**: Kiểm tra server logs

### Lỗi GraphQL
- **User not found**: Kiểm tra có user với id=1 không
- **Category not found**: Kiểm tra có category với id=1 không
- **Validation error**: Kiểm tra dữ liệu input

### Lỗi Static Resources
- **404 cho hình ảnh**: Kiểm tra WebConfig.java
- **CORS error**: Kiểm tra CrossOrigin annotation

## 🔧 Cách sửa lỗi

### 1. Tạo thư mục uploads
```bash
mkdir uploads
chmod 755 uploads
```

### 2. Kiểm tra dữ liệu mẫu
- Đảm bảo có ít nhất 1 user và 1 category
- Kiểm tra data.sql

### 3. Kiểm tra cấu hình
- application.properties
- WebConfig.java
- FileUploadController.java

## 📝 Test Cases

### Test 1: Upload File
1. Chọn file hình ảnh
2. Nhấn upload
3. Kiểm tra console log
4. Kiểm tra file được tạo trong `uploads/`

### Test 2: Create Product
1. Điền form sản phẩm
2. Chọn user và category
3. Nhấn lưu
4. Kiểm tra console log
5. Kiểm tra database

### Test 3: Display Images
1. Tạo sản phẩm với hình ảnh
2. Kiểm tra danh sách hiển thị
3. Kiểm tra URL hình ảnh
4. Kiểm tra static resources

## 🚨 Troubleshooting

### Nếu upload không hoạt động:
1. Kiểm tra quyền thư mục
2. Kiểm tra cấu hình multipart
3. Kiểm tra FileUploadController

### Nếu GraphQL lỗi:
1. Kiểm tra dữ liệu mẫu
2. Kiểm tra GqlController
3. Kiểm tra schema.graphqls

### Nếu hình ảnh không hiển thị:
1. Kiểm tra WebConfig
2. Kiểm tra đường dẫn file
3. Kiểm tra static resources
