#!/usr/bin/env bash
# PoolManagerLookup — clone of locale's AddressLookup keyed by chainId →
# Uniswap V4 PoolManager address. Address is the same on every chain;
# value() returns the chain-local PoolManager.
set -euo pipefail
source "$(git rev-parse --show-toplevel)/lib/crucible/script/clone.sh"

# Locale's AddressLookup prototype.
deployer=0xadDf9ab01bC368d791666A9708381ca7C056e220

# (chainId, V4 PoolManager) pairs from script/uniswap.yml, formatted as a
# Solidity tuple-array literal: "(1,0x...),(8453,0x...),...".
kvs=$(property=PoolManager yq --from-file script/uniswap.yq io/uniswap.yml)

# Vanity-mining inputs (captured into the yml).
mask=0xffff00000000000000000000000000000000ffff
target=0xb00100000000000000000000000000000000e220

clone_predict PoolManagerLookup "$deployer" \
    "(uint256,address)[]" "[$kvs]" \
    0x00000000000000000000000000000000000000000000000000000003bf1fe45c
