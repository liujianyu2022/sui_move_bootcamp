module hello_move::hello ;

use sui::transfer::transfer;
use std::string;
use std::string::String;

public struct Hello has key {
    id: UID,
    say: String
}


fun init(ctx: &mut TxContext) {
    let hello_move = Hello {
        id: object::new(ctx),
        say: string(b"move your github id"),
    };
    transfer(hello_move, ctx.sender());
}

