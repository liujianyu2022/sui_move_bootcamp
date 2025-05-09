module coin_supply::usd;

use sui::coin;
use sui::coin::Coin;

use sui::balance::Supply;

use sui::vec_set;
use sui::vec_set::VecSet;

use sui::transfer::{
    public_freeze_object, 
    share_object
};
use std::option::none;

public struct USD has drop {}

public struct MiningPool has key {
    id: UID,
    supply: Supply<USD>,
    miners: VecSet<address>
}

const REWARD_RATE: u64 = 100; // 每个区块奖励100 USD
const ErrorNotMiner: u64 = 0x1;

fun init(witness: USD, ctx: &mut TxContext) {
    let (treasury, metadata) = coin::create_currency(
        witness, 6, b"USD", b"USD Mining", b"Mining reward token", none(), ctx
    );
    
    public_freeze_object(metadata);
    
    let miningPool = MiningPool {
        id: object::new(ctx),
        supply: coin::treasury_into_supply(treasury),
        miners: vec_set::empty()
    };
    share_object(miningPool);
}

public entry fun register_miner(pool: &mut MiningPool, ctx: &mut TxContext) {
    vec_set::insert(&mut pool.miners, ctx.sender());
}

public entry fun mine(pool: &mut MiningPool, ctx: &mut TxContext){
    let sender = &ctx.sender(); // 获取地址的引用
    assert!(vec_set::contains(&pool.miners, sender), ErrorNotMiner);

    // 铸造新代币并直接转移到调用者
    let balance = pool.supply.increase_supply(REWARD_RATE);             // 返回值是代表 新增部分 的 Balance 对象（100 USD）
    let coin = coin::from_balance(balance, ctx);
    transfer::public_transfer(coin, ctx.sender());
}

