package com.aira.accelerator.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class AiraAcceleratorApiApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(AiraAcceleratorApiApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(AiraAcceleratorApiApplication.class);
    }
}