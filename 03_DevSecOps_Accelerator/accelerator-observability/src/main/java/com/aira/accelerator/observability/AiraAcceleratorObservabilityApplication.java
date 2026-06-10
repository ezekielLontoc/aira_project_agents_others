package com.aira.accelerator.observability;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class AiraAcceleratorObservabilityApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(AiraAcceleratorObservabilityApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(AiraAcceleratorObservabilityApplication.class);
    }
}