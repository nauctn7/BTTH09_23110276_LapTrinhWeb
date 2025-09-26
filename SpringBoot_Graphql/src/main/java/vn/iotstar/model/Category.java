package vn.iotstar.model;

import jakarta.persistence.*;
import java.util.*;
import lombok.*;


@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name="categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;
    private String images;

    @ManyToMany(mappedBy = "categories")
    private Set<User> users = new HashSet<>();

    @OneToMany(mappedBy = "category")
    private List<Product> products = new ArrayList<>();
}

