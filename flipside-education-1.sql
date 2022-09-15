-- Flipsidecrypto Solana Education Analysis
-- https://teamflipside.notion.site/Solana-1-Swap-Volume-on-Orca-58240e257648466da4cf0ba929f2b0b5

WITH sol_in AS (
  SELECT 
date_trunc('day', block_timestamp) AS date,
  sum(swap_from_amount) AS volume_in
FROM solana.core.fact_swaps 
WHERE swap_from_mint = 'So11111111111111111111111111111111111111112'
AND swap_to_mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'
AND succeeded = 'TRUE'
AND swap_program = 'jupiter aggregator v2'
AND block_timestamp >= current_date - 30
GROUP BY date
ORDER BY date ASC
),


sol_out AS (
SELECT 
date_trunc('day', block_timestamp) AS date,
  sum(swap_to_amount) AS volume_out
FROM solana.core.fact_swaps  
WHERE swap_to_mint = 'So11111111111111111111111111111111111111112'
AND swap_from_mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v'
AND succeeded = 'TRUE'
AND swap_program = 'jupiter aggregator v2'
AND block_timestamp >= current_date - 30
GROUP BY date
ORDER BY date ASC
)

SELECT 
a.date, 
a.volume_in, 
b.volume_out, 
a.volume_in - b.volume_out AS flow 
FROM sol_in a
LEFT JOIN sol_out b 
ON a.date = b.date
ORDER BY a.date ASC



