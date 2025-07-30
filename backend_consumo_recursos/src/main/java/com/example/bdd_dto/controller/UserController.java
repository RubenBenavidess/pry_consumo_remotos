package com.example.bdd_dto.controller;

import org.springframework.web.bind.annotation.RestController;

import com.example.bdd_dto.dto.UserDTO;
import com.example.bdd_dto.model.User;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import com.example.bdd_dto.service.UserService;

@RestController
@RequestMapping("/api/auth")
public class UserController {
    
    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody UserDTO userDTO) {
        try{
            UserDTO savedUser = userService.register(userDTO);
            return ResponseEntity.ok(savedUser);
        }catch(RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());

        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody UserDTO userDTO) {
        try {
            String token = userService.login(userDTO);
            return ResponseEntity.ok(token);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(e.getMessage());    
    
        }
    }
}
