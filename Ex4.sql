-- =========================
-- Tạo Database
-- =========================
CREATE DATABASE "IOC-04-session5";

-- Kết nối vào database
\c IOC-04-session5

-- =========================
-- Tạo Schema
-- =========================
CREATE SCHEMA schema4;

-- =========================
-- Tạo bảng customers
-- =========================
CREATE TABLE schema4.customers (
                                   customer_id SERIAL PRIMARY KEY,
                                   customer_name VARCHAR(100),
                                   city VARCHAR(50)
);

-- =========================
-- Tạo bảng orders
-- =========================
CREATE TABLE schema4.orders (
                                order_id SERIAL PRIMARY KEY,
                                customer_id INT REFERENCES schema4.customers(customer_id),
                                order_date DATE,
                                total_amount NUMERIC(10,2)
);

-- =========================
-- Tạo bảng order_items
-- =========================
CREATE TABLE schema4.order_items (
                                     item_id SERIAL PRIMARY KEY,
                                     order_id INT REFERENCES schema4.orders(order_id),
                                     product_name VARCHAR(100),
                                     quantity INT,
                                     price NUMERIC(10,2)
);

SELECT o.order_id, c.customer_name customer_name, o.order_date order_date, o.total_amount total_amount FROM schema4.customers c
INNER JOIN schema4.orders o on c.customer_id = o.customer_id;

SELECT
    SUM(total_amount) AS total_revenue,
    AVG(total_amount) AS average_order_value,
    MAX(total_amount) AS largest_order,
    MIN(total_amount) AS smallest_order,
    COUNT(order_id) AS total_orders
FROM schema4.orders;

SELECT
    c.city,
    SUM(o.total_amount) AS total_revenue
FROM schema4.customers c
         JOIN schema4.orders o
              ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING SUM(o.total_amount) > 10000;

SELECT
    c.customer_name,
    o.order_date,
    oi.product_name,
    oi.quantity,
    oi.price
FROM schema4.customers c
         JOIN schema4.orders o
              ON c.customer_id = o.customer_id
         JOIN schema4.order_items oi
              ON o.order_id = oi.order_id;

SELECT
    c.customer_name,
    SUM(o.total_amount) AS total_revenue
FROM schema4.customers c
         JOIN schema4.orders o
              ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(customer_revenue)
    FROM (
             SELECT SUM(total_amount) AS customer_revenue
             FROM schema4.orders
             GROUP BY customer_id
         ) t
);