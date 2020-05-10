package com.docker.demo.model;

import org.hibernate.validator.constraints.NotEmpty;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

import java.io.Serializable;
import javax.persistence.*;

@Entity
@Table(name="products", uniqueConstraints = { @UniqueConstraint(columnNames = "productid")})
@JsonInclude(Include.NON_NULL)
public class Product implements Serializable {

    private static final long serialVersionUID = 3222530297013481114L;
     
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long productId;
    
    @NotEmpty
    @Column(name = "price", nullable = false)
    private double price;
    
    @Column(name = "description", length=10485760, nullable = false)
    private String description;
          
    public Product() {
        
    }
    
    public Product(Long productId, String description, double price) {
        this.productId = productId;
        this.price = price;
        this.description = description;
    }

    public long getProductId() {
        return productId;
    }
    
    public void setProductId(long productId) {
        this.productId = productId;
    }
 
    public double getPrice() {
        return price;
    }
 
    public void setPrice(double price) {
        this.price = price;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    @Override
    public String toString() {
        return "Product [productId=" + productId +
                         ", price=" + price +
                         ", description=" + description +
                         "]";
    }
    
}
