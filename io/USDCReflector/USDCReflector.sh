#!/usr/bin/env bash
# USDCReflector — clone of Reflector that issues 1xUSDC against the
# chain-local Circle USDC. The peg is the USDC AddressLookup so the
# same prediction holds on every chain.
set -euo pipefail
source "$(git rev-parse --show-toplevel)/lib/crucible/script/clone.sh"

# Reflector prototype.
deployer=0xBDbd73f71A85feccbB20DBB25B21EaD9a457E090

peg=0xC5DC3461ed6653dbC5E6A8bCDcF0354fF178E300 # USDC Lookup
symbol=1xUSDC

# Vanity-mining inputs — TODO: re-mine. The variant below is stale.
mask=0xffffff0000000000000000000000000000000000
target=0x05dd500000000000000000000000000000000000

clone_predict USDCReflector "$deployer" \
    "address,string" "$peg" "$symbol" \
    0x00000000000000000000000000000000000000000000000000000000017a682c
