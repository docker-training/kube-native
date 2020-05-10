package com.docker.demo.service;

import java.util.List;
import com.docker.demo.model.Product;

public interface ProductService {
	List<Product> findAllProducts();
	Product findById(Long productId);
}
