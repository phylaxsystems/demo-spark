# Spark Demo

## Env Variables

- `ETH_RPC`: The url to the internal Reth node that runs alongside the hosted Phylax node

## Alerts

### User Health

- Call `getUserHealth` for every call against the pool on `Supply`, `Withdraw`, `Repay`, and `Borrow` events
- Alert triggers if `belowLiquidationThreshold == true`

### Assets Liability

- Call `getAllReservesAssetLiability` every 5 blocks.
- Allert triggers when for a reserve i, we have `assets[i] - liabilities[i] > 1000e18`

## Actions

A slack webhook to their internal slack for each alert
