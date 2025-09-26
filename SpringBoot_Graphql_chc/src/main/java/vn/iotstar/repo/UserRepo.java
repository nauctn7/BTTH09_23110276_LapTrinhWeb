package vn.iotstar.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import vn.iotstar.model.User;

public interface UserRepo extends JpaRepository<User, Long> {}