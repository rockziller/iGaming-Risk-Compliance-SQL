-- Step 1: Create a Common Table Expression (CTE) to calculate the historical average deposit per player
WITH DepositStats AS (
    SELECT 
        player_id,
        tx_date,
        amount AS current_deposit,
        AVG(amount) OVER(PARTITION BY player_id) AS avg_historical_deposit
    FROM transactions
    WHERE tx_type = 'Deposit'
)

-- Step 2: Isolate and flag transactions where the current deposit exceeds the historical average by 5x or more
SELECT 
    player_id,
    tx_date,
    current_deposit,
    avg_historical_deposit,
    (current_deposit / avg_historical_deposit) AS spike_multiplier
FROM DepositStats
WHERE current_deposit >= avg_historical_deposit * 5;