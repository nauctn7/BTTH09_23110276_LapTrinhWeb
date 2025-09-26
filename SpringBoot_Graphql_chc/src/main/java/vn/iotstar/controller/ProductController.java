package vn.iotstar.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.model.Product;
import vn.iotstar.model.User;
import vn.iotstar.model.Category;
import vn.iotstar.repo.ProductRepo;
import vn.iotstar.repo.UserRepo;
import vn.iotstar.repo.CategoryRepo;

import java.math.BigDecimal;
import java.util.List;

@RestController
@RequestMapping("/api/products")
@RequiredArgsConstructor
public class ProductController {
    private final ProductRepo productRepo;
    private final UserRepo userRepo;
    private final CategoryRepo categoryRepo;

    @GetMapping
    public List<Product> getAll() {
        return productRepo.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Product> getById(@PathVariable Long id) {
        return productRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<Product> create(@RequestBody Product p) {
        // Đảm bảo user và category tồn tại
        User u = userRepo.findById(p.getUser().getId()).orElse(null);
        Category c = categoryRepo.findById(p.getCategory().getId()).orElse(null);
        if (u == null || c == null) return ResponseEntity.badRequest().build();
        p.setUser(u);
        p.setCategory(c);
        return ResponseEntity.ok(productRepo.save(p));
    }

    @PutMapping("/{id}")
    public ResponseEntity<Product> update(@PathVariable Long id, @RequestBody Product p) {
        return productRepo.findById(id)
                .map(prod -> {
                    prod.setTitle(p.getTitle());
                    prod.setDescription(p.getDescription());
                    prod.setQuantity(p.getQuantity());
                    prod.setPrice(p.getPrice() != null ? p.getPrice() : BigDecimal.ZERO);
                    // Cập nhật user và category nếu có
                    if (p.getUser() != null && p.getUser().getId() != null) {
                        User u = userRepo.findById(p.getUser().getId()).orElse(null);
                        if (u != null) prod.setUser(u);
                    }
                    if (p.getCategory() != null && p.getCategory().getId() != null) {
                        Category c = categoryRepo.findById(p.getCategory().getId()).orElse(null);
                        if (c != null) prod.setCategory(c);
                    }
                    return ResponseEntity.ok(productRepo.save(prod));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!productRepo.existsById(id)) return ResponseEntity.notFound().build();
        productRepo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
