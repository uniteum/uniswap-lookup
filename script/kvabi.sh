#!/usr/bin/env bash
#
# Extract (chainId, <property>) pairs from a Uniswap deployments YAML and
# emit them as an ABI-encoded `IUintToAddressMaker.KeyValue[]` hex string,
# suitable for the `kvAbi` env var consumed by IUintToAddressMake.s.sol.
#
# Usage:
#   script/kvabi.sh <property> [path/to/uniswap.yml]
#
# Example:
#   kvAbi=$(script/kvabi.sh PoolManager) \
#     forge script script/IUintToAddressMake.s.sol -f $chain \
#       --private-key $tx_key --broadcast

set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 <property> [path/to/uniswap.yml]" >&2
  exit 2
fi

property="$1"
yml="${2:-$(dirname "$0")/uniswap.yml}"

pairs=$(property="$property" yq -r '
  to_entries
  | map(select(.value[env(property)] != null))
  | sort_by(.key | tonumber)
  | map("(" + .key + "," + .value[env(property)] + ")")
  | join(",")
' "$yml")

if [ -z "$pairs" ]; then
  echo "no $property entries found in $yml" >&2
  exit 1
fi

cast abi-encode "f((uint256,address)[])" "[$pairs]"
