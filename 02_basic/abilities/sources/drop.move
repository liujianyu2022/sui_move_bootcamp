
module abilities::drop;

use std::string;
use std::string::String;

public struct Car1 {

}

public struct Car2 has drop {

}

public struct Person1 {}

public struct Person2 has drop {
    name: String,               // String 和 基本数据类型 默认已经添加了drop
    age: u8,
    // car1: Car1,              // 编译报错，因为可以被drop的对象，里面所有的属性都必须是可以被drop的
    car2: Car2,
}

fun init(ctx: &mut TxContext){

    // let person1 = Person1{}      编译报错，因为没有被 drop 修饰的变量在函数执行后无法被 drop

    let person2 = Person2 {
        name: string::utf8(b"xiaoming"),
        age: 18,
        car2: Car2{},
    };
}




