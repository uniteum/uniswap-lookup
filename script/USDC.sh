pairs=$(yq -r 'to_entries | sort_by(.key | tonumber) | .[] | "(" + .key + "," + .value + ")"' script/USDC.yml | paste -sd,)
cast calldata "make((uint256,address)[])" "[$pairs]"
