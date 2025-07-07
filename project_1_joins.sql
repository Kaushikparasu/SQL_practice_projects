-- Create tables and insert data
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50)
);

INSERT INTO customers VALUES
(1, 'Alice', 'alice@email.com', 'USA'),
(2, 'Bob', 'bob@email.com', 'Canada'),
(3, 'Charlie', NULL, 'USA'),
(4, 'Diana', 'diana@email.com', 'UK'),
(5, 'Eve', 'eve@email.com', NULL),
(6, 'Frank', 'frank@email.com', 'India'),
(7, 'Grace', NULL, 'Canada'),
(8, 'Heidi', 'heidi@email.com', 'USA');

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2)
);

INSERT INTO orders VALUES
(101, 1, '2023-01-10', 250),
(102, 2, '2023-01-11', 400),
(103, 1, '2023-01-15', 150),
(104, 3, '2023-01-20', 200),
(105, 4, '2023-01-22', 100),
(106, NULL, '2023-01-25', 300),
(107, 6, '2023-01-30', NULL),
(108, 1, NULL, 175),
(109, 7, '2023-02-01', 500),
(110, 3, '2023-02-05', 250),
(111, 10, '2023-02-10', 300);

CREATE TABLE order_items (
    item_id INT PRIMARY KEY,
    order_id INT,
    product VARCHAR(50),
    quantity INT,
    unit_price DECIMAL(10, 2)
);

INSERT INTO order_items VALUES
(1, 101, 'Keyboard', 2, 50),
(2, 101, 'Mouse', 1, 150),
(3, 102, 'Monitor', 2, 200),
(4, 103, 'Mouse', 3, 50),
(5, 104, 'Keyboard', 1, 100),
(6, 105, 'Chair', 2, 50),
(7, 106, 'Laptop', 1, NULL),
(8, 107, 'Monitor', 2, 150),
(9, 107, 'Mouse', 2, 75),
(10, 109, 'Keyboard', 4, 40),
(11, 110, 'Desk', 1, 250),
(12, 110, 'Mouse', 2, 60),
(13, 111, 'Chair', NULL, 100);

CREATE TABLE support_tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT,
    issue VARCHAR(255),
    created_at DATE,
    status VARCHAR(20)
);

INSERT INTO support_tickets VALUES
(1, 1, 'Late delivery', '2023-01-12', 'Open'),
(2, 2, 'Damaged item', '2023-01-13', 'Resolved'),
(3, 4, 'Missing item', '2023-01-15', 'Open'),
(4, 3, 'No response', '2023-01-18', 'Open'),
(5, 5, 'Payment issue', '2023-01-21', NULL),
(6, 1, 'Wrong item', NULL, 'Open'),
(7, 10, 'Account locked', '2023-01-25', 'Resolved');

-- Explore data
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM support_tickets;

-- 1. List all customers along with their total number of orders.
SELECT c.customer_id, name, COUNT(order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, name;

-- 2. Show total spending for each customer calculated from order_items, not orders.
SELECT c.customer_id, name, COALESCE(SUM(quantity * unit_price), 0) AS total_spent
FROM customers c
LEFT JOIN orders o1 ON c.customer_id = o1.customer_id
LEFT JOIN order_items o2 ON o1.order_id = o2.order_id
GROUP BY c.customer_id, c.name;

-- 3. List customers who raised support tickets but never placed an order.
SELECT * FROM customers
WHERE customer_id IN (
    SELECT DISTINCT customer_id
    FROM support_tickets
    WHERE customer_id IN (
        SELECT c.customer_id
        FROM customers c
        LEFT JOIN orders o ON c.customer_id = o.customer_id
        WHERE order_id IS NULL
    )
);

-- 4. Find customers who placed more than one order and also have more than one support ticket.
SELECT * FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)
AND customer_id IN (
    SELECT customer_id
    FROM support_tickets
    GROUP BY customer_id
    HAVING COUNT(*) > 1
);

-- 5. Show all orders where the computed total from order_items differs from the total_amount in orders.
WITH order_items_single AS (
  SELECT order_id, COALESCE(SUM(quantity * unit_price), 0) AS total_price_item
  FROM order_items
  GROUP BY order_id
)
SELECT o.order_id, total_price_item, total_amount
FROM order_items_single os
RIGHT JOIN orders o ON os.order_id = o.order_id
WHERE COALESCE(total_price_item, 0) <> COALESCE(total_amount, 0);

-- 6. List all support tickets along with customer name and order count (if any).
WITH cust AS (
  SELECT c.customer_id, name, COUNT(order_id) AS cout
  FROM customers c
  LEFT JOIN orders o ON c.customer_id = o.customer_id
  GROUP BY c.customer_id
)
SELECT ticket_id, s.customer_id, issue, created_at, status, COALESCE(name, 'not found') AS customer_name, COALESCE(cout, 0) AS order_count
FROM support_tickets s
LEFT JOIN cust c ON s.customer_id = c.customer_id;

-- 7. For each order, list order ID, product count, and total quantity.
SELECT 
  o.order_id,
  COUNT(DISTINCT oi.product) AS product_count,
  SUM(COALESCE(oi.quantity, 0)) AS total_quantity
FROM orders o
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- 8. Show customers who ordered products at more than one unit price.
WITH abc AS (
  SELECT customer_id
  FROM (
    SELECT customer_id, product, unit_price,
           RANK() OVER (PARTITION BY customer_id, product ORDER BY unit_price) AS ra
    FROM orders o1
    JOIN order_items o2 ON o1.order_id = o2.order_id
  ) AS t
  WHERE ra = 2
)
SELECT * FROM customers
WHERE customer_id IN (SELECT customer_id FROM abc);

-- 9. Find the most ordered product by quantity across all orders.
SELECT product
FROM order_items
GROUP BY product
ORDER BY SUM(quantity) DESC
LIMIT 1;

-- 10. List each country and total revenue from its customers (from orders table).
SELECT COALESCE(country, 'NAN') AS country, COALESCE(SUM(total_amount), 0) AS total_revenue
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY COALESCE(country, 'NAN');

-- 11. Get customers who placed orders, but those orders have no items.
SELECT * FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders o1
    LEFT JOIN order_items o2 ON o1.order_id = o2.order_id
    WHERE item_id IS NULL
);

-- 12. List orders placed by unknown customers (customer_id not found in customers).
SELECT order_id
FROM orders o
WHERE customer_id NOT IN (SELECT customer_id FROM customers);

-- 13. List customers who placed multiple orders in the same month.
WITH find_cust AS (
  SELECT MONTH(order_date) AS order_month, customer_id, COUNT(*) AS order_count
  FROM orders
  WHERE order_date IS NOT NULL
  GROUP BY MONTH(order_date), customer_id
  HAVING COUNT(*) > 1
)
SELECT * FROM customers
WHERE customer_id IN (SELECT customer_id FROM find_cust);

-- 14. For each product, show average unit price and the number of distinct orders it appeared in.
SELECT product, COUNT(DISTINCT order_id) AS distinct_orders, ROUND(COALESCE(AVG(unit_price), 0), 1) AS avg_price
FROM order_items
GROUP BY product;

-- 15. Join all 4 tables to list: customer name, order ID, product, quantity, issue (if any), and ticket status.
SELECT 
  c.name AS customer_name,
  o1.order_id,
  o2.product,
  o2.quantity,
  s.issue,
  s.status
FROM orders o1
LEFT JOIN customers c ON c.customer_id = o1.customer_id
LEFT JOIN order_items o2 ON o1.order_id = o2.order_id
LEFT JOIN support_tickets s ON s.customer_id = o1.customer_id;