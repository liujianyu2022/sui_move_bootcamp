
module generics_enums::generics;

// 泛型的第一个作用就是 消除模板代码
// 泛型的第二个作用就是 兼容未来的数据类型
// 泛型的第三个作用 这种未被使用的泛型 主要的类型关联

// 结构体范型
public struct Box1<T>{
    price: T,
}

public struct Box2<T, Z>{
    price: T,
    owner: Z 
}

// 方法范型
fun create_box1<T>(price: T): Box1<T>{
    Box1{
        price
    }
}

// phantom 范型
// 由于 范型T 未使用，因此需要添加 phantom 以示标记
public struct Balance<phantom T> has store {
    value: u64
}

public struct Coin<T> has key, store {
    id: UID,
    balance: Balance<T>
}


