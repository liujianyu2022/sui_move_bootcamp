
module abilities::key;

use std::string;
use std::string::String;

use sui::transfer::{
    transfer,
};

// 纯数据（Pure Struct）
// 只是一个普通的 struct，不涉及 Sui 的存储模型。
// 不能直接存储在 Sui 链上。通常用于临时计算或作为函数的参数/返回值。
public struct Person {
    name: String,
    age: u8
}

// Sui 对象  代表链上的资产（如 NFT、代币、用户数据等）。
// has key：表示它是一个可以在 Sui 链上存储和管理的对象（资产）。
// id: UID：必须作为第一个字段，由 Sui 运行时自动分配唯一标识符（UID）。
// 可以被存储在 Sui 全局存储（Global Storage）中。
// 可以转移（Transfer）、共享（Shared） 或 冻结（Frozen）
// 可以被其他合约或用户交互（通过 TxContext 创建和管理）。
// 必须通过自定义函数转移（如 `transfer::transfer(obj, to)`）
public struct PersonObject has key {
    id: UID,
    name: String,
    age: u8,
}


public entry fun mint_person_object(ctx: &mut TxContext){
    let person_object = PersonObject{
        id: object::new(ctx),
        name: string::utf8(b"xiaoming"),
        age: 18
    };

    transfer(person_object, ctx.sender());
}

// 自定义转移规则
public entry fun transfer_person_object(obj: PersonObject, to: address){
    if(obj.age < 18) abort 0;

    transfer(obj, to);
}

