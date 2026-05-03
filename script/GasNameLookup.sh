deployer=0xC25F765E3eeA892E091745fea87b59F98623E210
initcode="0x3d602d80600a3d3981f3363d3d373d3d3d363d73${deployer#0x}5af43d82803e903d91602b57fd5bf3"
initcodehash=$(cast keccak "$initcode")
echo "initcodehash=$initcodehash"

contract=GAS
file=gasnames.yml
dir=io/$contract
mkdir -p io/$contract

kvs=$(yq --from-file script/kvs.yq $dir/$file | paste -sd,)
argshash=$(cast keccak "$(cast abi-encode "f((uint256,string)[])" "[$kvs]")")
echo "argshash=$argshash"

variant=0x00000000000000000000000000000000000000000000000000000000050a4f9a 
input=$(cast calldata "make((uint256,string)[],uint256)" "[$kvs]" "$variant")
# XOR argshash ^ variant (256-bit, too wide for bash arithmetic)
salt=$(python3 -c "print(f'0x{int(\"$argshash\",16) ^ int(\"$variant\",16):064x}')")
home=$(cast create2 --deployer "$deployer" --salt "$salt" --init-code "$initcode")
echo "home=$home"

printf '%s' "$input" > "$dir/$home.txt"

mask=0xfffffff000000000000000000000000000000000
target=0x6a50503000000000000000000000000000000000
