
module flashloan::flashloan;

use sui::balance::Balance;
use sui::sui::SUI;
use sui::coin;
use sui::coin::Coin;
use sui::balance;
use sui::transfer::{
    share_object,
    transfer
};

const ErrorInsufficient: u64 = 0x1;

public struct Admin has key {
    id: UID,
}

public struct Receipt{
    amount: u64
}

public struct FlashloanPool has key {
    id: UID,
    value: Balance<SUI>
}

public fun lend(pool: &mut FlashloanPool, amount: u64, ctx: &mut TxContext): (Coin<SUI>, Receipt) {
    let balance = pool.value.split(amount);                 // Splits balance from pool
    let sui_coin = coin::from_balance(balance, ctx);    // converts to spendable coin
    let repay_amount = amount + amount / 100;   // 1% fee
    let receipt = Receipt { 
        amount: repay_amount 
    };

    (sui_coin, receipt)
}

public fun repay(pool: &mut FlashloanPool, receipt: Receipt, pay: Coin<SUI>, ctx: &mut TxContext){
    let pay_amount = pay.value();

    assert!(pay_amount >= receipt.amount, ErrorInsufficient);

    let balance = coin::into_balance(pay);

    pool.value.join(balance);

    let Receipt {amount: _} = receipt;                  // Destroys the receipt
}


fun init(ctx: &mut TxContext){
    let flashlaon_pool = FlashloanPool{
        id: object::new(ctx),
        value: balance::zero()
    };

    share_object(flashlaon_pool);

    let admin = Admin { 
        id: object::new(ctx)
    };

    transfer(admin, ctx.sender());
}
