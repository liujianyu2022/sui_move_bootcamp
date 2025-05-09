
module coin_supply::hk;

use std::option::none;
use sui::url::Url;
use sui::transfer::{
    public_freeze_object,
    public_transfer,
    share_object
};
use sui::balance::Supply;
use sui::coin;
use sui::coin::Coin;

use sui::balance;
use sui::vec_set::VecSet;


public struct HK has drop {}

// HKTreasuryCapacity 这个结构体的存在是为了实现受控的货币供应管理，这是设计上的一个重要安全机制。
// HKTreasuryCapacity 是 Sui 上实现可控货币供应的标准模式，它：
// 持有 Supply<HK>（铸币权）。
// 通过对象所有权管理权限。
// 防止未经授权的增发。
// 如果直接允许 mint，会破坏货币的可信性和安全性
public struct HKTreasuryCapacity has key, store {
    id: UID,
    supply: Supply<HK>
}



const ErrorOverflow: u64 = 0x1;
const ErrorInsufficientBalance: u64 = 0x2;

fun init(witness: HK, ctx: &mut TxContext){
    let decimals = 6;
    let symbol = b"HK_Supply";
    let name = b"HK_Supply";
    let description = b"This is HK Supply";
    let icon_url = none<Url>();


    let (treasury, metadata) = coin::create_currency(
        witness, 
        decimals, 
        symbol, 
        name, 
        description, 
        icon_url, 
        ctx
    );

    public_freeze_object(metadata);

    // 在 Sui 中，Coin<HK> 的铸造（mint）必须通过 Supply<HK> 来完成。
    // Supply<HK> 是一个特殊的类型，代表该货币的“总供应量控制权”，它只能通过 create_currency 初始化后获得（存储在 treasury 中，后转换为 Supply）。
    // 如果没有 HKTreasuryCapacity，就无法持有或访问 Supply<HK>，也就无法调用 increase_supply 来铸造新币。
    let supply = coin::treasury_into_supply(treasury);

    let hk_treasury_capacity = HKTreasuryCapacity { 
        id: object::new(ctx), 
        supply: supply
    };

    // 只有 ctx.sender()（即部署合约的地址）才能获得 HKTreasuryCapacity，因此它是唯一拥有 mint 权限的地址
    public_transfer(hk_treasury_capacity, ctx.sender());


}

// mint 函数要求调用者必须持有 &mut HKTreasuryCapacity，所以只有拥有此对象的地址才能铸造代币
public fun mint(hk_treasury_capacity: &mut HKTreasuryCapacity, amount: u64, ctx: &mut TxContext): Coin<HK> {
    let supplyed_amount = balance::supply_value(&hk_treasury_capacity.supply);
    let total_amount = supplyed_amount + amount;

    assert!(total_amount <= 10_000_000_000, ErrorOverflow);

    let balance = hk_treasury_capacity.supply.increase_supply(amount);

    let coin = coin::from_balance(balance, ctx);

    coin
}

// 销毁指定数量（amount）的 Coin。原 coin 会被修改：其余额会减少 amount，但对象本身仍然有效
public fun burn(hk_treasury_capacity: &mut HKTreasuryCapacity, coin: &mut Coin<HK>, amount: u64, ctx: &mut TxContext) {

    assert!(coin.value() >= amount, ErrorInsufficientBalance); // 检查余额是否足够
    
    // split 会从输入的 &mut Coin<HK> 中分离出指定 amount 的新 Coin，原 coin 的余额会减少 amount
    // coin_to_burn 是一个新创建的 Coin，余额为 amount
    let coin_to_burn = coin::split(coin, amount, ctx);

    // 将 coin_to_burn 转换为 Balance 并销毁，仅减少总供应量 amount
    // 原 coin 的剩余部分（原余额 - amount）仍然存在（通过 &mut coin 引用保留）
    let balance_to_burn = coin::into_balance(coin_to_burn);

    hk_treasury_capacity.supply.decrease_supply(balance_to_burn);
}

// 完全销毁输入的 coin，并减少总供应量（减少量为 coin.value()）
// coin: Coin<HK>  直接传所有权
public fun burn_all(hk_treasury_capacity: &mut HKTreasuryCapacity, coin: Coin<HK>) {
    let balance = coin::into_balance(coin);
    hk_treasury_capacity.supply.decrease_supply(balance);
}


// Q：如果 amount == coin.value()，是否会完全销毁？
// A：逻辑上等价于销毁全部，但实现方式不同：
// 你的写法会先拆分出一个完整余额的 coin_to_burn，然后销毁它。
// 原 coin 的余额变为 0，但对象仍然存在（除非主动丢弃）。
// 总供应量减少 amount（效果与完全销毁一致）。


