
module swap_usd_rmb::swap_usd_rmb;

use sui::transfer::{
    share_object,
    transfer
};

public struct Bank has key {
    id: UID,
    usd: Balance<USD>,
    rmb: Balance<RMB>
}

public struct Admin has key {
    id: UID
}

fun init(ctx: &mut TxContext){
    let bank = Bank{
        id: object::new(ctx),
        rmb: balance::zero(),
        usd: balance::zero()
    };

    share_object(bank);

    let admin = Admin{
        id: object::new(ctx)
    };
    transfer(admin, ctx.sender());
}