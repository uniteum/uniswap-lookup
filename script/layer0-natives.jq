# Build a map from nativeChainId to native-token symbol.
#
# A "native token" is the entry stored at the all-zeros address inside
# each chain's "tokens" map (e.g. KITE on Kite, MATIC on Polygon).
#
# Input:  layer0.json — top-level object keyed by chain identifier.
#         Each chain provides:
#           .chainDetails.nativeChainId          — numeric chain id
#           .tokens["0x000…0"].symbol            — native ticker
#
# Output: YAML lines like `137: "MATIC"`, sorted by chain id.
#
# Usage:
#   jq -r --from-file script/layer0-natives.jq io/layer0.json

def nativeTokenAddress: "0x0000000000000000000000000000000000000000";

def isEvm:          .chainDetails.chainType? == "evm";
def hasChainId:     .chainDetails.nativeChainId? != null;
def hasNativeToken: .tokens[nativeTokenAddress].symbol? != null;

[
  .[]
  | select(isEvm and hasChainId and hasNativeToken)
  | {
      chainId: .chainDetails.nativeChainId,
      symbol:  .tokens[nativeTokenAddress].symbol
    }
]
| unique_by(.chainId)
| .[]
| "\(.chainId): \"\(.symbol)\""
