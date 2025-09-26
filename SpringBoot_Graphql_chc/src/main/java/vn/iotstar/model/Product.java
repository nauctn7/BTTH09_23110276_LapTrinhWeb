package vn.iotstar.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import lombok.*;

@Entity @Table(name="products")
@Data @NoArgsConstructor @AllArgsConstructor
public class Product {
  @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String title;
  private Integer quantity;

  @Column(name = "description", length = 2000) // tránh dùng 'desc' vì từ khóa SQL
  private String description;

  private BigDecimal price;

  @ManyToOne @JoinColumn(name = "user_id")
  private User user;

  @ManyToOne @JoinColumn(name = "category_id")
  private Category category;

}
