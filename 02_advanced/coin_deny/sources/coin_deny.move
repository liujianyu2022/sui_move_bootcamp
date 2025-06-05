
module coin_deny::coin_deny;

use std::option;
use sui::coin::{create_regulated_currency_v2};
use sui::url::Url;

public struct COIN_DENY has drop {}


fun init(witness: COIN_DENY, ctx: &mut TxContext) {
    let (treasury, deny_cap, metadata) =
        create_regulated_currency_v2<COIN_DENY>(witness, 8, b"deny", b"deny", b"deny",
            option::none<Url>(),true, ctx);


    transfer::public_freeze_object(metadata);
    transfer::public_transfer(deny_cap, tx_context::sender(ctx));
    transfer::public_transfer(treasury, tx_context::sender(ctx));
}


