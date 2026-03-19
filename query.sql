SELECT 
    player_id, 
    SUM(amount) AS total_deposited, 
    MAX(amount) AS max_single_deposit
FROM transactions
WHERE tx_type = 'Deposit'
GROUP BY player_id
HAVING SUM(amount) >= 2000 
   AND MAX(amount) < 2000;