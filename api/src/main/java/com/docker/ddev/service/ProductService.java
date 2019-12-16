package com.docker.ddev.service;

import java.util.List;
import com.docker.ddev.model.Product;

public interface ProductService {
	List<Product> findAllProducts();
	Product findById(Long productId);
}