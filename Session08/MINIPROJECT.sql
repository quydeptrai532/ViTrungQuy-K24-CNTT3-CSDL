-- =====================================
-- ONLINE SALES DATABASE – FULL SQL
-- =====================================

-- 1. TẠO DATABASE
DROP DATABASE IF EXISTS online_sales_db;
CREATE DATABASE online_sales_db;
USE online_sales_db;

-- 2. TẠO BẢNG CUSTOMERS
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL UNIQUE
);

-- 3. TẠO BẢNG CATEGORIES
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

-- 4. TẠO BẢNG PRODUCTS
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL,
    CONSTRAINT fk_products_categories
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
);

-- 5. TẠO BẢNG ORDERS
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Cancel') DEFAULT 'Pending',
    CONSTRAINT fk_orders_customers
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- 6. TẠO BẢNG ORDER_ITEMS
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),
    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);

-- 7. THÊM DỮ LIỆU MẪU
-- Customers
INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyen Van A', 'a@gmail.com', '0900000001'),
('Tran Thi B', 'b@gmail.com', '0900000002'),
('Le Van C', 'c@gmail.com', '0900000003');

-- Categories
INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Phụ kiện');

-- Products
INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 15', 25000000, 1),
('Samsung S24', 22000000, 1),
('MacBook Air M2', 28000000, 2),
('Chuột Logitech', 800000, 3),
('Tai nghe Sony', 1500000, 3);

-- Orders
INSERT INTO orders (customer_id, status) VALUES
(1, 'Completed'),
(1, 'Pending'),
(2, 'Completed'),
(3, 'Cancel');

-- Order Items
INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 4, 2),
(2, 2, 1),
(3, 3, 1),
(3, 5, 2);

-- =====================================
-- TRUY VẤN THỰC HÀNH
-- =====================================

-- Danh sách tất cả danh mục sản phẩm
SELECT * FROM categories;

-- Danh sách đơn hàng có trạng thái COMPLETED
SELECT * FROM orders
WHERE status = 'Completed';

-- Danh sách sản phẩm theo giá giảm dần
SELECT * FROM products
ORDER BY price DESC;

-- 5 sản phẩm có giá cao nhất, bỏ qua 2 sản phẩm đầu tiên
SELECT * FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 2;

-- Danh sách sản phẩm kèm tên danh mục
SELECT p.product_name, p.price, c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

-- Danh sách đơn hàng gồm: order_id, order_date, customer_name, status
SELECT o.order_id, o.order_date, c.customer_name, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

-- Tổng số lượng sản phẩm trong từng đơn hàng
SELECT o.order_id, SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- Thống kê số đơn hàng của mỗi khách hàng
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- Tổng số sản phẩm đã bán
SELECT SUM(quantity) AS total_products_sold
FROM order_items;

-- Giá sản phẩm cao nhất, thấp nhất, trung bình
SELECT MAX(price) AS max_price,
       MIN(price) AS min_price,
       AVG(price) AS avg_price
FROM products;

-- Khách hàng có số đơn hàng nhiều nhất
SELECT customer_name
FROM customers
WHERE customer_id = (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- Sản phẩm chưa từng được bán
SELECT product_name
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
);

-- Tổng tiền của từng đơn hàng
SELECT o.order_id,
       SUM(oi.quantity * p.price) AS total_amount
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY o.order_id;

-- Khách hàng mua từ 2 đơn trở lên
SELECT c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING COUNT(o.order_id) >= 2;

-- Sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT *
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);

-- Khách hàng đã từng đặt ít nhất một đơn hàng
SELECT *
FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM orders
);

-- Đơn hàng có tổng số lượng sản phẩm lớn nhất
SELECT order_id, SUM(quantity) AS total_quantity
FROM order_items
GROUP BY order_id
HAVING SUM(quantity) = (
    SELECT MAX(total_qty)
    FROM (
        SELECT SUM(quantity) AS total_qty
        FROM order_items
        GROUP BY order_id
    ) t
);

-- Tên khách hàng đã mua sản phẩm thuộc danh mục có giá trung bình cao nhất
SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category_id = (
    SELECT category_id
    FROM products
    GROUP BY category_id
    ORDER BY AVG(price) DESC
    LIMIT 1
);

-- Thống kê tổng số lượng sản phẩm đã mua của từng khách hàng (bảng tạm)
SELECT customer_id, SUM(total_quantity) AS total_products
FROM (
    SELECT o.customer_id, SUM(oi.quantity) AS total_quantity
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    GROUP BY o.order_id
) t
GROUP BY customer_id;

-- Sản phẩm có giá cao nhất (Subquery trả về 1 giá trị duy nhất)
SELECT *
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);
