import Foundation

public class AIAnalyzer {
    
    public init() {}
    
    public func analyzeContent(_ content: String) -> AIAnalysis {
        let detectedLanguage = detectProgrammingLanguage(content)
        let contentType = determineContentType(content, language: detectedLanguage)
        let patterns = detectPatterns(content, language: detectedLanguage)
        let confidence = calculateConfidence(content, language: detectedLanguage, patterns: patterns)
        let suggestedDiagrams = suggestDiagrams(for: content)
        
        return AIAnalysis(
            contentType: contentType,
            programmingLanguage: detectedLanguage,
            patterns: patterns,
            confidence: confidence,
            suggestedDiagrams: suggestedDiagrams
        )
    }
    
    public func suggestDiagrams(for content: String) -> [DiagramType] {
        var suggestions: [DiagramType] = []
        
        // Class diagram suggestions
        if content.contains("class ") || content.contains("struct ") || content.contains("interface ") {
            suggestions.append(.classDiagram)
        }
        
        // Sequence diagram suggestions
        if content.contains("->") || content.contains("API") || 
           content.contains("request") || content.contains("response") ||
           content.range(of: "\\d+\\.", options: .regularExpression) != nil {
            suggestions.append(.sequenceDiagram)
        }
        
        // Flow chart suggestions
        if content.contains("if") || content.contains("else") || 
           content.contains("switch") || content.contains("while") ||
           content.contains("process") || content.contains("step") {
            suggestions.append(.flowChart)
        }
        
        // Component diagram suggestions
        if content.contains("component") || content.contains("service") ||
           content.contains("module") || content.contains("layer") {
            suggestions.append(.componentDiagram)
        }
        
        // Architecture diagram suggestions
        if content.contains("architecture") || content.contains("system") ||
           content.contains("frontend") || content.contains("backend") ||
           content.contains("database") || content.contains("layer") {
            suggestions.append(.architectureDiagram)
        }
        
        return suggestions
    }
    
    private func detectProgrammingLanguage(_ content: String) -> String? {
        let languagePatterns: [(String, String)] = [
            ("Swift", "func\\s+\\w+|class\\s+\\w+|struct\\s+\\w+|var\\s+\\w+|let\\s+\\w+"),
            ("JavaScript", "function\\s+\\w+|const\\s+\\w+|require\\(|=>|console\\.log"),
            ("Python", "def\\s+\\w+|import\\s+\\w+|if\\s+__name__|print\\("),
            ("Java", "public\\s+class|public\\s+static|import\\s+java"),
            ("TypeScript", "interface\\s+\\w+|type\\s+\\w+|:\\s*\\w+\\[\\]"),
            ("C#", "public\\s+class|using\\s+System|namespace\\s+\\w+"),
            ("Go", "func\\s+\\w+|package\\s+\\w+|import\\s+\""),
            ("Rust", "fn\\s+\\w+|struct\\s+\\w+|impl\\s+\\w+|use\\s+\\w+")
        ]
        
        for (language, pattern) in languagePatterns {
            if content.range(of: pattern, options: .regularExpression) != nil {
                return language
            }
        }
        
        return nil
    }
    
    private func determineContentType(_ content: String, language: String?) -> ContentType {
        if language != nil {
            return .code
        }
        
        if content.contains("architecture") || content.contains("system") ||
           content.contains("component") || content.contains("layer") {
            return .architecture
        }
        
        return .text
    }
    
    private func detectPatterns(_ content: String, language: String?) -> Set<ContentPattern> {
        var patterns: Set<ContentPattern> = []
        
        // Class definition patterns
        if content.range(of: "class\\s+\\w+|struct\\s+\\w+|interface\\s+\\w+", options: .regularExpression) != nil {
            patterns.insert(.classDefinition)
        }
        
        // Function definition patterns
        if content.range(of: "func\\s+\\w+|function\\s+\\w+|def\\s+\\w+", options: .regularExpression) != nil {
            patterns.insert(.functionDefinition)
        }
        
        // API endpoint patterns
        if content.contains("GET") || content.contains("POST") || content.contains("PUT") ||
           content.contains("DELETE") || content.contains("/api/") || content.contains("endpoint") {
            patterns.insert(.apiEndpoint)
        }
        
        // System architecture patterns
        if content.contains("architecture") || content.contains("system") ||
           content.contains("frontend") || content.contains("backend") {
            patterns.insert(.systemArchitecture)
        }
        
        // Database design patterns
        if content.contains("database") || content.contains("table") ||
           content.contains("SQL") || content.contains("schema") {
            patterns.insert(.databaseDesign)
        }
        
        return patterns
    }
    
    private func calculateConfidence(_ content: String, language: String?, patterns: Set<ContentPattern>) -> Double {
        var confidence = 0.0
        
        if language != nil {
            confidence += 0.3
        }
        
        confidence += Double(patterns.count) * 0.2
        
        if content.count > 100 {
            confidence += 0.2
        }
        
        return min(confidence, 1.0)
    }
}