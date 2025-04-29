
module abilities::copy_drop;

use sui::event::emit;                       // 用于在链上输出日志

public struct Log has copy, drop {
    number: u64
}

fun init(_ctx: &mut TxContext){
    let log = Log{
        number: 10
    };

    emit(log);
}


