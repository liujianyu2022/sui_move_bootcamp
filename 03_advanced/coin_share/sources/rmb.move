module coin_share::rmb;

use std::option::none;
use sui::url::Url;
use sui::coin::create_currency;
use sui::transfer::{
    public_freeze_object,
    public_transfer
};

public struct RMB has drop {}

fun init(witness: RMB, ctx: &mut TxContext) {
    let decimals: u8 = 3;
    let symbol: vector<u8> = b"OWNER_RMB";
    let name: vector<u8> = b"OWNER_RMB";
    let description = b"This is OWNER_RMB";

    let icon_url = none<Url>();              // 如果不需要图标

    // treasury 是国库权限， metadata 是Coin的信息
    let (treasury, metadata) = create_currency(
        witness, 
        decimals, 
        symbol, 
        name, 
        description, 
        icon_url, 
        ctx
    );

    public_freeze_object(metadata);
    public_transfer(treasury, ctx.sender());
}


