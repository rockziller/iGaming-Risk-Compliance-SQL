Scenario: AML Structuring (Smurfing) Detection.
Business Risk: Regulatory fines from the MGA/FIAU for bypassing the €2000 Customer Due Diligence (CDD) threshold.
SQL Logic: Utilizes GROUP BY and HAVING clauses to identify players with total deposits $\ge$ €2000 within a 24-hour timeframe, where no single transaction exceeds the threshold limit.
Outcome: Flags potential money laundering behavior for manual Source of Funds (SoF) review.