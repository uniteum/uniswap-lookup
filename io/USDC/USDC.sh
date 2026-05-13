#!/usr/bin/env bash
# USDC — clone of locale's AddressLookup keyed by chainId → native
# (Circle-issued) USDC address. Address is the same on every chain;
# value() returns the chain-local USDC.
#
# AddressLookup's make computes
#   salt = keccak(abi.encode((uint256,address)[])) ^ variant
set -euo pipefail
source "$(git rev-parse --show-toplevel)/lib/crucible/script/clone.sh"

# Locale's AddressLookup prototype (same prototype used by
# io/PoolManagerLookup/PoolManagerLookup.sh).
deployer=0xADD27841708048b2B8F053A9199f320A0724e300

# (chainId, USDC) pairs from script/USDC.yml, formatted as a Solidity
# tuple-array literal: "(1,0x...),(8453,0x...),...".
kvs=$(yq --from-file script/kvs.yq io/USDC/USDC.yml | paste -sd,)

# Vanity-mining inputs — TODO: choose a target and re-mine for the new
# deployer. The legacy script's mask/target/variant were mined against
# the old deployer 0xAdD181…e210 and are stale.
mask=0xffff00000000000000000000000000000000ffff
target=0xc5dc00000000000000000000000000000000e300

clone_predict USDC "$deployer" \
    "(uint256,address)[]" "[$kvs]" \
    0x000000000000000000000000000000000000000000000000000000002f809dc4
