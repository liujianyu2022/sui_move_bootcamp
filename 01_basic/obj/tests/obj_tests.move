
// #[test_only]
// module obj::obj_tests;

// use std::string;
// use sui::test_scenario;
// use obj::obj;

// #[test]
// fun test_create_person() {
//     let name = string::utf8(b"Alice");
//     let age = 25u8;

//     let person = obj::create_person(name, age);
//     assert!(person.age == 25, 1);
// }

// #[test]
// fun test_create_person_object() {
//     let scenario = test_scenario::begin(@0x123);
//     let ctx = test_scenario::ctx(&mut scenario);
    
//     let name = string::utf8(b"Bob");
//     let age = 30u8;

//     let person_obj = obj::create_person_object(ctx, name, age);
    
//     assert!(person_obj.age == 30, 1);
//     test_scenario::end(scenario);
// }

