package vn.iotstar.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = "*")
public class FileUploadController {

    /** Thư mục lưu file (cùng cấp với thư mục chạy ứng dụng) */
    private static final String UPLOAD_DIR = "uploads";
    /** Đường dẫn tuyệt đối tới thư mục uploads */
    private final Path uploadPath = Paths.get(UPLOAD_DIR).toAbsolutePath();

    /** Upload file ảnh */
    @PostMapping("/upload")
    public ResponseEntity<Map<String, Object>> uploadFile(@RequestParam("file") MultipartFile file) {
        Map<String, Object> res = new HashMap<>();
        try {
            // Tạo thư mục nếu chưa tồn tại
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            // Kiểm tra file
            if (file.isEmpty()) {
                return error(res, "File không được để trống", 400);
            }

            // Kiểm tra loại file
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return error(res, "Chỉ cho phép upload file hình ảnh", 400);
            }

            // Lấy tên gốc và phần mở rộng
            String originalName = file.getOriginalFilename();
            String ext = "";
            if (originalName != null && originalName.contains(".")) {
                ext = originalName.substring(originalName.lastIndexOf("."));
            }

            // Tạo tên file duy nhất
            String uniqueName = UUID.randomUUID().toString() + ext;

            // Lưu file
            Path target = uploadPath.resolve(uniqueName);
            Files.copy(file.getInputStream(), target, StandardCopyOption.REPLACE_EXISTING);

            // Trả kết quả
            res.put("success", true);
            res.put("message", "Upload thành công");
            res.put("filename", uniqueName);
            res.put("originalName", originalName);
            res.put("size", file.getSize());
            res.put("url", "/uploads/" + uniqueName); // đường dẫn public (map qua static)

            return ResponseEntity.ok(res);

        } catch (IOException e) {
            return error(res, "Lỗi khi upload file: " + e.getMessage(), 500);
        } catch (Exception e) {
            return error(res, "Lỗi không xác định: " + e.getMessage(), 500);
        }
    }

    /** Xóa file theo tên */
    @DeleteMapping("/upload/{filename}")
    public ResponseEntity<Map<String, Object>> deleteFile(@PathVariable String filename) {
        Map<String, Object> res = new HashMap<>();
        try {
            Path filePath = uploadPath.resolve(filename);

            if (Files.exists(filePath)) {
                Files.delete(filePath);
                res.put("success", true);
                res.put("message", "Xóa file thành công");
            } else {
                return error(res, "File không tồn tại", 404);
            }

            return ResponseEntity.ok(res);

        } catch (IOException e) {
            return error(res, "Lỗi khi xóa file: " + e.getMessage(), 500);
        }
    }

    /** Hàm tiện ích trả lỗi */
    private ResponseEntity<Map<String, Object>> error(Map<String, Object> res, String msg, int code) {
        res.put("success", false);
        res.put("message", msg);
        return ResponseEntity.status(code).body(res);
    }
}
