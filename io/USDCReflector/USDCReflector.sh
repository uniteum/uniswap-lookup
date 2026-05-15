#!/usr/bin/env bash
# USDCReflector — clone of Reflector that issues 1xUSDC against the
# chain-local Circle USDC. The peg is the USDC AddressLookup so the
# same prediction holds on every chain.
set -euo pipefail
source "$(git rev-parse --show-toplevel)/lib/crucible/script/clone.sh"

# Reflector prototype.
deployer=0xBDbd6217ADFe1f3AE9fd4eC4D82d62A3a9baE090

peg=0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300 # USDC Lookup
symbol=1xUSDC

# Vanity-mining inputs — TODO: re-mine. The variant below is stale.
mask=0xffffff0000000000000000000000000000000000
target=0x05dd500000000000000000000000000000000000

clone_predict USDCReflector "$deployer" \
    "address,string" "$peg" "$symbol" \
    0x00000000000000000000000000000000000000000000000000000000010dfaf1
