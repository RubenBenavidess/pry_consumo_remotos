package com.example.bdd_dto.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.example.bdd_dto.config.JwtUtil;
import com.example.bdd_dto.dto.UserDTO;
import com.example.bdd_dto.model.User;
import com.example.bdd_dto.repository.UserRepository;

@Service
public class UserService {

    private UserRepository userRepository;
    private PasswordEncoder passwordEncoder;

    @Autowired
    AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtil jwtUtil;

    public UserService(UserRepository userRepository,
    PasswordEncoder passwordEncoder,
    AuthenticationManager authenticationManager,
    JwtUtil jwtUtil) {
    this.userRepository = userRepository;
    this.passwordEncoder = passwordEncoder;
    this.authenticationManager = authenticationManager;
    this.jwtUtil = jwtUtil; 
}
    
    public UserDTO register(UserDTO userDTO) {
        
        User user = new User();
        user.setUsername(userDTO.getUsername());
        user.setPassword(passwordEncoder.encode(userDTO.getPassword()));

        User newUser = userRepository.save(user);

        if(newUser != null) {
            UserDTO savedUserDTO = new UserDTO();
            savedUserDTO.setId(newUser.getId());
            savedUserDTO.setUsername(newUser.getUsername());
            return savedUserDTO;
        } else {
            throw new RuntimeException("Error al registrar el usuario");
        }
    }    

    public String login(UserDTO userDTO) {
        Authentication authentication = authenticationManager.authenticate(
            new UsernamePasswordAuthenticationToken(
                userDTO.getUsername(), 
                userDTO.getPassword()
            )
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
        return jwtUtil.generateToken(userDTO.getUsername());
    }


}
