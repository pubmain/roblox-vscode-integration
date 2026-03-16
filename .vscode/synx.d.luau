--- Spoofs caller environment and context when calling `func` with `script`'s environment. You can pass as many arguments `args` as is required. Secure_call returns whatever the called function returns.
declare function secure_call<A..., R...>(func: (A...) -> R..., script: BaseScript | ModuleScript, ...: A...): R...

type CallStackEntry = {
    func: (...any) -> ...any,
    current_line: number,
} | {
    current_line: number,
    env: any,
    source: string,
    name: string,
    numparans: number,
    is_vararg: boolean,
}
type ThreadOptionEntry = { 
    script: BaseScript | ModuleScript | nil,
    identity: number?,
    env: any?,
    thread: thread
} | {
    script: BaseScript | ModuleScript,
    identity: number,
    env: any,
    thread: thread?
}
--- Proxy a call to a Lua function with the given call stack and thread options. `call_stack` is an array of tables, with each sub-table having fields described below.
--- 
--- The `thread` parameter allows you to preset the `script`, `identity`, and `env` fields with the values from that thread. This field is optional, and those fields can be overridden after the fact.
--- 
--- **Note**: These values do *not* need to correlate with actual information returned by debug.getinfo; they are fully customizable.
--- 
--- **Note**: The `func` parameter will override all other data you pass here aside from `currentline`!
declare function trampoline_call<A..., R...>(func: (A...) -> R..., call_stack: { CallStackEntry }, thread_options: { ThreadOptionEntry }, ...: A...): (boolean, R...)