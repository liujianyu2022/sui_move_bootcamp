module abilities::store;

use std::string;
use std::string::String;

// store - 被修饰的值可以被存储到其他结构体
// 隐式允许对象的“值”被复制或移动（因为嵌套到其他对象中需要复制或转移所有权）

// 没有被store修饰，因此不能被存储到其他结构体里面
public struct Car1 {
    owner: String
} 

// 被store修饰，因此可以被存储到其他结构体里面
public struct Car2 has store {
    owenr: String
}


public struct Person has key {
    id: UID,
    // car1: Car1,         // 编译失败，因为Car1没有store，因此不能被存储到其他的结构体中
    car2: Car2,
}

