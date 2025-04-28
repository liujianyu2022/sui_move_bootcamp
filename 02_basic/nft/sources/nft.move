
module nft::nft;
use std::string;
use std::string::String;
use sui::transfer::transfer;

public struct NFT has key {
    id: UID,
    name: String,
    image_url: String,
}

public entry fun mint(name: String, image_url: String, ctx: &mut TxContext){
    let nft = NFT{
        id: object::new(ctx),
        name: name,
        image_url: image_url,
    };

    transfer(nft, ctx.sender());
}

fun init(ctx: &mut TxContext){
    let name = string::utf8(b"name");
    let image_url = string::utf8(b"https://nimg.ws.126.net/?url=http%3A%2F%2Fdingyue.ws.126.net%2F2024%2F0511%2F99689e37j00sdb7l20021d000hs00lzg.jpg&thumbnail=660x2147483647&quality=80&type=jpg");
    mint(name, image_url, ctx);
}





