package com.docker.ddev.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.docker.ddev.model.Product;

@Repository
@Transactional
public interface ProductRepository extends JpaRepository<Product, Long> {
}