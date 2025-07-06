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
(106, NULL, '2023-01-25', 300), -- anonymous order
(107, 6, '2023-01-30', NULL),  -- order with no amount
(108, 1, NULL, 175),
(109, 7, '2023-02-01', 500),
(110, 3, '2023-02-05', 250),
(111, 10, '2023-02-10', 300); -- unknown customer


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
(13, 111, 'Chair', NULL, 100); -- NULL quantity


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

select * from customers;
select * from order_items;
select * from orders;
select * from support_tickets;


-- 1 List all customers along with their total number of orders.
select c.customer_id,name,count(order_id)
from customers c
left join orders o
on c.customer_id = o.customer_id
group by customer_id,name;

-- 2  Show total spending for each customer calculated from order_items, not orders
select c.customer_id,name,coalesce(sum(quantity * Unit_price),0)
from customers c
left join orders o1 on c.customer_id = o1.customer_id
left join order_items o2 on o1.order_id = o2.order_id
group by c.customer_id,c.name;

-- 3  List customers who raised support tickets but never placed an order.
select * from customers
where customer_id in (select distinct customer_id from support_tickets where customer_id in 
(select c.customer_id
from customers c
left join orders o on c.customer_id = o.customer_id
where order_id is null));

-- 4  Find customers who placed more than one order and also have more than one support ticket.
select * from customers where 
customer_id in 
		(select customer_id from support_tickets 
		where customer_id in
				(select c.customer_id
				from customers c
				join orders o on c.customer_id = o.customer_id
				group by c.customer_id,c.name
				having count(order_id) > 1)
		group by customer_id
		having count(*) > 1);
        
-- 5  Show all orders where the computed total from order_items differs from the total_amount in orders
WITH order_items_single AS (
  SELECT order_id, coalesce(sum(quantity * unit_price),0) AS total_price_item
  FROM order_items
  GROUP BY order_id
)
SELECT o.order_id,total_price_item,total_amount
FROM order_items_single os
right join orders o on os.order_id= o.order_id
where coalesce(total_price_item,0) <> coalesce(total_amount,0)








 


































