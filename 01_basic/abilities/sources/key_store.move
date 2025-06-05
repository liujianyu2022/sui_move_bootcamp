
module abilities::key_move;

use sui::transfer::{
    transfer,
    public_transfer
};

// key 和 store 的组合触发了 Sui 的“自由资产”规则：
// - key 能力：表示对象是全局唯一的资产（拥有 UID），可以独立存在。
// - store 能力：表示对象可以被嵌套或解构（即其值可以被自由重组）。

// 当两者结合时，Sui 运行时（runtime）会将此类对象视为：
// - 完全自包含的资产（不需要依赖外部逻辑管理其生命周期）。
// - 值语义可自由重组（可以被随意转移、嵌套或解构，无需通过自定义逻辑）。

// 因此，key + store 的组合实际上隐式声明了对象是一个“隐式声明了对象是一个“无约束的可转移实体”，从而绕过类型的自定义转移规则


 // 1. 只有 `key` 能力的对象（受限转移）
public struct LockedItem has key {
    id: UID,
    owner: address
}

// 2. 有 `key + store` 能力的对象（自由转移）
public struct FreeItem has key, store {
    id: UID
}


// 自定义转移函数：只有管理员可以转移 LockedItem
public fun transfer_locked_item(mut item: LockedItem, new_owner: address, _ctx: &mut TxContext) {
    // 检查权限（这里简化逻辑，实际可能用 `sender` 验证）
    assert!(item.owner == @abilities, 0);

    // 修改所有者
    item.owner = new_owner;

    // 使用 Sui 的转移函数
    transfer(item, new_owner);
}

// FreeItem 无需自定义逻辑，可以直接用 Sui 原生方法转移
public fun mint_free_item(ctx: &mut TxContext) {
    let item = FreeItem { 
        id: object::new(ctx) 
    };

    public_transfer(item, ctx.sender());
}
