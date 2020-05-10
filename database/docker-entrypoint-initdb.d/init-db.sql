-- create table for products

CREATE TABLE products
(
  productid serial UNIQUE PRIMARY KEY,
  description character varying(10485760) NOT NULL,
  price real NOT NULL
);

ALTER TABLE products
  OWNER TO postgres;
ALTER ROLE postgres CONNECTION LIMIT -1;

-- add image data
INSERT INTO products (description, price) VALUES('resistor', 0.01);
INSERT INTO products (description, price) VALUES('capacitor', 0.02);
INSERT INTO products (description, price) VALUES('diode', 0.03);
INSERT INTO products (description, price) VALUES('transistor', 0.04);
INSERT INTO products (description, price) VALUES('breadboard', 1.00);
