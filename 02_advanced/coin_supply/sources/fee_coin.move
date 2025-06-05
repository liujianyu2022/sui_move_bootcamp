// 


module coin_supply::fee_coin;

use sui::balance::Supply;
use sui::coin::{
    create_currency,
    treasury_into_supply
};
use std::option::none;
use sui::url::Url;
use sui::transfer::{
    public_freeze_object,
    public_transfer
};
use sui::coin::Coin;
use sui::balance;
use sui::coin;
use sui::sui::SUI;

const ErrorOverflow: u64 = 0x1;
const ErrorInsufficientBalance: u64 = 0x2;

public struct FEE_COIN has drop {}

public struct FeeCoinTreasuryCapacity has key, store {
    id: UID,
    supply: Supply<FEE_COIN>
}

fun init(witness: FEE_COIN, ctx: &mut TxContext){
    let decimals = 3;
    let symbol = b"FEE_COIN";
    let name = b"FEE_COIN";
    let description = b"FEE_COIN";
    let icon_url = none<Url>();

    let (treasury, matadata) = create_currency(
        witness, 
        decimals, 
        symbol, 
        name, 
        description, 
        icon_url, 
        ctx
    );

    public_freeze_object(matadata);

    let supply = treasury_into_supply(treasury);

    let fee_coin_treasury_capacity = FeeCoinTreasuryCapacity { 
        id: object::new(ctx), 
        supply: supply
    };

    public_transfer(fee_coin_treasury_capacity, ctx.sender());
}

public fun mint(fee_coin_treasury_capacity: &mut FeeCoinTreasuryCapacity, amount: u64, ctx: &mut TxContext): Coin<FEE_COIN>{
    let supplyed_amount = balance::supply_value(&fee_coin_treasury_capacity.supply);
    let total_amount = supplyed_amount + amount;

    assert!(total_amount <= 10_000_000_000, ErrorOverflow);

    let balance = fee_coin_treasury_capacity.supply.increase_supply(amount);

    let coin = coin::from_balance(balance, ctx);
    
    coin
}


/// 转账 FEE_COIN 并收取手续费
public entry fun transfer_with_fee(sender: address, coin: &mut Coin<FEE_COIN>, recipient: address, amount: u64, fee: u64, fee_collector: address, ctx: &mut TxContext) {
    // 检查发送者是否为交易发起者
    assert!(sender == ctx.sender(), ErrorInsufficientBalance);

    // 检查余额是否足够支付转账金额和手续费
    let total_amount = amount + fee;
    let balance = coin::value(coin);

    assert!(balance >= total_amount, ErrorInsufficientBalance);

    // 拆分出转账金额
    let coin_to_send = coin::split(coin, amount, ctx);

    // 拆分出手续费
    let fee_coin = coin::split(coin, fee, ctx);

    // 将手续费转账给手续费收集地址
    public_transfer(fee_coin, fee_collector);

    // 将转账金额发送给接收者
    public_transfer(coin_to_send, recipient);

    // 如果有剩余零钱，已经保留在原始coin中，无需额外处理
}

/// 纯 SUI 转账并收取 SUI 手续费
public entry fun transfer_sui_with_fee(
    sender: address,
    sui_coin: &mut Coin<SUI>,       // 要转账的 SUI
    recipient: address,
    amount: u64,                    // 转账金额
    fee: u64,                       // 手续费金额
    fee_collector: address,         // 手续费接收地址
    ctx: &mut TxContext
) {
    // 检查发送者是否为交易发起者
    assert!(sender == ctx.sender(), ErrorInsufficientBalance);

    // 检查余额是否足够(金额+手续费)
    let total_amount = amount + fee;
    let balance = coin::value(sui_coin);

    assert!(balance >= total_amount, ErrorInsufficientBalance);

    // 拆分出要转账的金额
    let coin_to_send = coin::split(sui_coin, amount, ctx);

    // 拆分出手续费
    let fee_coin = coin::split(sui_coin, fee, ctx);

    // 发送手续费
    public_transfer(fee_coin, fee_collector);

    // 发送转账金额
    public_transfer(coin_to_send, recipient);

    // 剩余金额会自动保留在原始sui_coin中
}
