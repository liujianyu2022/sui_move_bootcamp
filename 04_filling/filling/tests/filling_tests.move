#[test_only]
module filling::filling_tests;

use filling::filling::{Self, Profile, ProfileCreated, Folder};
use filling::nft::{Self, Pet, Toy, Accessory};
use sui::test_scenario::{Self};
use std::string::{Self, String};
use filling::filling::State;
use sui::test_utils::assert_eq;
use sui::coin;
use sui::sui::SUI;
use std::address::length;

// 测试函数没有参数和返回值
#[test]
fun test_create_profile(){

    // 测试场景设置
    let user: address = @0xa;
    let mut scenario_value = test_scenario::begin(user);                    // 开始一个测试场景
    let scenario = &mut scenario_value;                                        // 获取场景的可变引用，避免所有权被提前转移

    // 初始化测试环境
    filling::init_for_testing(test_scenario::ctx(scenario));                   // 调用被测试模块的初始化函数
    test_scenario::next_tx(scenario, user);                                 // 模拟开始一个新的事务

    // 准备测试数据
    let name = string::utf8(b"Bob");
    let description = string::utf8(b"This is description");

    // 执行被测试函数
    {   
        // 函数返回的是 T（所有权）                         转移对象所有权，不涉及可变性
        // 测试代码用 mut 接收是为了后续能获取 &mut 引用      声明可变的本地变量，允许后续修改
        // 可变性由变量声明决定，不是由函数返回
        let mut state = test_scenario::take_shared<State>(scenario);         // 使用 take_shared 获取共享对象
        filling::create_profile(
            name, 
            description, 
            &mut state, 
            test_scenario::ctx(scenario)
        );

        test_scenario::return_shared(state);                                                // 使用 return_shared 归还对象
    };

    // 验证事件
    let tx = test_scenario::next_tx(scenario, user);
    let expected_number_events = 1;
    assert_eq(
        test_scenario::num_user_events(&tx),                                     // 获取该交易中发出的用户定义事件数量
        expected_number_events
    );

    // 验证状态
    // 验证用户是否正确创建了profile
    // 验证profile对象是否正确转移给用户
    {
        let state = test_scenario::take_shared<State>(scenario);
        let profile = test_scenario::take_from_sender<Profile>(scenario);

        let expected = option::some(                             // option::some(value)	        创建 Some 包装	       Option<T>
            object::id_to_address(                                    // object::id_to_address(id)	将对象ID转为地址	    address
                object::borrow_id(&profile)                     // object::borrow_id(&profile)	获取对象的 ID 引用	    &ID           通过 borrow_id 避免所有权转移
                )
            );

        assert!(
            filling::check_has_peofile(&state, user) == expected,
            0
        );
        test_scenario::return_shared(state);
        test_scenario::return_to_sender(scenario, profile);
    };

    // 结束测试
    test_scenario::end(scenario_value);
}

#[test]
fun test_create_folder_wrap_coin(){
     // 测试场景设置
    let user: address = @0xa;
    let mut scenario_value = test_scenario::begin(user);                    // 开始一个测试场景
    let scenario = &mut scenario_value;                                        // 获取场景的可变引用，避免所有权被提前转移

    // 初始化测试环境
    filling::init_for_testing(test_scenario::ctx(scenario));                   // 调用被测试模块的初始化函数
    test_scenario::next_tx(scenario, user);                                 // 模拟开始一个新的事务

    // 准备测试数据
    let name = string::utf8(b"Bob");
    let description = string::utf8(b"This is description");

    // 执行被测试函数
    {   
        let mut state = test_scenario::take_shared<State>(scenario);         // 使用 take_shared 获取共享对象
        filling::create_profile(
            name, 
            description, 
            &mut state, 
            test_scenario::ctx(scenario)
        );

        test_scenario::return_shared(state);                                                // 使用 return_shared 归还对象
    };

    test_scenario::next_tx(scenario, user);
    {
        let mut profile = test_scenario::take_from_sender<Profile>(scenario);
        filling::create_folder(
            string::utf8(b"folder 01"),
            string::utf8(b"folder 01"),
            &mut profile,
            test_scenario::ctx(scenario)
        );

        test_scenario::return_to_sender(scenario, profile);
    };

    test_scenario::next_tx(scenario, user);
    {
        let mut folder = test_scenario::take_from_sender<Folder>(scenario);
        let coin = coin::mint_for_testing<SUI>(1000, test_scenario::ctx(scenario));

        filling::add_coin_to_folder<SUI>(
            &mut folder, 
            coin, 
            test_scenario::ctx(scenario)
        );

        test_scenario::return_to_sender(scenario, folder);
    };

    test_scenario::next_tx(scenario, user);
    {
        let folder = test_scenario::take_from_sender<Folder>(scenario);
        assert_eq(
            filling::get_balance<SUI>(&folder), 
            1000
        );
        test_scenario::return_to_sender(scenario, folder);
    };

    // 结束测试
    test_scenario::end(scenario_value);
}

#[test]
fun test_create_folder_wrap_nft(){
    let user = @0xa;
    let mut scenario_value = test_scenario::begin(user);
    let scenario = &mut scenario_value;

     // 初始化测试环境
    filling::init_for_testing(test_scenario::ctx(scenario));                   // 调用被测试模块的初始化函数
    test_scenario::next_tx(scenario, user);                                 // 模拟开始一个新的事务

    // 准备测试数据
    let name = string::utf8(b"Bob");
    let description = string::utf8(b"This is description");

    // 执行被测试函数
    {   
        let mut state = test_scenario::take_shared<State>(scenario);         // 使用 take_shared 获取共享对象
        filling::create_profile(
            name, 
            description, 
            &mut state, 
            test_scenario::ctx(scenario)
        );

        test_scenario::return_shared(state);                                                // 使用 return_shared 归还对象
    };

    test_scenario::next_tx(scenario, user);
    {
        let mut profile = test_scenario::take_from_sender<Profile>(scenario);
        filling::create_folder(
            string::utf8(b"folder 01"),
            string::utf8(b"folder 01"),
            &mut profile,
            test_scenario::ctx(scenario)
        );

        test_scenario::return_to_sender(scenario, profile);
    };

    test_scenario::next_tx(scenario, user);
    {
        let name = string::utf8(b"dog");
        let description: String = string::utf8(b"dog");
        let category = string::utf8(b"Pet");
        let image = string::utf8(b"image_url");
        let ctx = test_scenario::ctx(scenario);

        nft::mint_nft(
            name, 
            description, 
            category, 
            image, 
            ctx
        );
    };

    test_scenario::next_tx(scenario, user);
    let pet_nft_object_address;
    {
        let mut folder = test_scenario::take_from_sender<Folder>(scenario);
        let pet_nft = test_scenario::take_from_sender<Pet>(scenario);

        pet_nft_object_address = object::id_to_address(
            object::borrow_id(&pet_nft)
        );

        let ctx = test_scenario::ctx(scenario);

        filling::add_nft_to_folder(
            &mut folder, 
            pet_nft, 
            ctx
        );

        test_scenario::return_to_sender(scenario, folder);
    };

    test_scenario::next_tx(scenario, user);
    {
        let folder = test_scenario::take_from_sender<Folder>(scenario);

        assert_eq(
            filling::check_has_nft(&folder, pet_nft_object_address),
            true
        );

        test_scenario::return_to_sender(scenario, folder);
    };

    test_scenario::end(scenario_value);
}


// test_scenario::begin() - 开始测试场景

// test_scenario::next_tx() - 模拟新事务

// test_scenario::take_shared() - 获取共享对象

// test_scenario::return_shared() - 归还共享对象

// test_scenario::take_from_sender() - 获取发送者的对象

// test_scenario::return_to_sender() - 归还对象给发送者

// test_scenario::num_user_events() - 获取事件数量

// assert!() 和 assert_eq!() - 断言
