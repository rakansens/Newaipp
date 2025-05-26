import Foundation

public class DiagramGenerator {
    
    public init() {}
    
    public func generateDiagram(type: DiagramType, content: String) -> Diagram? {
        guard !content.isEmpty else { return nil }
        
        let title = generateTitle(for: type, content: content)
        let svgContent = generateSVG(for: type, content: content)
        
        return Diagram(type: type, title: title, svgContent: svgContent)
    }
    
    private func generateTitle(for type: DiagramType, content: String) -> String {
        switch type {
        case .classDiagram:
            return "Class Diagram - \(extractMainClassName(from: content))"
        case .sequenceDiagram:
            return "Sequence Diagram - \(extractSequenceTitle(from: content))"
        case .flowChart:
            return "Flow Chart - \(extractProcessTitle(from: content))"
        case .componentDiagram:
            return "Component Diagram - \(extractComponentTitle(from: content))"
        case .architectureDiagram:
            return "Architecture Diagram - \(extractArchitectureTitle(from: content))"
        }
    }
    
    private func generateSVG(for type: DiagramType, content: String) -> String {
        switch type {
        case .classDiagram:
            return generateClassDiagramSVG(content)
        case .sequenceDiagram:
            return generateSequenceDiagramSVG(content)
        case .flowChart:
            return generateFlowChartSVG(content)
        case .componentDiagram:
            return generateComponentDiagramSVG(content)
        case .architectureDiagram:
            return generateArchitectureDiagramSVG(content)
        }
    }
    
    // MARK: - Class Diagram Generation
    
    private func generateClassDiagramSVG(_ content: String) -> String {
        let classes = extractClasses(from: content)
        var svg = """
        <svg width="400" height="300" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <style>
                .class-box { fill: #f8f9fa; stroke: #343a40; stroke-width: 2; }
                .class-text { font-family: Arial; font-size: 14px; fill: #343a40; }
                .inheritance-line { stroke: #007bff; stroke-width: 2; marker-end: url(#arrowhead); }
            </style>
            <marker id="arrowhead" markerWidth="10" markerHeight="7" 
                    refX="10" refY="3.5" orient="auto">
                <polygon points="0 0, 10 3.5, 0 7" fill="#007bff"/>
            </marker>
        </defs>
        """
        
        for (index, className) in classes.enumerated() {
            let y = 50 + (index * 80)
            svg += """
            <rect x="50" y="\(y)" width="120" height="60" class="class-box"/>
            <text x="110" y="\(y + 35)" text-anchor="middle" class="class-text">\(className)</text>
            """
        }
        
        // Add inheritance lines if detected
        if content.contains(":") && classes.count > 1 {
            svg += """
            <line x1="110" y1="110" x2="110" y2="130" class="inheritance-line"/>
            <text x="120" y="125" class="class-text" font-size="10">inheritance</text>
            """
        }
        
        svg += "</svg>"
        return svg
    }
    
    // MARK: - Sequence Diagram Generation
    
    private func generateSequenceDiagramSVG(_ content: String) -> String {
        let actors = extractActors(from: content)
        let interactions = extractInteractions(from: content)
        
        var svg = """
        <svg width="500" height="400" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <style>
                .actor { fill: #e9ecef; stroke: #6c757d; stroke-width: 2; }
                .lifeline { stroke: #6c757d; stroke-width: 1; stroke-dasharray: 5,5; }
                .message { stroke: #007bff; stroke-width: 2; marker-end: url(#arrowhead); }
                .text { font-family: Arial; font-size: 12px; fill: #343a40; }
            </style>
            <marker id="arrowhead" markerWidth="10" markerHeight="7" 
                    refX="10" refY="3.5" orient="auto">
                <polygon points="0 0, 10 3.5, 0 7" fill="#007bff"/>
            </marker>
        </defs>
        """
        
        // Draw actors
        for (index, actor) in actors.enumerated() {
            let x = 80 + (index * 120)
            svg += """
            <rect x="\(x - 40)" y="20" width="80" height="30" class="actor"/>
            <text x="\(x)" y="40" text-anchor="middle" class="text">\(actor)</text>
            <line x1="\(x)" y1="50" x2="\(x)" y2="350" class="lifeline"/>
            """
        }
        
        // Draw interactions
        for (index, interaction) in interactions.enumerated() {
            let y = 100 + (index * 40)
            svg += """
            <line x1="80" y1="\(y)" x2="200" y2="\(y)" class="message"/>
            <text x="140" y="\(y - 5)" text-anchor="middle" class="text">\(interaction)</text>
            """
        }
        
        svg += "</svg>"
        return svg
    }
    
    // MARK: - Flow Chart Generation
    
    private func generateFlowChartSVG(_ content: String) -> String {
        let steps = extractSteps(from: content)
        
        var svg = """
        <svg width="300" height="400" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <style>
                .start-end { fill: #28a745; stroke: #1e7e34; stroke-width: 2; }
                .process { fill: #17a2b8; stroke: #117a8b; stroke-width: 2; }
                .decision { fill: #ffc107; stroke: #e0a800; stroke-width: 2; }
                .flow-text { font-family: Arial; font-size: 11px; fill: #343a40; }
                .arrow { stroke: #343a40; stroke-width: 2; marker-end: url(#arrowhead); }
            </style>
            <marker id="arrowhead" markerWidth="10" markerHeight="7" 
                    refX="10" refY="3.5" orient="auto">
                <polygon points="0 0, 10 3.5, 0 7" fill="#343a40"/>
            </marker>
        </defs>
        """
        
        for (index, step) in steps.enumerated() {
            let y = 50 + (index * 80)
            let isDecision = step.lowercased().contains("if") || step.lowercased().contains("check")
            let isStartEnd = index == 0 || index == steps.count - 1
            
            if isStartEnd {
                svg += """
                <ellipse cx="150" cy="\(y)" rx="60" ry="25" class="start-end"/>
                """
            } else if isDecision {
                svg += """
                <polygon points="90,\(y) 150,\(y-25) 210,\(y) 150,\(y+25)" class="decision"/>
                <text x="220" y="\(y)" class="flow-text">decision</text>
                """
            } else {
                svg += """
                <rect x="90" y="\(y - 20)" width="120" height="40" class="process"/>
                """
            }
            
            svg += """
            <text x="150" y="\(y + 5)" text-anchor="middle" class="flow-text">\(step.prefix(15))...</text>
            """
            
            if index < steps.count - 1 {
                svg += """
                <line x1="150" y1="\(y + 25)" x2="150" y2="\(y + 55)" class="arrow"/>
                """
            }
        }
        
        svg += "</svg>"
        return svg
    }
    
    // MARK: - Component Diagram Generation
    
    private func generateComponentDiagramSVG(_ content: String) -> String {
        let components = extractComponents(from: content)
        
        var svg = """
        <svg width="400" height="300" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <style>
                .component { fill: #e7f3ff; stroke: #0066cc; stroke-width: 2; }
                .component-text { font-family: Arial; font-size: 12px; fill: #0066cc; }
                .connection { stroke: #6c757d; stroke-width: 1; }
            </style>
        </defs>
        """
        
        for (index, component) in components.enumerated() {
            let x = 50 + (index % 2) * 180
            let y = 50 + (index / 2) * 100
            
            svg += """
            <rect x="\(x)" y="\(y)" width="150" height="60" class="component"/>
            <text x="\(x + 75)" y="\(y + 35)" text-anchor="middle" class="component-text">\(component)</text>
            <text x="\(x + 10)" y="\(y + 15)" class="component-text" font-size="10">component</text>
            """
        }
        
        svg += "</svg>"
        return svg
    }
    
    // MARK: - Architecture Diagram Generation
    
    private func generateArchitectureDiagramSVG(_ content: String) -> String {
        let layers = extractLayers(from: content)
        
        var svg = """
        <svg width="400" height="350" xmlns="http://www.w3.org/2000/svg">
        <defs>
            <style>
                .layer { fill: #f8f9fa; stroke: #6c757d; stroke-width: 2; }
                .layer-text { font-family: Arial; font-size: 14px; fill: #343a40; }
                .layer-label { font-family: Arial; font-size: 10px; fill: #6c757d; }
            </style>
        </defs>
        """
        
        for (index, layer) in layers.enumerated() {
            let y = 50 + (index * 70)
            
            svg += """
            <rect x="50" y="\(y)" width="300" height="50" class="layer"/>
            <text x="200" y="\(y + 30)" text-anchor="middle" class="layer-text">\(layer)</text>
            <text x="60" y="\(y + 15)" class="layer-label">layer</text>
            """
        }
        
        svg += "</svg>"
        return svg
    }
    
    // MARK: - Content Extraction Helpers
    
    private func extractMainClassName(from content: String) -> String {
        let pattern = "class\\s+(\\w+)"
        if let range = content.range(of: pattern, options: .regularExpression) {
            let match = String(content[range])
            return match.components(separatedBy: " ").last ?? "Unknown"
        }
        return "System"
    }
    
    private func extractClasses(from content: String) -> [String] {
        let patterns = ["class\\s+(\\w+)", "struct\\s+(\\w+)", "interface\\s+(\\w+)"]
        var classes: [String] = []
        
        for pattern in patterns {
            let regex = try? NSRegularExpression(pattern: pattern)
            let matches = regex?.matches(in: content, range: NSRange(content.startIndex..., in: content))
            for match in matches ?? [] {
                if let range = Range(match.range(at: 1), in: content) {
                    classes.append(String(content[range]))
                }
            }
        }
        
        return Array(Set(classes)) // Remove duplicates
    }
    
    private func extractActors(from content: String) -> [String] {
        var actors: [String] = []
        let lines = content.components(separatedBy: .newlines)
        
        for line in lines {
            if line.contains("->") {
                let parts = line.components(separatedBy: "->")
                if parts.count >= 2 {
                    let from = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    let to = parts[1].components(separatedBy: ":")[0].trimmingCharacters(in: .whitespacesAndNewlines)
                    actors.append(contentsOf: [from, to])
                }
            }
        }
        
        if actors.isEmpty {
            actors = ["User", "Frontend", "API", "Database"]
        }
        
        return Array(Set(actors)).prefix(4).map { String($0) }
    }
    
    private func extractInteractions(from content: String) -> [String] {
        let lines = content.components(separatedBy: .newlines)
        var interactions: [String] = []
        
        for line in lines {
            if line.contains("->") || line.contains(":") {
                let interaction = line.components(separatedBy: ":").last?
                    .trimmingCharacters(in: .whitespacesAndNewlines) ?? "message"
                interactions.append(String(interaction.prefix(20)))
            }
        }
        
        if interactions.isEmpty {
            interactions = ["request", "process", "response"]
        }
        
        return Array(interactions.prefix(5))
    }
    
    private func extractSteps(from content: String) -> [String] {
        let lines = content.components(separatedBy: .newlines)
        var steps: [String] = []
        
        for line in lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty && (trimmed.hasPrefix("-") || trimmed.contains(".") || trimmed.lowercased().contains("step")) {
                steps.append(String(trimmed.prefix(30)))
            }
        }
        
        if steps.isEmpty {
            steps = ["Start", "Process", "End"]
        }
        
        return Array(steps.prefix(6))
    }
    
    private func extractComponents(from content: String) -> [String] {
        var components: [String] = []
        let componentPatterns = ["\\w+Service", "\\w+Component", "\\w+Manager", "\\w+Controller"]
        
        for pattern in componentPatterns {
            let regex = try? NSRegularExpression(pattern: pattern)
            let matches = regex?.matches(in: content, range: NSRange(content.startIndex..., in: content))
            for match in matches ?? [] {
                if let range = Range(match.range, in: content) {
                    components.append(String(content[range]))
                }
            }
        }
        
        if components.isEmpty {
            components = ["Frontend", "Backend", "Database", "Cache"]
        }
        
        return Array(Set(components)).prefix(4).map { String($0) }
    }
    
    private func extractLayers(from content: String) -> [String] {
        let layerKeywords = ["presentation", "business", "data", "frontend", "backend", "ui", "api", "database"]
        var layers: [String] = []
        
        for keyword in layerKeywords {
            if content.lowercased().contains(keyword) {
                layers.append(keyword.capitalized + " Layer")
            }
        }
        
        if layers.isEmpty {
            layers = ["Presentation Layer", "Business Layer", "Data Layer"]
        }
        
        return Array(layers.prefix(4))
    }
    
    private func extractSequenceTitle(from content: String) -> String {
        if content.lowercased().contains("login") { return "Login Process" }
        if content.lowercased().contains("auth") { return "Authentication" }
        return "System Interaction"
    }
    
    private func extractProcessTitle(from content: String) -> String {
        if content.lowercased().contains("login") { return "Login Flow" }
        if content.lowercased().contains("process") { return "Business Process" }
        return "Process Flow"
    }
    
    private func extractComponentTitle(from content: String) -> String {
        if content.lowercased().contains("system") { return "System Components" }
        return "Application Components"
    }
    
    private func extractArchitectureTitle(from content: String) -> String {
        if content.lowercased().contains("microservice") { return "Microservices Architecture" }
        if content.lowercased().contains("layer") { return "Layered Architecture" }
        return "System Architecture"
    }
}