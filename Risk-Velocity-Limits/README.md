### Project: Risk-Velocity-Limits
**Scenario:** Velocity Limits & Anomalous Deposit Spikes.
**Business Risk:** Potential Account Takeover (ATO) or Layering phase of Money Laundering.
**SQL Logic:** Utilizes Common Table Expressions (CTE) and Window Functions (AVG() OVER(PARTITION BY)) to calculate a player's historical average deposit and trigger an alert if a single new transaction exceeds this baseline by 5x or more.
**Outcome:** Automated flagging of erratic financial behavior for Enhanced Due Diligence (EDD).
