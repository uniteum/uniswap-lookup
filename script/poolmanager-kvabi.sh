#!/usr/bin/env bash
#
# Extract (chainId, PoolManager) pairs from a Uniswap deployments YAML and
# emit them as an ABI-encoded `IUintToAddressMaker.KeyValue[]` hex string,
# suitable for the `kvAbi` env var consumed by IUintToAddressMake.s.sol.
#
# Usage:
#   script/poolmanager-kvabi.sh [path/to/uniswap.yml]
#
# Example:
#   kvAbi=$(script/poolmanager-kvabi.sh) \
#     forge script script/IUintToAddressMake.s.sol -f $chain \
#       --private-key $tx_key --broadcast

set -euo pipefail

yml="${1:-$(dirname "$0")/uniswap.yml}"

pairs=$(yq -r '
  to_entries
  | map(select(.value.PoolManager != null))
  | sort_by(.key | tonumber)
  | map("(" + .key + "," + .value.PoolManager + ")")
  | join(",")
' "$yml")

if [ -z "$pairs" ]; then
  echo "no PoolManager entries found in $yml" >&2
  exit 1
fi

cast abi-encode "f((uint256,address)[])" "[$pairs]"
