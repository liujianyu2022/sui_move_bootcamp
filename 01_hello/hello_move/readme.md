### sui client publish
```shell
sui client publish

Config file ["/home/liujianyu/.sui/sui_config/client.yaml"] doesn't exist, do you want to connect to a Sui Full node server [y/N]?y
Sui Full node server URL (Defaults to Sui Testnet if not specified) : 
Select key scheme to generate keypair (0 for ed25519, 1 for secp256k1, 2: for secp256r1):
0

Generated new keypair and alias for address with scheme "ed25519" [stupefied-hypersthene: 0xf31c8341abcf70043af3abb224b66576015eb1ca45a2c77853b53909b9443575]
Secret Recovery Phrase : [alien believe teach suggest piece ribbon hunt team renew nut cram power]
```
- connect to a Sui Full node server: y
- Sui Full node server URL:                     (press `ENTER` directly, defaults to Sui Testnet)
- Select key schema to generate keypair:        (press `0` )

In Move.toml
```
[dependencies]
Sui = { git = "https://github.com/mystenLabs/sui.git", subdir = "crates/sui-framework/packages/sui-framework", rev = "framework/testnet" }
```

### sui client addresses

### sui client faucet
```
sui client faucet 
For testnet tokens, please use the Web UI: https://faucet.sui.io/?address=0xf31c8341abcf70043af3abb224b66576015eb1ca45a2c77853b53909b9443575
```

### sui client gas
Check if the faucet works.

### blockchain explorer
- https://suiscan.xyz/
- https://suivision.xyz/


