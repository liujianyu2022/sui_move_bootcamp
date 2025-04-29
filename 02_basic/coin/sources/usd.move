
module coin::usd;

use sui::coin::create_currency;

use sui::url::{
    Url,
    new_unsafe_from_bytes
};

use std::option::{
    none,
    some
};

use sui::transfer::{
    public_freeze_object,
    public_transfer
};
use std::string;

public struct USD has drop{

}


fun init(usd: USD, ctx: &mut TxContext){

    let decimals: u8 = 3;
    let symbol: vector<u8> = b"USD";
    let name: vector<u8> = b"USD";
    let description = b"This is USD";

    // let icon_url = none<Url>();              // 如果不需要图标

    // icon_url 需要是 Option<Url> 类型，而不是直接传入字符串
    let icon_url_bytes = b"https://img0.baidu.com/it/u=3930881841,94724992&fm=253&fmt=auto&app=138&f=JPEG?w=361&h=365";
    let icon_url = some(new_unsafe_from_bytes(icon_url_bytes));

    let (treasury, coin_metadata) = create_currency(
        usd, 
        decimals, 
        symbol, 
        name, 
        description, 
        icon_url, 
        ctx
    );

    public_freeze_object(coin_metadata);

    public_transfer(treasury, ctx.sender());
}

// public fun create_currency<T: drop>(
//     witness: T,
//     decimals: u8,
//     symbol: vector<u8>,
//     name: vector<u8>,
//     description: vector<u8>,
//     icon_url: Option<Url>,
//     ctx: &mut TxContext,
// ): (TreasuryCap<T>, CoinMetadata<T>)





// 1. 先把合约发布上链 sui client publish
// 2. 获取发布合约的 Package ID: 0xdeb82e619635a637d346acafc472858f931c3c7ac2f409833eb2c93273478eb5

// Usage: sui client call [OPTIONS] --package <PACKAGE> --module <MODULE> --function <FUNCTION>

// Options:
//       --package <PACKAGE>               Object ID of the package, which contains the module
//       --module <MODULE>                 The name of the module in the package
//       --function <FUNCTION>             Function name in module
//       --type-args <TYPE_ARGS>...        Type arguments to the generic function being called. All must be specified, or the call will fail
//       --args <ARGS>...                  Simplified ordered args like in the function syntax ObjectIDs, Addresses must be hex strings



// public entry fun mint_and_transfer<T>(
//     c: &mut TreasuryCap<T>,
//     amount: u64,
//     recipient: address,
//     ctx: &mut TxContext,
// ) {
//     transfer::public_transfer(mint(c, amount, ctx), recipient)
// }

// 3. 按照上面的方式，在命令行调用 mint_and_transfer
// sui client call --package 0x2 --module coin --function mint_and_transfer --type-args 0xdeb82e619635a637d346acafc472858f931c3c7ac2f409833eb2c93273478eb5::usd::USD --args 0xcd037d72d935d1d13a39c970b493ee29f00c37310a648544dea47cee361e0da5 10000000000000 0xf31c8341abcf70043af3abb224b66576015eb1ca45a2c77853b53909b9443575

// sui client call \
//     --package 0x2 \
//     --module coin \
//     --function mint_and_transfer \
//     --type-args 0xdeb82e619635a637d346acafc472858f931c3c7ac2f409833eb2c93273478eb5::usd::USD \
//     --args 0xcd037d72d935d1d13a39c970b493ee29f00c37310a648544dea47cee361e0da5 10000000000000 0xf31c8341abcf70043af3abb224b66576015eb1ca45a2c77853b53909b9443575

// 注意：上面的 0xcd037d72d935d1d13a39c970b493ee29f00c37310a648544dea47cee361e0da5 是 TreasuryCap 权限对应的 ObjectID

// 查看方法1：
// 1. 在执行 sui client publish 的时候，在控制台找到 Object Changes 表格
// 2. 然后找到如下的片段：
// │  ┌──                                                                                                                  │
// │  │ ObjectID: 0xcd037d72d935d1d13a39c970b493ee29f00c37310a648544dea47cee361e0da5                                       │
// │  │ Sender: 0xf31c8341abcf70043af3abb224b66576015eb1ca45a2c77853b53909b9443575                                         │
// │  │ Owner: Account Address ( 0xf31c8341abcf70043af3abb224b66576015eb1ca45a2c77853b53909b9443575 )                      │
// │  │ ObjectType: 0x2::coin::TreasuryCap<0xdeb82e619635a637d346acafc472858f931c3c7ac2f409833eb2c93273478eb5::usd::USD>   │
// │  │ Version: 349178167                                                                                                 │
// │  │ Digest: 7Uy39PqfmogxsNSEbFkZhdZ6uVK698dLbmLwytc6zZ6s                                                               │
// │  └── 

// 查看方法2：
// 1. 在区块链浏览器中，找到部署的记录
// 2. 滑到页面底部，找到 “Object Change” 
// 3. 点击右上角的 “RAW” 切换为 JSON 格式，搜索 "TreasuryCap" 即可，然后复制 objectId