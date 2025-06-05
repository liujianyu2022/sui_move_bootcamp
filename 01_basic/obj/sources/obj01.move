module obj::obj01;

use std::string::String;

// 纯数据（Pure Struct）
// 只是一个普通的 struct，不涉及 Sui 的存储模型。
// 不能直接存储在 Sui 链上。通常用于临时计算或作为函数的参数/返回值。
public struct Person {
    name: String,
    age: u8
}


// Getter for Person
// 在 Sui Move 中（以及 Move 语言本身），结构体字段默认是私有的，外部模块是不能直接访问字段的，除非字段和结构体都定义在同一个模块中
// 在 Move 语言当前版本（包括 Sui 的扩展）中，没有办法将字段标为 public 以允许模块外访问。字段永远只能在其定义模块中访问。
public fun get_person_name(person: &Person): &String {
    &person.name
}

public fun get_person_age(person: &Person): u8 {
    person.age
}


// Sui 对象  代表链上的资产（如 NFT、代币、用户数据等）。
// has key：表示它是一个可以在 Sui 链上存储和管理的对象（资产）。
// id: UID：必须作为第一个字段，由 Sui 运行时自动分配唯一标识符（UID）。
// 可以被存储在 Sui 全局存储（Global Storage）中。
// 可以转移（Transfer）、共享（Shared） 或 冻结（Frozen）
// 可以被其他合约或用户交互（通过 TxContext 创建和管理）。
public struct PersonObject has key {
    id: UID,
    name: String,
    age: u8
}


// 在 Move（包括 Sui Move）中不支持函数重载，函数名在模块作用域中必须唯一，不能只靠参数类型区别。
public fun get_person_object_name(person_obj: &PersonObject): &String {
    &person_obj.name
}

public fun get_person_object_age(person_obj: &PersonObject): u8 {
    person_obj.age
}


public fun create_person(name: String, age: u8): Person {
    Person { name, age } // 只是返回一个结构体，不涉及链上存储
}

public fun create_person_object(ctx: &mut TxContext, name: String, age: u8): PersonObject {
    PersonObject {
        id: object::new(ctx),               // 必须分配 UID
        name,
        age
    }
}
