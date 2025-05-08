module error_debug::debug;

use std::string;
use std::string::String;
use std::debug::print;

public struct Person has drop{
    name: String
}

// 注意：debug的 print 功能只适用于本地开发调试
// 需要添加 #[test]
// 启动命令：sui move test
// 注意，#[test] 注释只能对不带参数的方法有效

#[test]
fun test_a(){
    let person = Person { 
        name: string::utf8(b"xiaoming")
    };

    print(&person);
}



