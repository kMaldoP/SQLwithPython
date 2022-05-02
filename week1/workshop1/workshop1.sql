-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'week1_workshop' AND pid <> pg_backend_pid();
-- (re)create the database
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

CREATE TABLE products (
    id SERIAL,
    name TEXT NOT NULL,
    discontinued BOOLEAN NOT NULL,
    supplier_id INT,
    category_id INT,
    PRIMARY KEY (id)
);


CREATE TABLE categories (
    id SERIAL,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    picture TEXT,
    PRIMARY KEY (id)
);

-- -- TODO create more tables here...


CREATE TABLE customers(
    id SERIAL,
    customer_id INT,
    name TEXT NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE employees(
    id SERIAL,
    employees_id INT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE orders(
    id SERIAL,
    order_date DATE,
    order_id INT,
    employee_id INT,
    customer_id INT,
    PRIMARY KEY(id)
);
CREATE TABLE orders_products(
    product_id INT,
    order_id INT,
    quantity INT,
    discount NUMERIC NOT NULL,
    PRIMARY KEY(product_id, order_id)
);
CREATE TABLE territories(
    id SERIAL,
    territory_description TEXT NOT NULL,
    territory_id INT NOT NULL,
    PRIMARY KEY(id)
);
CREATE TABLE employees_territories(
    employee_id INT NOT NULL,
    territory_id TEXT NOT NULL,
    PRIMARY KEY(employee_id, territory_id)
);
CREATE TABLE offices(
    id SERIAL,
    office_id INT NOT NULL,
    addres_line TEXT NOT NULL
);
CREATE TABLE us_states(
    id SERIAL,
    state_id INT,
    name TEXT NOT NULL,
    state_abbr CHARACTER(2)
);
-- ---
--- Add foreign key constraints
ALTER TABLE orders
ADD CONSTRAINT fk_orders_customers
FOREIGN KEY (employee_id)
REFERENCES employees(id);

ALTER TABLE orders
ADD CONSTRAINT fk_order_employees
FOREIGN KEY (employee_id)
REFERENCES employees(id);




-- PRODUCTS

ALTER TABLE products
ADD CONSTRAINT fk_products_categories 
FOREIGN KEY (category_idgit) 
REFERENCES categories (id);


-- TODO create more constraints here...
