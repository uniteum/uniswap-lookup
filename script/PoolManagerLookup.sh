deployer=0xAdD181fDf0E1077Bcb846ce03B99850Bca1de210
initcode="0x3d602d80600a3d3981f3363d3d373d3d3d363d73${deployer#0x}5af43d82803e903d91602b57fd5bf3"
initcodehash=$(cast keccak "$initcode")
echo "initcodehash=$initcodehash"

kvs=$(property=PoolManager yq --from-file script/uniswap.yq script/uniswap.yml)
argshash=$(cast keccak "$(cast abi-encode "f((uint256,address)[])" "[$kvs]")")
echo "argshash=$argshash"

variant=0x000000000000000000000000000000000000000000000000000000016c3e78be
input=$(cast calldata "make((uint256,address)[],uint256)" "[$kvs]" "$variant")
# XOR argshash ^ variant (256-bit, too wide for bash arithmetic)
salt=$(python3 -c "print(f'0x{int(\"$argshash\",16) ^ int(\"$variant\",16):064x}')")
home=$(cast create2 --deployer "$deployer" --salt "$salt" --init-code "$initcode")
echo "home=$home"

mkdir -p io/PoolManagerLookup
printf '%s' "$input" > "io/PoolManagerLookup/$home.txt"

target=0xb00100000000000000000000000000000000e210
mask=0xffff00000000000000000000000000000000ffff
