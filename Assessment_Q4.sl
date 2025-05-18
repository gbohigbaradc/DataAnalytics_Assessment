Optimized SQL Query for Question 4
-- Query to estimate customer lifetime value (CLV)
-- Calculates account tenure, total transactions, and CLV score
``sql``
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