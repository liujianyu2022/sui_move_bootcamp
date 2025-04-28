
module function::function01;

// 私有方法，只能在本模块中使用
fun private_fn(){

}

// 公开的方法，可以在其他包和其他模块中调用
public fun public_fn(){

}

// 带package的公开方法，只能在本包中使用（本模块和本包中的其他模块），在其他包中无法使用
public(package) fun public_package_fn(){

} 

// 全部合约（也就是其他的包）和Dapp（命令行和前端）可以调用，无返回值
public entry fun public_entry_fn(){

}

// Dapp（命令行和前端）可以调用，无返回值
entry fun entry_fn(){

}
// 总结：
// public：控制其他的包（也就是其他的合约）是否可以调用。可以有返回值
// entry：控制Dapp（也就是命令行和前端）是否可以调用。没有返回值

