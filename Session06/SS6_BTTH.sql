-- Câu 1: Liệt kê danh sách các đơn hàng kèm theo tên khách hàng đã đặt đơn
SELECT 
    o.order_id,
    o.order_date,
    o.status,
    c.customer_name,
    c.email,
    c.city
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;


-- Câu 2: Cho biết mỗi đơn hàng gồm những sản phẩm nào, kèm theo số lượng của từng sản phẩm
SELECT 
    oi.order_id,
    p.product_name,
    oi.quantity,
    oi.unit_price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id;


-- Câu 3: Tính tổng số đơn hàng hiện có trong hệ thống
SELECT COUNT(*) AS total_orders
FROM orders;


-- Câu 4: Tính tổng doanh thu của toàn bộ hệ thống
SELECT SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi;


-- Câu 5: Cho biết tổng tiền của mỗi đơn hàng
SELECT 
    oi.order_id,
    SUM(oi.quantity * oi.unit_price) AS total_amount
FROM order_items oi
GROUP BY oi.order_id
ORDER BY oi.order_id;


-- Câu 6: Cho biết tổng số tiền mà mỗi khách hàng đã chi tiêu
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY total_spent DESC;


-- Câu 7: Tính doanh thu theo từng sản phẩm
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY revenue DESC;


-- Câu 8: Liệt kê các khách hàng có tổng chi tiêu lớn hơn 5.000.000
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING SUM(oi.quantity * oi.unit_price) > 5000000
ORDER BY total_spent DESC;


-- Câu 9: Liệt kê các sản phẩm có tổng số lượng bán ra lớn hơn 100
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
HAVING SUM(oi.quantity) > 100
ORDER BY total_quantity_sold DESC;


-- Câu 10: Cho biết các thành phố có số lượng đơn hàng lớn hơn 5
SELECT 
    c.city,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC;