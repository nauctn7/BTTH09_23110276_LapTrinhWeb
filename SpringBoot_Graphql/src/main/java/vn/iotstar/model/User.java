package vn.iotstar.model;

import jakarta.persistence.*;
import java.util.*;
import lombok.*;

@Entity @Table(name="users")
@Data @NoArgsConstructor @AllArgsConstructor
public class User {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String fullname;

  @Column(unique = true, nullable = false)
  private String email;

  private String password;
  private String phone;

  // N-N với Category
  @ManyToMany
  @JoinTable(name = "user_categories",
    joinColumns = @JoinColumn(name = "user_id"),
    inverseJoinColumns = @JoinColumn(name = "category_id"))
  private Set<Category> categories = new HashSet<>();

  // 1-N: 1 user có nhiều product
  @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
  private List<Product> products = new ArrayList<>();
}
