package com.aira.accelerator.evidence;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

@SpringBootApplication
public class AiraAcceleratorEvidenceApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(AiraAcceleratorEvidenceApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(AiraAcceleratorEvidenceApplication.class);
    }
}