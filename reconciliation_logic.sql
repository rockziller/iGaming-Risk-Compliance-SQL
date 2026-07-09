-- =========================================================================
-- TITLE: AUTOMATED CRYPTO & FIAT RECONCILIATION SCRIPT
-- POSITION: Crypto Operations & Treasury Specialist
-- PURPOSE: Simulating Daily Platform Reconciliation & Discrepancy Detection
-- =========================================================================

-- 1. Create Simulated Internal Platform Database (Deposits/Withdrawals)
CREATE TABLE internal_platform_logs (
    transaction_id VARCHAR(50) PRIMARY KEY,
    user_id INT,
    asset_type VARCHAR(20),
    amount_expected DECIMAL(18, 2),
    txid VARCHAR(100),
    status VARCHAR(20)
);

-- 2. Create Simulated External Ledger (On-Chain Core / Bank Clearing)
CREATE TABLE blockchain_wallet_events (
    event_id INT PRIMARY KEY,
    reference_id VARCHAR(50),
    amount_settled DECIMAL(18, 2),
    txid VARCHAR(100),
    status VARCHAR(20)
);

-- 3. Insert Test Case 1: High Execution Slippage on Hyperliquid DEX (USDT)
INSERT INTO internal_platform_logs VALUES ('TX-90812', 4412, 'USDT (ERC20)', 15000.00, '0x3a5b6c...', 'Success');
INSERT INTO blockchain_wallet_events VALUES (1, 'TX-90812', 14850.00, '0x3a5b6c...', 'Success');

-- 4. Insert Test Case 2: Missing On-Chain Hash (API Glitch / Pending Node)
INSERT INTO internal_platform_logs VALUES ('TX-90815', 8819, 'USDC (Polygon)', 4200.00, NULL, 'Success');

-- 5. Insert Test Case 3: SEPA Clearing Mismatch (Status Out of Sync)
INSERT INTO internal_platform_logs VALUES ('TX-90819', 3110, 'EUR (SEPA)', 8500.00, 'SEPA-REF-992', 'Pending');
INSERT INTO blockchain_wallet_events VALUES (3, 'TX-90819', 8500.00, 'SEPA-REF-992', 'Success');


-- 6. THE MAIN RECONCILIATION QUERY
-- Run this daily to extract anomalies and mitigate financial operational risks
SELECT 
    i.transaction_id,
    i.user_id,
    i.asset_type,
    i.amount_expected AS platform_amount,
    COALESCE(b.amount_settled, 0.00) AS ledger_amount,
    (i.amount_expected - COALESCE(b.amount_settled, 0.00)) AS discrepancy_amount,
    i.txid AS platform_txid,
    b.txid AS network_txid,
    CASE 
        WHEN i.txid IS NULL AND i.status = 'Success' THEN 'CRITICAL: Missing On-Chain Confirmation'
        WHEN i.amount_expected <> b.amount_settled THEN 'WARNING: Slippage/Amount Mismatch'
        WHEN i.status = 'Pending' AND b.status = 'Success' THEN 'STATUS MISMATCH: Bank Cleared, Update Platform'
        ELSE 'Clean'
    END AS reconciliation_status
FROM internal_platform_logs i
LEFT JOIN blockchain_wallet_events b 
    ON i.transaction_id = b.reference_id
WHERE i.amount_expected <> b.amount_settled 
   OR i.txid IS NULL 
   OR i.status <> b.status;
