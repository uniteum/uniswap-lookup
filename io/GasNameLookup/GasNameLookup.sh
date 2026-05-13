#!/usr/bin/env bash
# GasNameLookup — clone of locale's StringLookup keyed by chainId →
# native gas-token symbol ("ETH", "MATIC", etc.). Address is the same on
# every chain; value() returns the chain-local symbol.
set -euo pipefail
source "$(git rev-parse --show-toplevel)/lib/crucible/script/clone.sh"

# Locale's StringLookup prototype.
deployer=0x555F0018a30F59634af07589ed17f44DF2BCE300

# (chainId, gas-symbol) pairs from io/GasNameLookup/gasnames.yml, formatted
# as a Solidity tuple-array literal.
kvs=$(yq --from-file script/kvs.yq io/GasNameLookup/gasnames.yml | paste -sd,)

# Vanity-mining inputs (captured into the yml).
mask=0xfff000000000000000000000000000000000ffff
target=0x6a5000000000000000000000000000000000e300

clone_predict GasNameLookup "$deployer" \
    "(uint256,string)[]" "[$kvs]" \
    0x000000000000000000000000000000000000000000000000000000000595b6ad
