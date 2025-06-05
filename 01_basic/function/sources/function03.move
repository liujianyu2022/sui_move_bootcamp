
module function::function03;

// init 方法
// 只能是私有的
// 会在发布合约的时候自动调用一次
// 写法固定，只有两种写法

// 写法1：
// fun init(ctx: &mut TxContext){

// }

// 写法2：
public struct FUNCTION03 has drop {}
fun init(witness: FUNCTION03, ctx: &mut TxContext){
    
}


