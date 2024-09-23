@attached(body)
public macro DebugOnly(ret: Any? = nil) = #externalMacro(
    module: "DebugOnlyMacro",
    type: "DebugOnlyMacro"
)

@attached(body)
public macro FlagBasedResult(name: String? = nil, ret: Any? = nil) = #externalMacro(
    module: "DebugOnlyMacro",
    type: "DebugOnlyMacro"
)
