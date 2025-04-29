
module error_debug::error;

const Error1: u64 = 0x1;
const Error2: u64 = 0x2;


public entry fun input1(number: u64): u64 {
    if(number > 10){
        number * 2
    }else{
        abort Error1
    }
}

public entry fun input2(number: u64): u64 {
    assert!(number > 10, Error1);

    number * 2
}




