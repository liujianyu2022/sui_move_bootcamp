module filling::nft;

use std::string::{Self, String};
use sui::url::{Self, Url};
use sui::{event, dynamic_object_field, dynamic_field};
use std::type_name;
use std::type_name::TypeName;

const InvalidCategory: u64 = 1;

public struct Pet has key, store {
    id: UID,
    name: String,
    description: String,
    image: Url
}

public struct Toy has key, store {
    id: UID,
    name: String,
    description: String,
    image: Url
}

public struct Accessory has key, store {
    id: UID,
    name: String,
    description: String,
    image: Url
}

public struct NFTMinted has copy, drop {
    id: ID,
    owner: address,
    nft: address,
    category: String
}

// UID 必须被消费，因为它没有 drop 能力，不能隐式销毁
// String、Url 等可以不被消费，因为它们有 drop 能力，编译器会自动处理

public entry fun mint_nft(name: String, description: String, category: String, image: String, ctx: &mut TxContext){
    let owner = ctx.sender();
    let uid = object::new(ctx);
    let id = object::uid_to_inner(&uid);
    let object_address = object::uid_to_address(&uid);

    let valid_category = vector[string::utf8(b"Pet"), string::utf8(b"Toy"), string::utf8(b"Accessory")];
    assert!(vector::contains(&valid_category, &category), InvalidCategory);

    if (category == string::utf8(b"Pet")) {
        let nft = Pet {
            id: uid,  // uid is consumed here
            name,
            description,
            image: url::new_unsafe(string::to_ascii(image))
        };
        transfer::public_transfer(nft, owner);
    } else if (category == string::utf8(b"Toy")) {
        let nft = Toy {
            id: uid,  // uid is consumed here
            name,
            description,
            image: url::new_unsafe(string::to_ascii(image))
        };
        transfer::public_transfer(nft, owner);
    } else {
        let nft = Accessory {
            id: uid,  
            name,
            description,
            image: url::new_unsafe(string::to_ascii(image))
        };
        transfer::public_transfer(nft, owner);
    };

    event::emit(NFTMinted {
        id,
        owner,
        category,
        nft: object_address,
    });
}

public fun add_toy_or_accessory<T: key + store>(object: T, pet: &mut Pet, ctx: &mut TxContext){
    let owner = ctx.sender();
    let type_name = type_name::get<T>();

    let existed = dynamic_object_field::exists_(&pet.id, type_name);
    if(existed){
        let old_object = dynamic_object_field::remove<TypeName, T>(&mut pet.id, type_name);
        transfer::public_transfer(old_object, owner);
    };

    dynamic_object_field::add(&mut pet.id, type_name, object);
}

public fun check_if_pet_carries_toy_or_accessory<T>(pet: &Pet): bool {
    let type_name = type_name::get<T>();
    dynamic_object_field::exists_(&pet.id, type_name)
}


