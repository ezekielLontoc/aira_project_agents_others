package com.aira.accelerator.agents.security;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class ApiSecurityWebConfig implements WebMvcConfigurer {

    private final ApiKeySecurityInterceptor apiKeySecurityInterceptor;

    public ApiSecurityWebConfig(ApiKeySecurityInterceptor apiKeySecurityInterceptor) {
        this.apiKeySecurityInterceptor = apiKeySecurityInterceptor;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(apiKeySecurityInterceptor)
                .addPathPatterns("/api/v1/**");
    }

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/v1/**")
                .allowedOrigins("http://localhost:9090")
                .allowedMethods("GET", "OPTIONS")
                .allowedHeaders("X-AIRA-API-Key", "Content-Type", "Authorization")
                .exposedHeaders("Content-Type")
                .maxAge(3600);
    }
}