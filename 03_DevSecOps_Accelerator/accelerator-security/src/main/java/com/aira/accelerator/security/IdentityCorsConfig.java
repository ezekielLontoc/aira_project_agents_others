package com.aira.accelerator.security;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class IdentityCorsConfig implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/v1/identity/**")
            .allowedOrigins(
                "http://192.168.179.193:9090",
                "http://localhost:9090",
                "http://127.0.0.1:9090"
            )
            .allowedMethods("GET", "POST", "OPTIONS")
            .allowedHeaders(
                "Authorization",
                "Content-Type",
                "X-AIRA-API-Key",
                "X-AIRA-Admin-Key"
            )
            .exposedHeaders(
                "Authorization",
                "Content-Type",
                "X-AIRA-API-Key",
                "X-AIRA-Admin-Key"
            )
            .maxAge(3600);
    }
}