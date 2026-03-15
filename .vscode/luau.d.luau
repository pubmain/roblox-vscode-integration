export type userdata = typeof(newproxy())
export type AnyFunction = (...any) -> (...any)
export type AnyTable = { [any]: any }

declare function setclipboard(value: string): ()

declare game: {
    HttpGet: (self: DataModel, url: string) -> string
} & DataModel

declare function checkcaller(): boolean
declare function clonefunction<A..., R...>(functionToClone: (A...) -> R...): (A...) -> R...
declare function getfunctionhash(functionToHash: (...any) -> (...any)): string
-- declare function hookfunction<A1..., R1..., A2..., R2...>(functionToHook: (A1...) -> R1..., hook: (A2...) -> R2...): (A1...) -> R1...
declare function hookfunction<A1..., R1...>(functionToHook: (A1...) -> R1..., hook: (A1...) -> R1...): (A1...) -> R1...
declare function hookmetamethod(object: { any: any } | Instance | userdata, metamethodName: string, hook: (...any) -> (...any)): (...any) -> (...any)
declare function iscclosure(func: (...any) -> (...any)): boolean
declare function isexecutorclosure(func: (...any) -> (...any)): boolean
declare function islclosure(func: (...any) -> (...any)): boolean
declare function newcclosure<A..., R...>(functionToWrap: (A...) -> R...): (A...) -> R...
declare function restorefunction(functionToRestore: (...any) -> (...any)): ()

declare debug: {
    getconstant: (func: (...any) -> (...any), index: number) -> number | string | boolean | nil,
    getconstants: (func: (...any) -> (...any) | number) -> { number | string | boolean | nil },
    getproto: (func: (...any) -> (...any) | number, index: number, activated: boolean?) -> ((...any) -> (...any)) | { (...any) -> (...any) },
    getprotos: (func: (...any) -> (...any) | number) -> { (...any) -> (...any) },
    getstack: (level: number, index: number?) -> any | { any },
    getupvalue: (func: (...any) -> (...any) | number, index: number) -> any,
    getupvalues: (func: (...any) -> (...any) | number) -> { any },
    setconstant: (func: (...any) -> (...any) | number, index: number, value: number | string | boolean | nil) -> (),
    setstack: (level: number, index: number, value: any) -> (),
    setupvalue: (func: (...any) -> (...any) | number, index: number, value: any) -> (),
    info: ((level: number, options: string) -> ...any) & ((func: AnyFunction, options: string) -> ...any) & ((thread: thread, level: number, options: string) -> ...any),
    traceback: (message: string?, level: number?) -> string
}

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

declare function cleardrawcache(): ()
declare function getrenderproperty(drawing: Drawing, property: string): any
declare function isrenderobj(object: any): boolean
declare function setrenderproperty(drawing: Drawing, property: string, value: any): ()

declare function base64decode(data: string): string
declare function base64encode(data: string): string
declare function lz4compress(data: string): string
declare function lz4decompress(data: string): string

declare getgc:
    ((includeTables: true) -> { { AnyTable } | AnyFunction | userdata }) &
    ((includeTables: false?) -> { AnyFunction })
declare function getreg(): { [any]: any }
declare function getgenv(): { [any]: any }
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

declare filtergc: 
    (( filterType: "function", filterOptions: FunctionFilterOptions, returnOne: true) -> AnyFunction? ) &
    ((( filterType: "function", filterOptions: FunctionFilterOptions, returnOne: false?) -> ( AnyFunction | { AnyFunction } ) )) &
    (( filterType: "table", filterOptions: TableFilterOptions, returnOne: true) -> { AnyTable? } ) &
    (( filterType: "table", filterOptions: TableFilterOptions, returnOne: false? ) -> { AnyTable })

declare function appendfile(path: string, data: string): ()
declare function delfile(path: string): ()
declare function delfolder(path: string): ()
declare function getcustomasset(path: string): string
declare function isfile(path: string): boolean
declare function isfolder(path: string): boolean
declare function listfiles(path: string): {string}
declare function loadfile(path: string): AnyFunction
declare function makefolder(path: string): ()
declare function readfile(path: string): string
declare function writefile(path: string, data: string): ()

declare function cloneref<T>(object: T & Instance): T
declare function compareinstances(object1: Instance, object2: Instance): boolean
declare function fireclickdetector(detector: ClickDetector, distance: number?, event: string?): ()
declare function fireproximityprompt(prompt: ProximityPrompt): ()
declare function firetouchinterest(part1: BasePart, part2: BasePart, toggle: boolean | number): ()
declare function getcallbackvalue(object: Instance, property: string): AnyFunction | nil
declare function gethui(): BasePlayerGui | Folder
declare function getinstances(): { Instance }
declare function getnilinstances(): { Instance }

declare function getnamecallmethod(): string?
declare function getrawmetatable(object: { any } | userdata): { [any]: any } | nil
declare function isreadonly(table: { any }): boolean
declare function setrawmetatable<T>(object: T & ({ any } | userdata), metatable: { any }?): T
declare function setreadonly(table: { any }, state: boolean): ()

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

declare function request(options: RequestOptions): Response

declare function gethiddenproperty(instance: Instance, property_name: string): (any, boolean)
declare function getthreadidentity(): number
declare function isscriptable(object: Instance, property: string): boolean | nil
declare function sethiddenproperty(instance: Instance, property_name: string, property_value: any): boolean
declare function setscriptable(instance: Instance, property_name: string, state: boolean): boolean | nil
declare function setthreadidentity(id: number): ()

declare function getcallingscript(): (BaseScript | ModuleScript)?
declare function getloadedmodules(): { ModuleScript }
declare function getrunningscripts(): { BaseScript | ModuleScript }
declare function getscriptbytecode(script: BaseScript | ModuleScript): string?
declare function getscriptclosure(script: BaseScript | ModuleScript): ((...any) -> (...any))?
declare function getscripthash(script: BaseScript | ModuleScript): string | nil
declare function getscripts(): { BaseScript | ModuleScript }
declare function getsenv(script: BaseScript | ModuleScript): { [any]: any } | nil
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

declare function getconnections(signal: RBXScriptSignal): {Connection}
declare function firesignal<A...>(signal: RBXScriptSignal<A...>, ...: A...)
declare function replicatesignal<A...>(signal: RBXScriptSignal<A...>, ...: A...)

declare class WebSocket
    OnMessage: RBXScriptSignal<string>
    OnClose: RBXScriptSignal<>

    function Send(self, message: string): ()
    function Close(self): ()
end

declare WebSocket: {
    connect: (url: string) -> WebSocket
}

declare function setfflag(fflag: string, value: string)
declare function getfflag(fflag: string): string