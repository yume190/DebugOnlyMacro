import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftDiagnostics
import SwiftSyntaxMacros

/// @DebugOnly
/// func test() {
///     ...
/// }
///
/// func test() {
/// #if DEBUG
///     ...
/// #endif
/// }
///
/// @FlagBasedResult(name: "RELEASE", ret: nil)
/// func test() -> Int? {
///     ...
/// }
///
/// func test() -> Int? {
/// #if RELEASE
///     ...
/// #else
///     return nil
/// #endif
/// }
struct DebugOnlyMacro: BodyMacro {
    public static var formatMode: FormatMode { .disabled }
    public static func expansion(
        of node: AttributeSyntax,
        providingBodyFor declaration: some DeclSyntaxProtocol & WithOptionalCodeBlockSyntax,
        in context: some MacroExpansionContext
    ) throws -> [CodeBlockItemSyntax] {
        guard let statements = declaration.body?.statements else {
            context.diagnose(
                Diagnostic(
                    node: declaration,
                    message: DebugOnlyDiagnosticMessage.bodyNotFound
                )
            )
            return []
        }
        
        let arguments = node.arguments?.as(LabeledExprListSyntax.self)
        guard let name = flagName(arguments, in: context) else {
            return []
        }
        let ret = arguments?.find(name: "ret")?.expression.trimmed.description

        if let ret {
            return
                ["#if \(raw: name)"] +
                statements +
                ["#else", "return \(raw: ret)", "#endif"]
        } else {
            return
                ["#if \(raw: name)"] +
                statements +
                ["#endif"]
        }
    }
    
    private static func flagName(
        _ arguments: LabeledExprListSyntax?,
        in context: some MacroExpansionContext
    ) -> String? {
        let flag = arguments?.find(name: "name")
        if let flag {
            if let name = flag.expression.as(StringLiteralExprSyntax.self) {
                return name.segments.trimmedDescription
            } else {
                context.diagnose(
                    Diagnostic(
                        node: flag.expression,
                        message: DebugOnlyDiagnosticMessage.nameMustUseString
                    )
                )
                return nil
            }
        }
        
        return "DEBUG"
    }
}

extension LabeledExprListSyntax {
    func find(name: String) -> LabeledExprSyntax? {
        self.first { (syntax: LabeledExprSyntax) in
            syntax.label?.text == name
        }
    }
}
