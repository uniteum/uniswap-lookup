pairs=$(yq -r 'to_entries | .[] | "(" + .key + "," + .value + ")"' script/USDC.yml | paste -sd,)
cast abi-encode "f((uint256,address)[])" "[$pairs]"
