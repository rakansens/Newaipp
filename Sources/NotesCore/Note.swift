import Foundation

public class Note: ObservableObject, Identifiable {
    public let id: UUID
    @Published public var title: String
    @Published public var content: String
    public let createdAt: Date
    @Published public var updatedAt: Date
    
    public init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    public func update(title: String, content: String) {
        self.title = title
        self.content = content
        self.updatedAt = Date()
    }
    
    public func containsCode() -> Bool {
        let codePatterns = [
            // Function definitions
            "func\\s+\\w+\\s*\\(",
            "function\\s+\\w+\\s*\\(",
            "def\\s+\\w+\\s*\\(",
            // Class/struct definitions
            "class\\s+\\w+",
            "struct\\s+\\w+",
            "interface\\s+\\w+",
            // Import statements
            "import\\s+\\w+",
            "#include\\s*<",
            "from\\s+\\w+\\s+import",
            // Control structures
            "if\\s*\\(",
            "for\\s*\\(",
            "while\\s*\\(",
            // Common code symbols
            "\\{.*\\}",
            "=>",
            "->",
            "\\[\\]",
            "\\(\\)\\s*=>",
            // Variable declarations
            "let\\s+\\w+\\s*=",
            "var\\s+\\w+\\s*=",
            "const\\s+\\w+\\s*=",
            "int\\s+\\w+\\s*=",
            "String\\s+\\w+\\s*="
        ]
        
        for pattern in codePatterns {
            if content.range(of: pattern, options: .regularExpression) != nil {
                return true
            }
        }
        
        return false
    }
}