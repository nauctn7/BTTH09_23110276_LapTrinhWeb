package vn.iotstar.repo;
import org.springframework.data.jpa.repository.JpaRepository;

import vn.iotstar.model.Product;

import java.util.List;

public interface ProductRepo extends JpaRepository<Product, Long> {
  List<Product> findAllByOrderByPriceAsc();
  List<Product> findByCategory_Id(Long categoryId);
}