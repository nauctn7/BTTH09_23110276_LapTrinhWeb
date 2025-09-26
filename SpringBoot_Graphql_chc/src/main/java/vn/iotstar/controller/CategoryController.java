package vn.iotstar.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import vn.iotstar.model.Category;
import vn.iotstar.repo.CategoryRepo;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
@RequiredArgsConstructor
public class CategoryController {
    private final CategoryRepo categoryRepo;

    @GetMapping
    public List<Category> getAll() {
        return categoryRepo.findAll();
    }

    @GetMapping("/{id}")
    public ResponseEntity<Category> getById(@PathVariable Long id) {
        return categoryRepo.findById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public Category create(@RequestBody Category c) {
        return categoryRepo.save(c);
    }

    @PutMapping("/{id}")
    public ResponseEntity<Category> update(@PathVariable Long id, @RequestBody Category c) {
        return categoryRepo.findById(id)
                .map(cat -> {
                    cat.setName(c.getName());
                    cat.setImages(c.getImages());
                    return ResponseEntity.ok(categoryRepo.save(cat));
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        if (!categoryRepo.existsById(id)) return ResponseEntity.notFound().build();
        categoryRepo.deleteById(id);
        return ResponseEntity.noContent().build();
    }
}
