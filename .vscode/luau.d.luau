type userdata = typeof(newproxy())
type AnyFunction = (...any) -> (...any)
type AnyTable = { [any]: any }

declare function setclipboard(value: string): ()

declare game: {
    HttpGet: (self: DataModel, url: string) -> string,
    HttpGetAsync: (self: DataModel, url: string) -> string,
    HttpPost: (self: DataModel, url: string, body: string) -> string,
    HttpPostAsync: (self: DataModel, url: string, body: string) -> string
} & DataModel

--- returns a boolean indicating whether the **current function was invoked from the executor's own thread**. This is useful for differentiating between your own calls and those made by the game.
---
--- It is often used in `hookfunction` and/or `hookmetamethod`.
declare function checkcaller(): boolean
--- creates and returns a new function that has the exact same behaviour as the passed function.
declare function clonefunction<A..., R...>(functionToClone: (A...) -> R...): (A...) -> R...
--- returns the ***hex-represented*** [SHA384 hash](https://en.wikipedia.org/wiki/SHA-2) of a provided function's instructions (code) and constants.
declare function getfunctionhash(functionToHash: AnyFunction): string
--- allows you to hook a function with another wanted function, returning the original unhooked function.
declare function hookfunction<A1..., R1..., A2..., R2...>(functionToHook: (A1...) -> R1..., hook: (A2...) -> R2...): (A1...) -> R1...
--- takes any Luau object that can have a metatable, and attempts to hook the specified metamethod of the object. Internally, it essentially uses [`#!luau hookfunction`](./hookfunction.md) to hook specific metamethods.
declare function hookmetamethod(object: { any: any } | Instance | userdata, metamethodName: string, hook: AnyFunction): AnyFunction
--- checks whether a given function is a C closure or not.
declare function iscclosure(func: AnyFunction): boolean
--- checks whether a given function is a closure of the executor. This also includes closures retrieved using `getscriptclosure` or `loadstring`
declare function isexecutorclosure(func: AnyFunction): boolean
--- checks whether a given function is a Luau closure or not.
declare function islclosure(func: AnyFunction): boolean
--- takes any Luau function and wraps it into a C closure. When the returned function is called, it invokes the original Luau closure with the provided arguments, then passes the closure's returned values back to the caller.
declare function newcclosure<A..., R...>(functionToWrap: (A...) -> R...): (A...) -> R...
--- restores a hooked function back to the very first original function, even if it has been hooked multiple times.
declare function restorefunction(functionToRestore: AnyFunction): ()

declare debug: {
    --- returns the constant at the specified index from a Luau function. If no constant exists at that index, it returns nil instead.
    --- 
    --- This is useful when you want to inspect specific constant values (such as strings, numbers, or booleans) without dumping the entire list.
    getconstant: (func: AnyFunction, index: number) -> number | string | boolean | nil,
    --- returns a list of all constants used within a Luau function's bytecode. This includes literal values like numbers, strings, booleans, and nil.
    getconstants: (func: AnyFunction | number) -> { number | string | boolean | nil },
    --- returns a specific function prototype from a Luau function by index. Optionally, it can search for active functions of the proto, if the activated parameter is set to true.
    --- 
    --- These are internal function definitions (e.g. nested functions) that exist as part of the compiled bytecode, even if they aren't assigned or called.
    getproto: (func: AnyFunction | number, index: number, activated: boolean?) -> (AnyFunction) | { AnyFunction },
    --- returns all function prototypes defined within the specified Luau function.
    --- 
    --- These are internal function definitions (e.g. nested functions) that exist as part of the compiled bytecode, even if they aren't assigned or called.    
    getprotos: (func: AnyFunction | number) -> { AnyFunction },
    --- retrieves values from the stack at the specified call level.
    --- 
    --- This function is useful for inspecting local variables or arguments at different layers of the stack frame. If no index is given, all values at that stack level are returned as a list.
    getstack: (level: number, index: number?) -> any | { any },
    --- returns the upvalue at the specified index from a Luau function's closure. If the index is invalid or out of bounds, an error will occur.
    getupvalue: (func: AnyFunction | number, index: number) -> any,
    --- returns a list of upvalues captured by a Luau function. These are the external variables that a function closes over from its surrounding scope.
    --- 
    --- If the function has no upvalues, the result will be an empty table.
    getupvalues: (func: AnyFunction | number) -> { any },
    --- modifies a constant at the specified index in a Luau function bytecode.
    --- 
    --- This can be used to change hardcoded behavior within functions without modifying their source code - although it requires knowing the correct constant index beforehand.
    setconstant: (func: AnyFunction | number, index: number, value: number | string | boolean | nil) -> (),
    --- replaces a value in a specified stack frame.
    --- 
    --- This allows for powerful manipulation of runtime variables or arguments, particularly useful in advanced debugging or dynamic patching scenarios.
    setstack: (level: number, index: number, value: any) -> (),
    --- replaces an upvalue at the specified index in a Luau function, with a new value.
    --- 
    --- This allows for controlled modification of function state, often used in hooking or testing environments.
    setupvalue: (func: AnyFunction | number, index: number, value: any) -> (),
} & typeof(debug)

export type DrawingFont = number
declare class Drawing
    Visible: boolean
    ZIndex: number
    Transparency: number
    Color: Color3
    __OBJECT_EXISTS: boolean

    function Destroy(self): ()
end

declare class Line extends Drawing
    From: Vector2
    To: Vector2
    Thickness: number
end

declare class Text extends Drawing
    Text: string
    TextBounds: Vector2
    Font: DrawingFont
    Size: number
    Position: Vector2
    Center: boolean
    Outline: boolean
    OutlineColor: Color3
end

declare class Image extends Drawing
    Data: string
    Size: Vector2
    Position: Vector2
    Rounding: number
end

declare class Circle extends Drawing
    NumSides: number
    Radius: number
    Position: Vector2
    Thickness: number
    Filled: true
end

declare class Square extends Drawing
    Size: Vector2
    Position: Vector2
    Thickness: number
    Filled: true
end

declare class Quad extends Drawing
    PointA: Vector2
    PointB: Vector2
    PointC: Vector2
    PointD: Vector2
    Thickness: number
    Filled: true
end

declare class Triangle extends Drawing
    PointA: Vector2
    PointB: Vector2
    PointC: Vector2
    Thickness: number
    Filled: true
end


declare Drawing: {
    new: ((type: "Line") -> Line) &
        ((type: "Text") -> Text) &
        ((type: "Image") -> Image) &
        ((type: "Circle") -> Circle) &
        ((type: "Square") -> Square) &
        ((type: "Quad") -> Quad) &
        ((type: "Triangle") -> Triangle),
    Fonts: {
        UI: number,
        System: number,
        Plex: number,
        Monospace: number
    }
}

--- removes all active drawing objects created with `Drawing.new`
declare function cleardrawcache(): ()
--- retrieves the value of a property from a `Drawing` object. This behaves identically to using `object[property]`, but is useful when working with dynamic property names or for reflection-like access.
declare function getrenderproperty(drawing: Drawing, property: string): any
--- checks whether a given value is a valid `Drawing` object.
--- 
--- This is useful for validation in functions or modules that work with custom render systems.
declare function isrenderobj(object: any): boolean
--- assigns a value to a property of a `Drawing` object. This behaves identically to `object[property] = value`, but is useful for dynamic or abstracted property access.
declare function setrenderproperty(drawing: Drawing, property: string, value: any): ()

--- decodes a [Base64-encoded](https://en.wikipedia.org/wiki/Base64) string back into its original form.
declare function base64decode(data: string): string
--- encodes a string with [Base64](https://en.wikipedia.org/wiki/Base64) encoding.
declare function base64encode(data: string): string
--- compresses a string with the [LZ4](https://en.wikipedia.org/wiki/LZ4_(compression_algorithm)) compression algorithm.
declare function lz4compress(data: string): string
---  decompresses a string that was encoded using the [LZ4](https://en.wikipedia.org/wiki/LZ4_(compression_algorithm)) compression algorithm back to regular data.
declare function lz4decompress(data: string): string

--- returns a list of non-dead garbage-collectable values. These include functions, userdatas, and optionally tables.
declare getgc:
    ((includeTables: true) -> { { AnyTable } | AnyFunction | userdata }) &
    ((includeTables: false?) -> { AnyFunction })
--- returns the executor's global environment table, which is shared across all executor-made threads.
--- 
--- This environment is writable and persistent during the session, making it useful for sharing state or functions across different scripts.
declare function getgenv(): { [any]: any }
--- returns the **Luau registry table**. The registry is a special table which is used internally to store references like threads, functions, and data shared between C and Luau (userdata).
declare function getreg(): { [any]: any }
--- returns the **Roblox global environment**, which is used by the entire game. Changes to this environment will affect your executor environment as well.
declare function getrenv(): { [any]: any }

export type FunctionFilterOptions = {
    Name: string?,
    IgnoreExecutor: boolean?,
    Hash: string?,
    Constants: { any }?,
    Upvalues: { any }?,
}

export type TableFilterOptions = {
    Keys: { any }?,
    Values: { any }?,
    KeyValuePairs: { [any]: any }?,
    Metatable: { [string]: AnyFunction | string } ?
}

--- allows you to retrieve specific garbage-collected values from Luau's memory, using fine-tuned filters.
--- 
--- This function is most often used to find game-defined functions or internal tables by matching constants, keys, metatables, and more. It behaves similarly to `getgc`, but offers simplicity, efficiency, and more control over what gets returned.
declare filtergc: 
    (( filterType: "function", filterOptions: FunctionFilterOptions, returnOne: true) -> AnyFunction? ) &
    ((( filterType: "function", filterOptions: FunctionFilterOptions, returnOne: false?) -> ( AnyFunction | { AnyFunction } ) )) &
    (( filterType: "table", filterOptions: TableFilterOptions, returnOne: true) -> { AnyTable? } ) &
    (( filterType: "table", filterOptions: TableFilterOptions, returnOne: false? ) -> { AnyTable })

--- appends string content to the end of a file at the specified path. If the file does not exist, it will be created.
--- 
--- This is useful for logging, accumulating data over time, or extending file contents without overwriting them.
declare function appendfile(path: string, data: string): ()
--- deletes the file at the specified path if it exists.
--- 
--- This is useful for cleaning up temporary data or removing no-longer-needed files at runtime.
declare function delfile(path: string): ()
--- deletes the folder at the specified path if it exists.
declare function delfolder(path: string): ()
--- returns a content ID (e.g. rbxasset://) that can be used in Roblox APIs for loading audio, meshes, UI images, and other asset types.
--- 
--- Internally, the file at the given path is copied to the game's content directory and then exposed with a usable asset URL.
declare function getcustomasset(path: string): string
--- checks whether a given path exists and refers to a file.
--- 
--- This function is useful when validating input, confirming file existence before reading, or filtering entries returned by `listfiles`
declare function isfile(path: string): boolean
--- checks whether a given path exists and refers to a folder.
--- 
--- This is useful when verifying that a directory exists before writing files into it or listing its contents.
declare function isfolder(path: string): boolean
--- returns an array of strings representing all files and folders within the specified directory.
--- 
--- This can be used to dynamically check which files exist in a folder, etc.
declare function listfiles(path: string): {string}
--- compiles the Luau source code from a file and returns the resulting function (chunk). This chunk runs in the global environment.
--- 
--- If the file contains syntax errors, an error is thrown - just like loadstring. The error will appear in the console.
declare function loadfile<A...>(path: string): ((A...) -> any | nil, string?)
--- creates a folder at the specified path if one does not already exist.
--- 
--- This is useful for organising files into separate directories.
declare function makefolder(path: string): ()
--- retrieves the contents of a file at the specified path and returns it as a string.
--- 
--- If the file does not exist or cannot be accessed, the function will **error**.
declare function readfile(path: string): string
--- writes data to a file at the specified path. If the file already exists, its contents will be overwritten.
--- 
--- This is one of the primary ways to persist string data within the executor's file sandbox.
declare function writefile(path: string, data: string): ()

--- returns a reference clone of an `Instance`. The returned object behaves identically to the original but is not strictly equal (`==`) to it.
--- 
--- This is commonly used to safely interact with services such as `game.CoreGui`, making weak-table style attacks fail.
declare function cloneref<T>(object: T & Instance): T
--- checks if two Instances are equal.
--- 
--- This is primarily used for instances which have been `cloneref`'d, where the normal equality check with `==` fails.
declare function compareinstances(object1: Instance, object2: Instance): boolean
--- triggers a [ClickDetector](https://create.roblox.com/docs/reference/engine/classes/ClickDetector) event. By default, it fires the [MouseClick](https://create.roblox.com/docs/reference/engine/classes/ClickDetector#MouseClick) event.
declare function fireclickdetector(detector: ClickDetector, distance: number?, event: string?): ()
--- instantly triggers a [ProximityPrompt](https://create.roblox.com/docs/reference/engine/classes/ProximityPrompt), bypassing its [HoldDuration](https://create.roblox.com/docs/reference/engine/classes/ProximityPrompt#HoldDuration) and activation distance.
declare function fireproximityprompt(prompt: ProximityPrompt): ()
--- simulates a physical touch event between two [BasePart](https://create.roblox.com/docs/reference/engine/classes/BasePart) objects. It can emulate both the start and end of a [Touched](https://create.roblox.com/docs/reference/engine/classes/BasePart#Touched) event.
declare function firetouchinterest(part1: BasePart, part2: BasePart, toggle: boolean | number): ()
--- retrieves the assigned callback property on an Instance, such as OnInvoke.
--- 
--- Normally, these properties are write-only, meaning you can assign a function to them but cannot read them back. This function bypasses that limitation and exposes the function directly.
declare function getcallbackvalue(object: Instance, property: string): AnyFunction | nil
--- returns a hidden Instance container used for safely storing UI elements. This container is mainly designed to **avoid detections**.
declare function gethui(): BasePlayerGui | Folder
--- retrieves every Instance from the registry. Which means that instances that are/were parented to nil will also be returned.
declare function getinstances(): { Instance }
--- returns a list of Instance objects that are currently unparented. These instances exist in memory but are no longer part of the DataModel hierarchy.
declare function getnilinstances(): { Instance }
--- returns the name of the method that invoked the __namecall metamethod.
--- 
--- When used inside a hookmetamethod hook targeting __namecall, it will attempt to retrieve the method being called (e.g. InvokeServer).
--- 
--- When used outside of said hook, this function will safely return nil.
declare function getnamecallmethod(): string?
--- returns the raw metatable of an object, even if that object has a __metatable field set.
declare function getrawmetatable(object: { any } | userdata): { [any]: any } | nil
--- checks whether a table is currently set as readonly.
declare function isreadonly(table: { any }): boolean
--- forcibly sets the metatable of a value, bypassing the __metatable protection field.
declare function setrawmetatable<T>(object: T & ({ any } | userdata), metatable: { any }?): T
--- sets whether a table is readonly or writable.
declare function setreadonly(table: { any }, state: boolean): ()

--- returns the name and version of the currently running executor.
--- This function is quite self-explanatory, you use it for logging/debugging purposes, idk - its quite basic.
--- 
--- The function returns a tuple of:
--- 
--- 1. string - The name/identifier of the executor.
--- 2. string - The version string of the executor.
declare function identifyexecutor(): (string, string)

type RequestOptions = {
    Url: string,
    Method: "GET" | "HEAD" | "POST" | "PUT" | "DELETE" | "OPTIONS" | "PATCH",
    Body: string?,
    Headers: { [string]: string }?,
    Cookies: { [string]: string }?
}

type Response = {
    Success: boolean,
    Body: string,
    StatusCode: number,
    StatusMessage: string,
    Headers: { [string]: string }
}

--- sends a HTTP request to the given URL using the provided configuration table. It yields until the request is complete and returns a structured response.
declare function request(options: RequestOptions): Response

--- retrieves the value of a hidden or non-scriptable property (e.g. BinaryString, SharedString, SystemAddress) from a given Instance, even if it would normally throw an error when accessed directly.
--- 
--- This function also returns whether the accessed property was hidden.
declare function gethiddenproperty(instance: Instance, property_name: string): (any, boolean)
--- retrieves the thread's identity of the running Luau thread.
declare function getthreadidentity(): number
--- returns whether the given property of an Instance is scriptable (i.e. it does not have the notscriptable tag).
--- 
--- If it returns true, then the property is scriptable and can be indexed normally, and vice versa.
--- 
--- If it returns nil, then the property provided does not exist.
declare function isscriptable(object: Instance, property: string): boolean | nil
--- assigns a value to a hidden or non-scriptable property of an Instance, even if that property is normally read-only or inaccessible.
--- 
--- It returns true if the property is hidden and was successfully written to, or false if the property wasn't hidden but was still updated.
declare function sethiddenproperty(instance: Instance, property_name: string, property_value: any): boolean
--- toggles the scriptability of a hidden or non-scriptable property on an Instance. When a property is made scriptable, it can be accessed or assigned through standard indexing.
declare function setscriptable(instance: Instance, property_name: string, state: boolean): boolean | nil
--- sets the current Luau thread identity and capabilities matching that identity.
--- 
--- This is commonly used alongside functions like gethiddenproperty or getconnections which may require elevated access.
declare function setthreadidentity(id: number): ()

--- returns the Script, LocalScript, or ModuleScript that triggered the current code execution.
declare function getcallingscript(): (BaseScript | ModuleScript)?
--- returns a list of all ModuleScript instances that have been loaded (e.g. require'd).
--- 
--- This includes only modules with completed executions, and excludes any modules that errored or haven't been required yet.
declare function getloadedmodules(): { ModuleScript }
--- returns a list of all running scripts in the caller's global state. This includes Script, LocalScript, and ModuleScript instances - excluding CoreScripts by default.
declare function getrunningscripts(): { BaseScript | ModuleScript }
--- retrieves the bytecode of a LocalScript, ModuleScript, and Script.
declare function getscriptbytecode(script: BaseScript | ModuleScript): string?
--- creates and returns a Luau function closure from the compiled bytecode of a Script, LocalScript, or ModuleScript.
--- 
--- This function is often used to extract constants or behaviour from scripts without needing to run them inside the game.
declare function getscriptclosure(script: BaseScript | ModuleScript): (AnyFunction)?
--- returns a SHA-384 hash in hexadecimal format of the raw bytecode for a given Script, LocalScript, or ModuleScript.
--- 
--- This is useful for identifying scripts by their content, especially when checking for known modules or verifying integrity.
declare function getscripthash(script: BaseScript | ModuleScript): string | nil
--- returns a list of all Script, LocalScript, and ModuleScript instances present.
--- 
--- This function excludes CoreScripts by default.
declare function getscripts(): { BaseScript | ModuleScript }
--- returns the global environment table of a given Script, LocalScript, or ModuleScript.
--- 
--- This environment contains all global variables and functions available to the target script, such as custom-defined functions or state values.
declare function getsenv(script: BaseScript | ModuleScript): { [any]: any } | nil
--- compiles a string of Luau code and returns it as a runnable function. If the code has errors, nil is returned and an error message is output.
declare function loadstring<A...>(source: string, chunkname: string?): (((A...) -> any) | nil, string?)    

declare class Connection
    Enabled: boolean
    ForeignState: boolean
    LuaConnection: boolean
    Function: AnyFunction?
    Thread: thread

    function Fire(self, ...: any): ()
    function Defer(self, ...: any): ()
    function Disconnect(self): ()
    function Disable(self): ()
    function Enable(self): ()
end

--- retrieves a list of Connection objects currently attached to a given RBXScriptSignal.
declare function getconnections(signal: RBXScriptSignal): {Connection}
--- Invokes all Luau connections connected to a given RBXScriptSignal.
declare function firesignal<A...>(signal: RBXScriptSignal<A...>, ...: A...)
---  replicates a signal to the server with the provided arguments, if possible. The arguments must also match accordingly to the signal itself. To know a signal's arguments, visit this.
declare function replicatesignal<A...>(signal: RBXScriptSignal<A...>, ...: A...)

declare class WebSocket
    OnMessage: RBXScriptSignal<string>
    OnClose: RBXScriptSignal<>

    function Send(self, message: string): ()
    function Close(self): ()
end

declare WebSocket: {
    --- Attempts to create a new connection to the provided URL. The URL must be a valid WebSocket server URL, typically starting with ws:// (unsecure) or wss:// (secure).
    connect: (url: string) -> WebSocket
}

declare function setfflag(fflag: string, value: string)
declare function getfflag(fflag: string): string