module generics_enums::enums;

public enum Action1 has store {
    Stop,
    Move {
        x: u64,
        y: u64
    }
}

public enum Action2 has store {
    Up,
    Down,
    Left,
    RIGTH,
}

public fun handle(action: &Action2){
    
    // 类似于switch
    match(action){
        Action2::Up => {

        },

        Action2::Down => {

        },

        // 剩余的分支情况
        _ => {

        }
    }
}
