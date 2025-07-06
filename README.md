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

### Day 1 – Questions 1 to 5

1. **List all customers along with their total number of orders.**
2. **Show total spending for each customer calculated from `order_items`.**
3. **Find customers who raised support tickets but never placed an order.**
4. **Find customers with >1 order and >1 support ticket.**
5. **List orders where computed total from `order_items` doesn't match `orders.total_amount`.**

🔍 View solution in [`answers_day1.sql`](./answers_day1.sql)

---

## 🗓️ Daily Plan

| Date       | Questions Solved |
|------------|------------------|
| `2025-07-06` | 1–5              |
| `2025-07-07` | 6–10 *(upcoming)* |

---


Compatible with **MySQL 8+**, but can be adapted for PostgreSQL or SQLite.

---

## 🧠 Author

**KAUSHIK**  
Aspiring Data Analyst | SQL • EDA • Visualization