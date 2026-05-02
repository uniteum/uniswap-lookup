variant=0x000000000000000000000000000000000000000000000000000000007fa78ab1
kvs=$(yq --from-file script/kvs.yq script/USDC.yml | paste -sd,)
deployer=0xAdD181fDf0E1077Bcb846ce03B99850Bca1de210
supply=3141592653589793238
target=0xc5dc00000000000000000000000000000000c5dc
mask=0xffff00000000000000000000000000000000ffff

initcode="0x3d602d80600a3d3981f3363d3d373d3d3d363d73${deployer#0x}5af43d82803e903d91602b57fd5bf3"
initcodehash=$(cast keccak "$initcode")

argshash=$(cast keccak "$(cast abi-encode "f((uint256,address)[])" "[$kvs]")")

# XOR argshash ^ variant (256-bit, too wide for bash arithmetic)
salt=$(python3 -c "print(f'0x{int(\"$argshash\",16) ^ int(\"$variant\",16):064x}')")

home=$(cast create2 --deployer "$deployer" --salt "$salt" --init-code "$initcode")
input=$(cast calldata "make((uint256,address)[],uint256)" "[$kvs]" "$variant")

echo "initcodehash=$initcodehash"
echo "argshash=$argshash"
echo "home=$home"

mkdir -p io/USDC
printf '%s' "$input" > "io/USDC/$home.txt"
