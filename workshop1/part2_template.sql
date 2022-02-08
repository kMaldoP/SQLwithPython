-- create the database
DROP DATABASE IF EXISTS week1_workshop;
CREATE DATABASE week1_workshop;
-- connect via psql
\c week1_workshop

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- CREATE tables
---

CREATE TABLE us_state (
    state_id SERIAL PRIMARY KEY,
    state_name TEXT,
    state_abbr VARCHAR(2) NOT NULL
);

CREATE TABLE region (
    region_id SERIAL PRIMARY KEY,
    regions_description TEXT NOT NULL,
);

CREATE TABLE territory (
territory_id SERIAL PRIMARY KEY,
territory_description TEXT NOT NULL,
region_id INT,
employee_id INT,
CONSTRAINT fk_territory_region
FOREIGN Key (region_id)
REFERENCES region,
CONSTRAINT fk_territory_employee
REFERENCES employee
);

CREATE TABLE employee_territory (
    employee_id INT,
    territory_id INT,
    PRIMARY KEY(employee_id, territory_id),
    CONSTRAINT fk_employee_territory
    FOREIGN key(employee_id)
    REFERENCES employee,
    CONSTRAINT fk_employee_territory
    FOREIGN KEY territory_id)
    REFERENCES territory
);

CREATE TABLE supplier (
    supplier_id SERIAL PRIMARY KEY,
    supplier_name TEXT NOT NULL
);

CREATE TABLE product (
    product_id SERIAL,
    product_name TEXT NOT NULL,
    discontinued INT NOT NULL,
    supplier_id INT,
    category_id INT,
    PRIMARY KEY(product_id)
);

CREATE TABLE order_product (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    discount NUMERIC NOT NULL,
    PRIMARY key( order_id, product_id)
    CONSTRAINT fk_order_product_order
    FOREIGN key (order_id)
    REFERENCES order,
    CONSTRAINT fk_order_product_product
    FOREIGN key(product_id)
    REFERENCES product

);
CREATE TABLE product(
    product_id SERIAL,
    is_discontinued INT(1) NOT NULL,
    category_id INT,
    supplier_id INT,
    order_id INT,
    CONSTRAINT fk_product_category
    FOREIGN key( category_id
    REFERENCES category,
    CONSTRAINT fk_product_supplier
    FOREIGN key (supplier_id)
    REFERENCES supplier,
    CONSTRAINT fk_order_product_order
    FOREIGN key (order_id)
    REFERENCES order

);

CREATE TABLE categories (
    category_id SERIAL,
    category_name TEXT NOT NULL,
    category_description TEXT,
    picture TEXT,
    PRIMARY KEY (category_id)
);

CREATE TABLE shipper (
    shipper_id SERIAL PRIMARY key,
    shipper_name TEXT not NULL,
    shipper_phone TEXT
);

CREATE TABLE employee(
    employee_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    manager_id INT,
    territory_id INT,
    CONSTRAINT fk_employee_territory
    FOREIGN key(territory_id)
    REFERENCES territory
);

CREATE TABLE order (
    order_id SERIAL PRIMARY KEY,
    order_date date,
    shipper_id INT,
    employee_id INT,
    product_id INT,
    CONSTRAINT fk_order_shipper
    FOREIGN key( shipper_id)
    REFERENCES shipper,
    CONSTRAINT fk_order_employee
    FOREIGN key (employee_id)
    REFERENCES employee,
    CONSTRAINT fk_order-product_id
    REFERENCES employee
);

CREATE TABLE customer (
    customer_id SERIAL,
    customer_name TEXT NOT NULL,
    order_id INT,
    CONSTRAINT fk_customer_order
    FOREIGN key(order_id)
    REFERENCES order

);
-- TODO create more tables here...


---
--- Add foreign key constraints
---

ALTER TABLE products
ADD CONSTRAINT fk_products_categories 
FOREIGN KEY (category_id) 
REFERENCES categories;

-- TODO create more constraints here...

