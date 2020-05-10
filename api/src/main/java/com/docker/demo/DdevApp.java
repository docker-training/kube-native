package com.docker.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

import com.docker.demo.configuration.JpaConfiguration;


@Import(JpaConfiguration.class)
@SpringBootApplication(scanBasePackages={"com.docker.demo"})
@EntityScan("com.docker.demo.model")
@EnableJpaRepositories("com.docker.demo.repository")
public class DemoApp {
	public static void main(String[] args) {
		SpringApplication.run(DemoApp.class, args);
	}
}
