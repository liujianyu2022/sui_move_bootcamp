### sui move build
在第一次执行该命令的时候，会安装Sui的依赖。安装的内容详见 `Move.toml` 中的 [dependencies] 
安装在本地目录：/home/liujianyu/.move

比如：
```
/home/liujianyu/.move/https___github_com_MystenLabs_sui_git_devnet/crates/sui-framework/packages/sui-framework
/home/liujianyu/.move/https___github_com_MystenLabs_sui_git_04f11afaf5e0/crates/sui-framework/packages/sui-framework
/home/liujianyu/.move/https___github_com_MystenLabs_sui_git_fbb68879cbd1/crates/sui-framework/packages/sui-framework
/home/liujianyu/.move/https___github_com_mystenLabs_sui_git_framework__testnet/crates/sui-framework/packages/sui-framework

```


### sui client publish
```shell
sui client publish

Config file ["/home/liujianyu/.sui/sui_config/client.yaml"] doesn't exist, do you want to connect to a Sui Full node server [y/N]?y
Sui Full node server URL (Defaults to Sui Testnet if not specified) : 
Select key scheme to generate keypair (0 for ed25519, 1 for secp256k1, 2: for secp256r1):
0

Generated new keypair and alias for address with scheme "ed25519" [stupefied-hypersthene: 0x548e0d9f130e56152f87d9ca2b5c9c88da2c42596d601fd1e8c88c8afe78fd5b]
Secret Recovery Phrase : [fame judge token soldier lunar sign exhibit sure coral trial history conduct]

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


