package com.aira.accelerator.agents;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class AiraAcceleratorAgentsApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(AiraAcceleratorAgentsApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(AiraAcceleratorAgentsApplication.class);
    }
}