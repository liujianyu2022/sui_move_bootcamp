
module obj::obj02;

use sui::object;
use sui::transfer::{
    transfer,
    public_transfer,
    share_object,
    freeze_object
};

// 所有权：
// 独享所有权：某个对象地址单独拥有
// 共享所有权：全局对象共享

// 下面是独享所有权的案例
public struct Money1 has key{
    id: UID,
    amount: u64,
}
public struct Money2 has key, store {
    id: UID,
    amount: u64,
}

// 下面是共享所有权的案例
public struct Bus has key {
    id: UID,
    passagers: u64,

}

// bus: &Bus            共享所有权的权限：read
fun checkPassager(bus: &Bus, ctx: &mut TxContext){
    let passagers = bus.passagers;

}

// bus: &mut Bus        共享所有权的权限：write、read
fun addPassager(bus: &mut Bus, ctx: &mut TxContext){
    bus.passagers = bus.passagers + 1;
}

// bus: Bus             独享所有权的权限：transfer、delete、write、read
fun chasePassager(bus: Bus, ctx: &mut TxContext) {
    transfer(bus, @0x123);                      // giving ownership to someone
                                                                // bus 也可以什么都不做（让它 drop）
}



fun init(ctx: &mut TxContext){
    let money1 = Money1 { 
        id: object::new(ctx), 
        amount:100,
    };

    let money2 = Money2 { 
        id: object::new(ctx),
        amount: 200
    };

    transfer(money1, ctx.sender());             // transfer 适用于只有 key 的对象 
    public_transfer(money2, ctx.sender());      // public_transfer 适用于 key + store 的对象


    let bus1 = Bus { 
        id: object::new(ctx), 
        passagers: 0,
    };

    share_object(bus1);


    let bus2 = Bus {
        id: object::new(ctx), 
        passagers: 0,
    };
    transfer(bus2, ctx.sender());



    let bus3 = Bus {
        id: object::new(ctx), 
        passagers: 0,
    };
    freeze_object(bus3);                                    // 共享对象——常量
}

// 总结：
// public： 需要有 store 字段
// transfer： 独享对象
// share_object：共享对象
// freeze_object：共享对象——常量
