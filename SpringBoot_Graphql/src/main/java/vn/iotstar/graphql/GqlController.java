package vn.iotstar.graphql;

import org.springframework.graphql.data.method.annotation.*;
import org.springframework.stereotype.Controller;
import lombok.RequiredArgsConstructor;
import vn.iotstar.model.*;
import vn.iotstar.repo.*;

import java.math.BigDecimal;
import java.util.*;

@Controller
@RequiredArgsConstructor
public class GqlController {

  private final ProductRepo productRepo;
  private final UserRepo userRepo;
  private final CategoryRepo categoryRepo;

  /* ===== Queries ===== */
  @QueryMapping
  public List<Product> productsSortedByPriceAsc() {
    return productRepo.findAllByOrderByPriceAsc();
  }

  @QueryMapping
  public List<Product> productsByCategory(@Argument Long categoryId) {
    return productRepo.findByCategory_Id(categoryId);
  }

  @QueryMapping public List<User> users() { return userRepo.findAll(); }
  @QueryMapping public User user(@Argument Long id) { return userRepo.findById(id).orElse(null); }
  @QueryMapping public List<Category> categories() { return categoryRepo.findAll(); }
  @QueryMapping public Category category(@Argument Long id) { return categoryRepo.findById(id).orElse(null); }
  @QueryMapping public List<Product> products() { return productRepo.findAll(); }
  @QueryMapping public Product product(@Argument Long id) { return productRepo.findById(id).orElse(null); }

  /* ===== Mutations: attach/detach N-N User-Category ===== */
  @MutationMapping
  public Category attachUserToCategory(@Argument Long userId, @Argument Long categoryId) {
    User u = userRepo.findById(userId).orElseThrow();
    Category c = categoryRepo.findById(categoryId).orElseThrow();
    u.getCategories().add(c);
    userRepo.save(u);
    return c;
  }

  @MutationMapping
  public Category detachUserFromCategory(@Argument Long userId, @Argument Long categoryId) {
    User u = userRepo.findById(userId).orElseThrow();
    Category c = categoryRepo.findById(categoryId).orElseThrow();
    u.getCategories().remove(c);
    userRepo.save(u);
    return c;
  }

  /* ===== CRUD: User ===== */
  record UserInput(String fullname, String email, String password, String phone) {}
  @MutationMapping
  public User createUser(@Argument UserInput input) {
    User u = new User();
    u.setFullname(input.fullname());
    u.setEmail(input.email());
    u.setPassword(input.password());
    u.setPhone(input.phone());
    return userRepo.save(u);
  }
  @MutationMapping
  public User updateUser(@Argument Long id, @Argument UserInput input) {
    User u = userRepo.findById(id).orElseThrow();
    u.setFullname(input.fullname());
    u.setEmail(input.email());
    u.setPassword(input.password());
    u.setPhone(input.phone());
    return userRepo.save(u);
  }
  @MutationMapping
  public Boolean deleteUser(@Argument Long id) {
    userRepo.deleteById(id); return true;
  }

  /* ===== CRUD: Category ===== */
  record CategoryInput(String name, String images) {}
  @MutationMapping
  public Category createCategory(@Argument CategoryInput input) {
    Category c = new Category();
    c.setName(input.name());
    c.setImages(input.images());
    return categoryRepo.save(c);
  }
  @MutationMapping
  public Category updateCategory(@Argument Long id, @Argument CategoryInput input) {
    Category c = categoryRepo.findById(id).orElseThrow();
    c.setName(input.name());
    c.setImages(input.images());
    return categoryRepo.save(c);
  }
  @MutationMapping
  public Boolean deleteCategory(@Argument Long id) {
    categoryRepo.deleteById(id); return true;
  }

  /* ===== CRUD: Product ===== */
  record ProductInput(String title, Integer quantity, String description, Double price,
                      Long userId, Long categoryId) {}
  @MutationMapping
  public Product createProduct(@Argument ProductInput input) {
    User u = userRepo.findById(input.userId()).orElseThrow();
    Category c = categoryRepo.findById(input.categoryId()).orElseThrow();
    Product p = new Product();
    p.setTitle(input.title());
    p.setQuantity(input.quantity());
    p.setDescription(input.description());
    p.setPrice(BigDecimal.valueOf(input.price()));
    p.setUser(u);
    p.setCategory(c);
    return productRepo.save(p);
  }
  @MutationMapping
  public Product updateProduct(@Argument Long id, @Argument ProductInput input) {
    Product p = productRepo.findById(id).orElseThrow();
    p.setTitle(input.title());
    p.setQuantity(input.quantity());
    p.setDescription(input.description());
    p.setPrice(BigDecimal.valueOf(input.price()));
    p.setUser(userRepo.findById(input.userId()).orElseThrow());
    p.setCategory(categoryRepo.findById(input.categoryId()).orElseThrow());
    return productRepo.save(p);
  }
  @MutationMapping
  public Boolean deleteProduct(@Argument Long id) {
    productRepo.deleteById(id); return true;
  }
}

