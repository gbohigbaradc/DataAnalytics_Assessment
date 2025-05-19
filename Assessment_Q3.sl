### Optimized SQL Query for Question 3
**-- Query to identify inactive accounts**
**-- Finds customers with no transactions for over 365 days**

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
```
