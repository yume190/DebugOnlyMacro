# DebugOnlyMacro

---

`DebugOnlyMacro` provide two macros `@DebugOnly` and `@FlagBasedResult`.

Wrap your function body within `#if DEBUG` or a custom flag for conditional compilation.

## Usage

```swift
import DebugOnly

@DebugOnly
func foo() {
    print("foo")
}

// to
func foo() {
    #if DEBUG
    print("foo")
    #endif
}
```

## With return value

```swift
import DebugOnly

@DebugOnly(ret: 2)
func foo() -> Int? {
    1
}

@DebugOnly(ret: nil)
func bar() -> Int? {
    1
}

// to
func foo() -> Int? {
    #if DEBUG
    1
    #else
    return 2
    #endif
}

func bar() -> Int? {
    #if DEBUG
    1
    #else
    return nil
    #endif
}
```

### With custom Flag

```swift
import DebugOnly

@FlagBasedResult(name: "RELEASE")
func foo() {
    print("foo")
}

// to
func foo() {
    #if RELEASE
    print("foo")
    #endif
}
```
