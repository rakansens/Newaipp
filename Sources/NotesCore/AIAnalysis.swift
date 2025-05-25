import Foundation

public enum ContentType {
    case code
    case text
    case architecture
    case documentation
}

public enum ContentPattern {
    case classDefinition
    case functionDefinition
    case apiEndpoint
    case systemArchitecture
    case databaseDesign
    case userInterface
    case businessLogic
    case testCode
}

public enum DiagramType: CaseIterable {
    case classDiagram
    case sequenceDiagram
    case flowChart
    case componentDiagram
    case architectureDiagram
    
    public var displayName: String {
        switch self {
        case .classDiagram:
            return "Class Diagram"
        case .sequenceDiagram:
            return "Sequence Diagram"
        case .flowChart:
            return "Flow Chart"
        case .componentDiagram:
            return "Component Diagram"
        case .architectureDiagram:
            return "Architecture Diagram"
        }
    }
}

public struct AIAnalysis {
    public let contentType: ContentType
    public let programmingLanguage: String?
    public let patterns: Set<ContentPattern>
    public let confidence: Double
    public let suggestedDiagrams: [DiagramType]
    
    public init(
        contentType: ContentType,
        programmingLanguage: String? = nil,
        patterns: Set<ContentPattern> = [],
        confidence: Double = 0.0,
        suggestedDiagrams: [DiagramType] = []
    ) {
        self.contentType = contentType
        self.programmingLanguage = programmingLanguage
        self.patterns = patterns
        self.confidence = confidence
        self.suggestedDiagrams = suggestedDiagrams
    }
}

public struct Diagram {
    public let id: UUID
    public let type: DiagramType
    public let title: String
    public let svgContent: String
    public let createdAt: Date
    
    public init(type: DiagramType, title: String, svgContent: String) {
        self.id = UUID()
        self.type = type
        self.title = title
        self.svgContent = svgContent
        self.createdAt = Date()
    }
}