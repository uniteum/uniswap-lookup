#!/usr/bin/env bash
# GasNameLookup — clone of locale's StringLookup keyed by chainId →
# native gas-token symbol ("ETH", "MATIC", etc.). Address is the same on
# every chain; value() returns the chain-local symbol.
set -euo pipefail
source "$(git rev-parse --show-toplevel)/lib/crucible/script/clone.sh"

# Locale's StringLookup prototype.
deployer=0x55507262c591E385d7a79562d86eCe956FdAe220

# (chainId, gas-symbol) pairs from io/GasNameLookup/gasnames.yml, formatted
# as a Solidity tuple-array literal.
kvs=$(yq --from-file script/kvs.yq io/GasNameLookup/gasnames.yml | paste -sd,)

# Vanity-mining inputs (captured into the yml).
mask=0xfff000000000000000000000000000000000ffff
target=0x6a5000000000000000000000000000000000e220

clone_predict GasNameLookup "$deployer" \
    "(uint256,string)[]" "[$kvs]" \
    0x0000000000000000000000000000000000000000000000000000000013fcc6f7
