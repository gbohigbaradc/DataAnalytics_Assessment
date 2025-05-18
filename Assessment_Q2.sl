Optimized SQL Query for Question 2
-- Query to analyze transaction frequency per customer
-- Categorizes customers based on their average transactions per month
``sql``
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