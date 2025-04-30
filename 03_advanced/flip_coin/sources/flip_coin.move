
module flip_coin::flip_coin;

use sui::balance::Balance;
use sui::sui::SUI;
use sui::balance;
use sui::transfer::share_object;
use sui::transfer::transfer;
use sui::random::Random;
use sui::coin::Coin;
use sui::coin;
use sui::transfer::public_transfer;

public struct Game has key {
    id: UID,
    amount: Balance<SUI>
}


public struct Admin has key {
    id: UID,
}

entry fun play(game: &mut Game, random: &Random){

}

// coin::into_balance  Coin 被转换为 Balance 后，原始 Coin 会被销毁，确保资金不会凭空复制或消失
public entry fun deposit_sui(game: &mut Game, in_coin: Coin<SUI>){
    let in_amount = coin::into_balance(in_coin);                // 将可流通的Coin转换为内部记账的Balance
    game.amount.join(in_amount);
}

public entry fun withdraw_sui(game: &mut Game, amount: u64, ctx: &mut TxContext){
    let out_balance = game.amount.split(amount);
    let out_coin = coin::from_balance(out_balance, ctx);
    public_transfer(out_coin, ctx.sender());                    // Sui的安全转移方法
}


fun init(ctx: &mut TxContext){
    let game = Game { 
        id: object::new(ctx), 
        amount: balance::zero()
    };

    share_object(game);

    let admin = Admin { id: object::new(ctx) };

    transfer(admin, ctx.sender());
}

