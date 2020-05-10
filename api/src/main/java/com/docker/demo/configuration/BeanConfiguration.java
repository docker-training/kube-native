package com.docker.demo.configuration;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;

import com.docker.demo.service.ProductService;
import com.docker.demo.service.ProductServiceImpl;
import com.mchange.v2.c3p0.ComboPooledDataSource;

public class BeanConfiguration {

	@Bean
	public ProductService productService() {
		return new ProductServiceImpl();
	}

	// Implement C3P0 connection pooling
	@Bean
	@ConfigurationProperties("demo.datasource")
	public ComboPooledDataSource dataSource() {
	    return new ComboPooledDataSource();
	}
}
