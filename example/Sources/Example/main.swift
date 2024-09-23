import Foundation
import DebugOnly

struct Target {
    static let shared = Target()
    static let text = "test"
    
    @DebugOnly
    func debug1() {
        let x: Int = 1
        print(1+x)
    }
    
    @FlagBasedResult()
    func debug2() {
        let x: Int = 1
        print(1+x)
    }
    
    @FlagBasedResult(name: "RELEASE", ret: 2)
    func foo() -> Int {
        return 1
    }
    
    @FlagBasedResult(name: "RELEASE")
    func bar() {
        let x: Int = 1
        print(1+x)
    }
}

@DebugOnly(ret: "bar")
func foo() -> String {
    "foo"
}

@FlagBasedResult(name: "RELEASE", ret: "bar")
func bar() -> String {
    "foo"
}

print(foo())
print(bar())
