Optimized SQL Query for Question 1
-- Query to find high-value customers with multiple products
-- Customers must have at least one funded savings plan AND one funded investment plan

``sql
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
``
