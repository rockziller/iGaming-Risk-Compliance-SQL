### Project: AML Structuring (Smurfing) Detection

**Scenario:** Identifying players attempting to bypass Customer Due Diligence (CDD) thresholds through structured deposits.
**Business Risk:** Regulatory fines from the MGA/FIAU for failing to detect smurfing behavior designed to evade the €2000 AML threshold.
**SQL Logic:** Utilizes `GROUP BY` and `HAVING` clauses to aggregate transaction data. It identifies accounts with total deposited amounts >= €2000, where no single transaction individually hits the trigger limit.
**Outcome:** Flags potential money laundering behavior for manual Source of Funds (SoF) review and Enhanced Due Diligence (EDD).