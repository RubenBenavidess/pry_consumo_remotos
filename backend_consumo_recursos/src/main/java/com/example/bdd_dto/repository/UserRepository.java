package com.example.bdd_dto.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import com.example.bdd_dto.model.User;

public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);
}
