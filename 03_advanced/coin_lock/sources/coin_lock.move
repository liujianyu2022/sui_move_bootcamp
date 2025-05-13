
module coin_lock::coin_lock;

use sui::balance::Balance;
use sui::coin::create_currency;
use sui::url::Url;
use std::option::none;
use sui::transfer::{
    public_freeze_object,
    public_transfer,
    transfer
};
use sui::coin::TreasuryCap;
use sui::coin;

const ErrorNotRelease: u64 = 0x1;

public struct COIN_LOCK has drop {}

public struct Lock has key {
    id: UID,
    balance: Balance<COIN_LOCK>,
    release_time: u64
}

fun init(witness: COIN_LOCK, ctx: &mut TxContext){
    let decimals = 3;
    let symbol = b"COIN_LOCK";
    let name = b"COIN_LOCK";
    let description = b"COIN_LOCK";
    let icon_url = none<Url>();

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

public entry fun mint_and_lock(treasury: &mut TreasuryCap<COIN_LOCK>, amount: u64, to: address, lock_day: u64, ctx: &mut TxContext){
    let coin = coin::mint(treasury, amount, ctx);
    let current_ms = tx_context::epoch_timestamp_ms(ctx);

    let lock = Lock {
        id: object::new(ctx),
        balance: coin::into_balance(coin),
        release_time: current_ms + (lock_day * 24 * 3600 * 1000),
    };

    transfer(lock, to);
}

public entry fun unlock(lock: Lock, ctx: &mut TxContext){
    let current_ms = tx_context::epoch_timestamp_ms(ctx);

    assert!(current_ms > lock.release_time, ErrorNotRelease);

    let Lock {id, balance, release_time: _} = lock;             // 解构赋值

    let coin = coin::from_balance(balance, ctx);

    public_transfer(coin, ctx.sender());

    object::delete(id);
}
