
#[test_only]
module filling::filling_tests;

use filling::filling::{Self, State, Profile};
use sui::test_scenario::{Self};
use std::string::{Self, String};
use std::unit_test::assert_eq;


#[test]
fun test_create_profile(){
    let user = @0x001;
    let mut scenario_value = test_scenario::begin(user);
    let scenario = &mut scenario_value;

    let ctx = test_scenario::ctx(scenario);
    filling::init_for_testing(ctx);

    test_scenario::next_tx(scenario, user);
    let name = string::utf8(b"Bob");
    let description = string::utf8(b"hello");
    {
        let mut state = test_scenario::take_shared<State>(scenario);
        filling::create_profile(name, description, &mut state, ctx);

        test_scenario::return_shared(state);
        
    };

    let tx = test_scenario::next_tx(scenario, user);
    let expected_events = 1;
    assert_eq!(test_scenario::num_user_events(&tx), expected_events);

    {
        let state = test_scenario::take_shared<State>(scenario);
        let profile = test_scenario::take_from_sender<Profile>(scenario);

        let profile_id = object::borrow_id(&profile);

        assert_eq!(filling::check_has_peofile(&state, user), option::some(object::id_to_address(profile_id)));
        test_scenario::return_shared(state);
        test_scenario::return_to_sender(scenario, profile);
    };

    test_scenario::end(scenario_value);
}
