package com.aira.accelerator.governance.security;

import org.springframework.context.annotation.Configuration;
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
}