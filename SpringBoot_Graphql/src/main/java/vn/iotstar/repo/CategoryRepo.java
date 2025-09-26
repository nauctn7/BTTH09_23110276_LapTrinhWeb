package vn.iotstar.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.iotstar.model.Category;

public interface CategoryRepo extends JpaRepository<Category, Long> {}
