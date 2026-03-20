-- step 1 : device detection

SELECT 
    device_id, 
    COUNT(DISTINCT player_id) AS linked_accounts
FROM logins
GROUP BY device_id
HAVING COUNT(DISTINCT player_id) > 1;

-- step 2: id detection to block and report
SELECT
logins.player_id,
players.country
FROM logins
JOIN players
ON logins.player_id = players.player_id
WHERE logins.device_id = 'DEV-XXX-999' ;
