import XCTest
@testable import DebugOnlyMacro
import SwiftSyntaxMacrosTestSupport

/// @attached(body)
/// public macro DebugOnly(ret: Any? = nil) = #externalMacro(
///     module: "DebugOnlyMacro",
///     type: "DebugOnlyMacro"
/// )
///
/// @attached(body)
/// public macro FlagBasedResult(name: String? = nil, ret: Any? = nil) = #externalMacro(
///     module: "DebugOnlyMacro",
///     type: "DebugOnlyMacro"
/// )
private let macros = [
    "DebugOnly": DebugOnlyMacro.self,
    "FlagBasedResult": DebugOnlyMacro.self,
]

final class DebugOnlyMacroTests: XCTestCase {}

/// DebugOnly
extension DebugOnlyMacroTests {
    final func testDebugOnlySimple() {
        assertMacroExpansion(
        """
        @DebugOnly
        func foo() {
            print(1)
            print(2)
        }
        """,
        expandedSource:"""
        
        func foo() {
            #if DEBUG
            print(1)
            print(2)
            #endif
        }
        """,
        macros: macros)
    }
    
    final func testDebugOnlyWithReturn() {
        assertMacroExpansion(
        """
        @DebugOnly(ret: 2)
        func foo() -> Int? {
            1
        }
        """,
        expandedSource:"""
        
        func foo() -> Int? {
            #if DEBUG
            1
            #else
            return 2
            #endif
        }
        """,
        macros: macros)
    }
    
    final func testDebugOnlyWithReturnNil() {
        assertMacroExpansion(
        """
        @DebugOnly(ret: nil)
        func foo() -> Int? {
            1
        }
        """,
        expandedSource:"""
        
        func foo() -> Int? {
            #if DEBUG
            1
            #else
            return nil
            #endif
        }
        """,
        macros: macros)
    }

}

/// FlagBasedResult
extension DebugOnlyMacroTests {
    final func testReleaseSimple() {
        assertMacroExpansion(
        """
        @FlagBasedResult(name: "RELEASE")
        func foo() {
            print(1)
            print(2)
        }
        """,
        expandedSource:"""
        
        func foo() {
            #if RELEASE
            print(1)
            print(2)
            #endif
        }
        """,
        macros: macros)
    }
    
    final func testReleaseWithReturn() {
        assertMacroExpansion(
        """
        @FlagBasedResult(name: "RELEASE", ret: 2)
        func foo() -> Int? {
            1
        }
        """,
        expandedSource:"""
        
        func foo() -> Int? {
            #if RELEASE
            1
            #else
            return 2
            #endif
        }
        """,
        macros: macros)
    }
    
    final func testReleaseWithReturnNil() {
        assertMacroExpansion(
        """
        @FlagBasedResult(name: "RELEASE", ret: nil)
        func foo() -> Int? {
            1
        }
        """,
        expandedSource:"""
        
        func foo() -> Int? {
            #if RELEASE
            1
            #else
            return nil
            #endif
        }
        """,
        macros: macros)
    }

}
