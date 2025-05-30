
module filling::filling;

use std::string::String;
use sui::transfer::{
    transfer,
    share_object
};
use sui::event;
use sui::table::{Self, Table} ;
use sui::coin::{Self, Coin};
use sui::dynamic_field;
use std::type_name::{Self, TypeName};
use sui::balance::{Self, Balance};

use std::ascii::{String as AString};

public struct State has key {
    id: UID,
    users: Table<address, address>      // <owner, profile object>
}

public struct Profile has key {
    id: UID,
    name: String,
    description: String,
    folders: vector<address>
}

public struct Folder has key {
    id: UID,
    name: String,
    description: String,
    // dynamic field
    // sui
    // usdc
}

// Event
public struct ProfileCreated has copy, drop {
    id: ID,
    owner: address
}

public struct FolderCreated has copy, drop {
    id: ID,
    owner: address,
}

public struct CoinWrapped has copy, drop {
    folder: address,
    coin_type: AString,
    amount: u64,
    new_balance: u64
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
        folders: vector::empty()
    };


    transfer(profile, owner);

    table::add(&mut state.users, owner, object::id_to_address(&id));

    event::emit(ProfileCreated { id, owner })
}

public entry fun create_folder(name: String, description: String, profile: &mut Profile, ctx: &mut TxContext){
    let owner = ctx.sender();
    let uid = object::new(ctx);
    let id = object::uid_to_inner(&uid);
    let folder = Folder {
        id: uid,
        name,
        description,
    };

    transfer(folder, owner);

    vector::push_back(&mut profile.folders, object::id_to_address(&id));

    event::emit(FolderCreated { id, owner });

}

public entry fun add_coin_to_folder<T>(folder: &mut Folder, coin: Coin<T>, ctx: &mut TxContext){
    let type_name = type_name::get<T>();
    let amount = coin::value(&coin);
    let total: u64;

    if(dynamic_field::exists_(&folder.id, type_name)){
        let old_value = dynamic_field::borrow_mut<TypeName, Balance<T>>(&mut folder.id, type_name);
        balance::join(old_value, coin::into_balance(coin));
        total = balance::value(old_value);
    } else {
        dynamic_field::add(
            &mut folder.id, 
            type_name, 
            coin::into_balance(coin)
        );
        total = amount;
    };
    
    event::emit(CoinWrapped {
        folder: object::uid_to_address(&folder.id),
        coin_type: type_name::into_string(type_name),
        amount,
        new_balance: total,
    })
}


public fun check_has_peofile(state: &State, user_address: address): Option<address>{
    if(table::contains(&state.users, user_address)){
        option::some(*table::borrow(&state.users, user_address))
    } else {
        option::none()
    }
}

public fun get_balance<T>(folder: &Folder): u64{
    let type_name = type_name::get<T>();
    let existed = dynamic_field::exists_(&folder.id, type_name);

    if(existed){
        let balance = dynamic_field::borrow<TypeName, Balance<T>>(&folder.id, type_name);
        balance::value(balance)
    }else{
        0
    }
}

#[test_only]
public fun init_for_testing(ctx: &mut TxContext){
    init(ctx)
}
