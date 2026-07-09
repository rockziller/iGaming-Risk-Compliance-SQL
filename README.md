# Crypto & Fiat Treasury Reconciliation Project

## Project Overview
In highly regulated iGaming and FinTech environments (under MGA/UKGC frameworks), maintaining 100% data integrity and the **Segregation of Funds** is critical. 

This project demonstrates a practical automation model for a **Daily Treasury Reconciliation Workflow**. It identifies transactional discrepancies between internal platform database logs (Backoffice) and external blockchain network ledgers (On-Chain TXIDs/Wallet States).

---

## The Problem (Scenario)
A live platform processes deposits and withdrawals using both stablecoins (USDT/USDC) and fiat clearing systems (SEPA). 
Manual checks of thousands of daily transactions create operational bottlenecks and cause settlement delays. 

This project simulates a **"Maker/Checker"** validation model to catch 3 major types of anomalies:
1. **Slippage & Value Mismatch:** Discrepancies between expected amounts and actual settled amounts.
2. **Missing TXIDs:** Status mismatches where the platform marks a transaction as "Success", but no Transaction Hash exists on-chain.
3. **Internal Log Inconsistencies:** Human errors or technical delays in internal settlement tables.

---

## Data Structure & Logic

The verification model uses two transactional datasets:
1. `internal_platform_logs` (The system data)
2. `blockchain_wallet_events` (The actual ledger data)

### SQL Reconciliation Script

```sql
-- Query to identify transaction mismatches, missing TXIDs, and status anomalies
SELECT 
    i.transaction_id,
    i.user_id,
    i.asset_type,
    i.amount_expected AS platform_amount,
    b.amount_settled AS ledger_amount,
    (i.amount_expected - b.amount_settled) AS discrepancy_amount,
    i.txid AS platform_txid,
    b.txid AS network_txid,
    CASE 
        WHEN b.txid IS NULL THEN 'CRITICAL: Missing On-Chain Confirmation'
        WHEN i.amount_expected <> b.amount_settled THEN 'WARNING: Slippage/Amount Mismatch'
        WHEN i.status = 'Success' AND b.status = 'Failed' THEN 'CRITICAL: Status Out of Sync'
        ELSE 'Clean'
    END AS reconciliation_status
FROM internal_platform_logs i
LEFT JOIN blockchain_wallet_events b 
    ON i.txid = b.txid OR i.transaction_id = b.reference_id
WHERE i.amount_expected <> b.amount_settled 
   OR b.txid IS NULL 
   OR i.status <> b.status;
