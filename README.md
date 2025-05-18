# 📊 Data Analytics SQL Assessment

## Overview
This project is a SQL assessment designed to test my ability to work with relational databases. The task involves writing SQL queries to analyze customer transactions, account activity, and financial insights.

## 📌 Questions & Approach

### 1️⃣ High-Value Customers with Multiple Products
**Objective:** Identify customers with both savings and investment plans, sorted by total deposits.  
**Tables Used:** `users_customuser`, `savings_savingsaccount`, `plans_plan`  
**Approach:**  
✔ Join customer data with savings and investment plans  
✔ Filter **savings** (`is_regular_savings = 1`) & **investment** (`is_a_fund = 1`)  
✔ Aggregate transaction amounts and sort by deposits  

```sql
SELECT u.id AS owner_id, 
       COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name, 
       COUNT(DISTINCT s.id) AS savings_count, 
       COUNT(DISTINCT p.id) AS investment_count, 
       SUM(s.confirmed_amount) / 100 AS total_deposits
FROM users_customuser u
JOIN savings_savingsaccount s ON u.id = s.owner_id
JOIN plans_plan p ON u.id = p.owner_id
WHERE p.is_regular_savings = 1 -- Corrected reference to plans_plan
  AND p.is_a_fund = 1
GROUP BY u.id, name
ORDER BY total_deposits DESC
LIMIT 25;

### 2️⃣ Transaction Frequency Analysis
**Objective:** Categorize customers based on transaction frequency per month. 
**Tables Used:** users_customuser, savings_savingsaccount 
**Approach:**
 ✔ Count transactions per customer in the last 12 months 
✔ Divide transaction count by months since first transaction 
✔ Categorize customers (High, Medium, Low)
```sql
SELECT 
    frequency_category, 
    COUNT(owner_id) AS customer_count,
    ROUND(AVG(transactions_per_month), 2) AS avg_transactions_per_month
FROM (
    SELECT s.owner_id, 
           COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURDATE()) AS transactions_per_month,
           CASE 
               WHEN COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURDATE()) >= 10 THEN 'High Frequency'
               WHEN COUNT(s.id) / TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), CURDATE()) BETWEEN 3 AND 9 THEN 'Medium Frequency'
               ELSE 'Low Frequency'
           END AS frequency_category
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
) AS transaction_summary
GROUP BY frequency_category;

### 3️⃣ Account Inactivity Alert
**Objective:** Find accounts that have had no transactions in the last year (365 days). 
**Tables Used:** plans_plan, savings_savingsaccount, withdrawals_withdrawal 
**Approach:** 
✔ Find the latest transaction for each customer 
✔ Identify accounts where last transaction was over 365 days ago
```sql
SELECT owner_id, MAX(last_transaction_date) AS last_transaction_date,
       DATEDIFF(CURDATE(), MAX(last_transaction_date)) AS inactivity_days
FROM (
    SELECT owner_id, transaction_date AS last_transaction_date FROM savings_savingsaccount
    UNION ALL
    SELECT owner_id, transaction_date AS last_transaction_date FROM withdrawals_withdrawal
) AS all_transactions
GROUP BY owner_id
HAVING inactivity_days > 365;

### 4️⃣ Customer Lifetime Value (CLV) Estimation
**Objective:** Estimate customer CLV based on account tenure and transaction volume. 
**Tables Used:** users_customuser, savings_savingsaccount 
**Approach:** 
✔ Calculate tenure in months since signup 
✔ Count total transactions 
✔ Apply CLV formula
```sql
SELECT u.id AS customer_id, 
       COALESCE(u.name, CONCAT(u.first_name, ' ', u.last_name)) AS name, 
       TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months, 
       COUNT(s.id) AS total_transactions, 
       ROUND((COUNT(s.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * 0.001 * AVG(s.confirmed_amount), 2) AS estimated_clv
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id
WHERE u.is_active = 1
GROUP BY u.id, name, tenure_months
ORDER BY estimated_clv DESC;
