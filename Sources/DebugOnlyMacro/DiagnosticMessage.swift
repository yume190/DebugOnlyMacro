import Foundation
import SwiftDiagnostics

enum DebugOnlyDiagnosticMessage: String, DiagnosticMessage {
    case bodyNotFound
    case nameMustUseString
    
    var message: String {
        switch self {
        case .bodyNotFound:
            return "Can't find function body."
        case .nameMustUseString:
            return """
            The name must use a string literal("DEBUG"), not a variable.
            """
        }
    }
    var diagnosticID: MessageID {
        MessageID(domain: "DebugOnlyMacro", id: rawValue)
    }
    var severity: DiagnosticSeverity { .error }
}
