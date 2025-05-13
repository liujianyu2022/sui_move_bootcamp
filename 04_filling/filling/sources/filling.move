
module filling::filling;

use std::string::String;
use sui::transfer::{
    transfer,
    share_object
};
use sui::event;
use sui::table;
use sui::table::Table;

public struct State has key {
    id: UID,
    users: Table<address, address>      // owner, profile object
}

public struct Profile has key {
    id: UID,
    name: String,
    description: String
}
public struct ProfileCreated has copy, drop {
    id: ID,
    owner: address
}

const ErrorProfileExisted: u64 = 0x1;

fun init(ctx: &mut TxContext){
    let state = State { 
        id: object::new(ctx), 
        users: table::new(ctx)
    };

    share_object(state);
}

public entry fun create_profile(name: String, description: String, state: &mut State, ctx: &mut TxContext){
    let owner = ctx.sender();

    // 检查该用户是否已经创建Profile
    let isExisted = table::contains(&state.users, owner);
    assert!(!isExisted, ErrorProfileExisted);

    let uid = object::new(ctx);

    let id = object::uid_to_inner(&uid);

    let profile = Profile {
        id: uid,
        name,
        description,
    };

    transfer(profile, owner);

    table::add(&mut state.users, owner, object::id_to_address(&id));

    event::emit(ProfileCreated { id, owner })
}

public fun check_has_peofile(state: &State, user_address: address): Option<address>{
    if(table::contains(&state.users, user_address)){
        option::some(*table::borrow(&state.users, user_address))
    } else {
        option::none()
    }
}

#[test_only]
public fun init_for_testing(ctx: &mut TxContext){
    init(ctx)
}
