module coin_owner::usd;

use std::option::none;
use sui::url::Url;
use sui::coin::create_currency;
use sui::transfer::{
    public_freeze_object,
    public_share_object
};

public struct USD has drop {}

fun init(witness: USD, ctx: &mut TxContext){

    let decimals: u8 = 3;
    let symbol: vector<u8> = b"OWNER_USD";
    let name: vector<u8> = b"OWNER_USD";
    let description = b"This is OWNER_USD";

    let icon_url = none<Url>();              // 如果不需要图标

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

    // 所有人都能访问
    public_share_object(treasury);
}
