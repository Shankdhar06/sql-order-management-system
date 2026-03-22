# 🛒 SQL Order Management Analysis — Reliant Retail Limited

## 📌 Project Overview

A MySQL-based analytical project for **Reliant Retail Limited**, an online retail chain. Given their `orders` database, this project answers 10 real business questions using advanced SQL — helping the company make data-driven decisions on inventory, customers, orders, and logistics.

---

## 🗂️ Repository Structure

| File | Description |
|---|---|
| `Vaibhav_Shankdhar.sql` | All 10 SQL queries with detailed inline comments |
| `new_Orders.sql` | Database schema and seed data to set up the environment |
| `README.md` | Project documentation |

---

## 🏗️ Database Schema

The `orders` database consists of **7 tables**:

```
online_customer    — Customer details and address
address            — City, state, pincode, country
order_header       — Order ID, status, payment mode, shipment date
order_items        — Products per order with quantities
product            — Product details, price, dimensions, stock
product_class      — Product categories (Electronics, Clothes, etc.)
carton             — Box dimensions for shipment packaging
shipper            — Shipper details
```

---

## 🔍 Queries & Concepts Covered

| # | Business Question | SQL Concepts Used |
|---|---|---|
| 1 | Product prices with category-based adjustments | `CASE WHEN`, `ORDER BY` |
| 2 | Inventory status per product category and quantity | Nested `CASE WHEN`, `JOIN` |
| 3 | City counts per country excluding USA & Malaysia | `GROUP BY`, `HAVING`, `WHERE NOT IN` |
| 4 | Orders shipped to pincodes with no zeros | Multi-table `JOIN`, `NOT LIKE`, `CONCAT` |
| 5 | Most co-purchased product alongside Product ID 201 | `Subquery`, `GROUP BY`, `LIMIT` |
| 6 | All customers with or without orders | `LEFT JOIN` |
| 7 | Optimum carton size for Order ID 10006 | `Subquery`, `HAVING`, volume calculation |
| 8 | Customers buying >10 items via Credit Card / Net Banking | `GROUP BY`, `HAVING`, `SUM` |
| 9 | Shipped orders >10030 for customers starting with 'A' | `HAVING LIKE`, `GROUP BY` |
| 10 | Top product class shipped outside India & USA by quantity | Multi-table `JOIN`, `SUM`, `LIMIT` |

---

## 🚀 How to Run

1. Set up MySQL locally or use any online MySQL environment
2. First run the schema file to create and populate the database:
```sql
SOURCE new_Orders.sql;
```
3. Then run the analysis queries:
```sql
SOURCE Vaibhav_Shankdhar.sql;
```

Or copy-paste individual queries from `Vaibhav_Shankdhar.sql` directly into MySQL Workbench.

---

## 🛠️ Tools Used

![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=flat&logo=mysql)
![SQL](https://img.shields.io/badge/SQL-Advanced-orange?style=flat&logo=postgresql)
![MySQL Workbench](https://img.shields.io/badge/MySQL%20Workbench-IDE-lightblue?style=flat)

---

## 📬 Connect

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Vaibhav%20Shankdhar-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/vaibhav-shankdhar-0602)
[![GitHub](https://img.shields.io/badge/GitHub-Profile-black?style=flat&logo=github)](https://github.com/Shankdhar06)
