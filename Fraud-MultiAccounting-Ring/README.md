### Project: Fraud & Multi-Accounting Ring Detection

**Scenario:** Identifying affiliated accounts abusing Welcome Offers (Bonus Hunting).
**Business Risk:** Direct financial losses due to bonus abuse and fraudulent affiliate CPA triggers.
**SQL Logic:** * **Step 1 (Device Fingerprinting):** Uses `COUNT(DISTINCT player_id)` combined with a `GROUP BY` clause to detect physical devices (`device_id`) linked to multiple unique accounts.
* **Step 2 (Data Extraction):** Employs an `INNER JOIN` between the `logins` and `players` tables to extract the exact `player_id` and `country` of the fraudsters linked to the compromised device.
**Outcome:** Generates a targeted list of linked accounts for immediate withdrawal blocks, bonus confiscation, and device blacklisting.