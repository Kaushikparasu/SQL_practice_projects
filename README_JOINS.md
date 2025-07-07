# 🧠 SQL Mini-Project: Multi-Table Joins Practice

This project focuses on mastering **SQL joins** using a realistic, multi-table dataset containing `customers`, `orders`, `order_items`, and `support_tickets`.

---

## 📦 Dataset Overview

| Table Name        | Description                                   |
|------------------|-----------------------------------------------|
| `customers`       | Customer details (name, country, email)       |
| `orders`          | Orders placed by customers                    |
| `order_items`     | Products within each order                    |
| `support_tickets` | Customer support issues                       |

✔️ Includes **NULLs**, **missing links**, and **duplicate-prone** data to mimic real-world scenarios.

---

## 🎯 Project Goals

- Practice `INNER`, `LEFT`, `RIGHT`, and `FULL` joins
- Use `GROUP BY`, `HAVING`, `WHERE`, subqueries, and `CTEs`
- Handle NULLs and mismatched foreign keys
- Write **readable**, **modular**, and **efficient** SQL

---

## ✅ Questions Solved

1. List all customers along with their total number of orders  
2. Show total spending per customer calculated from `order_items`  
3. Find customers who raised support tickets but never placed an order  
4. Customers with >1 order and >1 support ticket  
5. Orders where computed item total ≠ recorded total  
6. Support tickets with customer name and order count  
7. Product count and quantity per order  
8. Customers who bought the same product at different prices  
9. Most ordered product by quantity  
10. Revenue by customer country  
11. Customers who placed orders with no items  
12. Orders placed by unknown customers  
13. Customers who placed multiple orders in the same month  
14. Avg. unit price and distinct order count per product  
15. Join all 4 tables: customer name, order ID, product, quantity, issue, and ticket status  

---

## 🗂️ File Structure

| File                       | Description                              |
|---------------------------|------------------------------------------|
| `project_1_joins_clean.sql` | Main SQL solution file (clean version)   |
| `README.md`               | This file                                |

---

## 🧠 Author

**Indhra Sena Reddy**  
Aspiring Data Analyst | SQL • EDA • Visualization
