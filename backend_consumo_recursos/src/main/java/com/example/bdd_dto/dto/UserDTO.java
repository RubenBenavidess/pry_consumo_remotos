package com.example.bdd_dto.dto;

public class UserDTO {
    private Long id;
    private String username;
    private String password;

    // Constructor
    public UserDTO() {}

    public UserDTO(String username, String password) {
        this.username = username;
        this.password = password;
    }

    // Getters y Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    
}
