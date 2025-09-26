package vn.iotstar.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import vn.iotstar.model.Product;
import vn.iotstar.repo.ProductRepo;
import vn.iotstar.service.ProductService;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class ProductServiceImpl implements ProductService {

    private final ProductRepo productRepo;

    @Override
    public List<Product> findAll() {
        return productRepo.findAll();
    }

    @Override
    public Optional<Product> findById(Long id) {
        return productRepo.findById(id);
    }

    @Override
    public Product save(Product product) {
        return productRepo.save(product);
    }

    @Override
    public void deleteById(Long id) {
        productRepo.deleteById(id);
    }
}
