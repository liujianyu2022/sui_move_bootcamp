
module flip_coin::flip_coin;

use sui::balance::Balance;
use sui::sui::SUI;
use sui::balance;
use sui::transfer::{
    transfer,
    public_transfer,
    share_object,
};
use sui::random;
use sui::random::Random;

use sui::coin::Coin;
use sui::coin;


public struct Game has key {
    id: UID,
    amount: Balance<SUI>                // 在合约中存入资产，都需要使用Balance
}


public struct Admin has key {
    id: UID,
}

// const SUI_RANDOM_ID: address = @0x8;
// 只要涉及到随机数的方法，都不可以添加 public
entry fun play(game: &mut Game, random: &Random, guess_result: bool, in_coin: Coin<SUI>, ctx: &mut TxContext){
    // 正面 --> true         反面 --> false

    let in_amount = in_coin.value();
    let game_amount = game.amount.value();

    // 用户输入的值必须小于池子里面的钱，并且每次最多只能输入池子的 10分之一
    assert!(game_amount >= in_amount * 10, 0x111);

    // Generate a boolean.
    // public fun generate_bool(g: &mut RandomGenerator): bool 

    let mut random_generator = random::new_generator(random, ctx);
    let random_value = random::generate_bool(&mut random_generator);

    if(guess_result == random_value){
        let reward_balance = game.amount.split(in_amount);
        let reward_coin = coin::from_balance(reward_balance, ctx);

        public_transfer(in_coin, ctx.sender());
        public_transfer(reward_coin, ctx.sender())
    } else {
        // 输了就没了
        let in_balance = coin::into_balance(in_coin);
        game.amount.join(in_balance);
    }

}

// coin::into_balance  Coin 被转换为 Balance 后，原始 Coin 会被销毁，确保资金不会凭空复制或消失
public entry fun deposit_sui(game: &mut Game, in_coin: Coin<SUI>){
    let in_amount = coin::into_balance(in_coin);                // 将可流通的Coin转换为内部记账的Balance
    game.amount.join(in_amount);
}

public entry fun withdraw_sui(_: &Admin, game: &mut Game, amount: u64, ctx: &mut TxContext){
    let out_balance = game.amount.split(amount);
    let out_coin = coin::from_balance(out_balance, ctx);
    public_transfer(out_coin, ctx.sender());                    // Sui的安全转移方法
}


fun init(ctx: &mut TxContext){
    let game = Game { 
        id: object::new(ctx), 
        amount: balance::zero()
    };
    share_object(game);                 // 选择所有权的时候 所以人都可以玩

    let admin = Admin { id: object::new(ctx) };
    transfer(admin, ctx.sender());
}


// 游戏回顾
// 第一 你必须掌握怎么存钱      Coin    ->  Balance
// 第二 你必须掌握怎么取钱      Balance ->  Coin
// 第三 就是你要学会怎么交换
