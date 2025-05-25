import Foundation

struct Note: Identifiable, Codable {
    let id = UUID()
    var title: String
    var content: String
    var createdAt = Date()
    var modifiedAt = Date()
    var analysis: String?
    var diagrams: [DiagramData]
    
    mutating func updateContent(_ newContent: String) {
        content = newContent
        modifiedAt = Date()
        if title.isEmpty || title == "Untitled" {
            title = generateTitle(from: newContent)
        }
    }
    
    mutating func updateAnalysis(_ newAnalysis: String) {
        analysis = newAnalysis
        modifiedAt = Date()
    }
    
    mutating func addDiagram(_ diagram: DiagramData) {
        diagrams.append(diagram)
        modifiedAt = Date()
    }
    
    private func generateTitle(from content: String) -> String {
        let lines = content.components(separatedBy: .newlines)
        let firstMeaningfulLine = lines.first(where: { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty })
        
        if let line = firstMeaningfulLine {
            let title = String(line.prefix(50)).trimmingCharacters(in: .whitespacesAndNewlines)
            return title.isEmpty ? "Untitled" : title
        }
        
        return "Untitled"
    }
}

struct DiagramData: Identifiable, Codable {
    let id = UUID()
    var type: DiagramType
    var title: String
    var description: String
    var svgContent: String
    var createdAt = Date()
}

enum DiagramType: String, CaseIterable, Codable {
    case flowchart = "flowchart"
    case sequence = "sequence"
    case component = "component"
    case architecture = "architecture"
    case classdiagram = "class"
    
    var displayName: String {
        switch self {
        case .flowchart: return "Flow Chart"
        case .sequence: return "Sequence Diagram"
        case .component: return "Component Diagram"
        case .architecture: return "Architecture Diagram"
        case .classdiagram: return "Class Diagram"
        }
    }
    
    var icon: String {
        switch self {
        case .flowchart: return "arrow.branch"
        case .sequence: return "arrow.left.arrow.right"
        case .component: return "square.stack.3d.up"
        case .architecture: return "building.2"
        case .classdiagram: return "rectangle.3.group"
        }
    }
}