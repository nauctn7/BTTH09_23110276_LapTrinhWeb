package vn.iotstar.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebController {

    @GetMapping("/")
    public String home() {
        return "index";  // maps to /WEB-INF/views/index.jsp
    }

    @GetMapping("/products")
    public String products() {
        return "products";  // maps to /WEB-INF/views/products.jsp
    }

    @GetMapping("/users")
    public String users() {
        return "users";  // maps to /WEB-INF/views/users.jsp
    }

    @GetMapping("/categories")
    public String categories() {
        return "categories";  // maps to /WEB-INF/views/categories.jsp
    }
}
