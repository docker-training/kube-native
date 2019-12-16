package com.docker.ddev.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.docker.ddev.model.Product;
import com.docker.ddev.repositories.ProductRepository;

@Service("productService")
@Transactional
public class ProductServiceImpl implements ProductService {
	@Autowired
	private ProductRepository productRepository;

	public List<Product> findAllProducts() {
		return productRepository.findAll();
	}

	public Product findById(Long productId) {
		return productRepository.findOne(productId);
	}
}