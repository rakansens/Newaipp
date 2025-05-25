import SwiftUI

struct DiagramGeneratorView: View {
    @Binding var note: Note
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedDiagramType: DiagramType = .flowchart
    @State private var diagramTitle = ""
    @State private var diagramDescription = ""
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Generate AI Diagram")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Create a visual diagram based on your note content")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Diagram Type Selection
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Diagram Type")
                            .font(.headline)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                            ForEach(DiagramType.allCases, id: \.self) { type in
                                DiagramTypeCard(
                                    type: type,
                                    isSelected: selectedDiagramType == type,
                                    onSelect: { selectedDiagramType = type }
                                )
                            }
                        }
                    }
                    
                    // Title Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Title")
                            .font(.headline)
                        
                        TextField("Enter diagram title...", text: $diagramTitle)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    // Description Input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        TextField("Describe what this diagram should show...", text: $diagramDescription, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .frame(minHeight: 60)
                    }
                    
                    Spacer()
                    
                    // Generate Button
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Generate Diagram") {
                            generateDiagram()
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(diagramTitle.isEmpty || isGenerating)
                    }
                }
            }
            .padding(24)
            .frame(width: 500, height: 600)
        }
        .onAppear {
            setupDefaultValues()
        }
    }
    
    private func setupDefaultValues() {
        if diagramTitle.isEmpty {
            diagramTitle = suggestTitle(for: selectedDiagramType, content: note.content)
        }
        if diagramDescription.isEmpty {
            diagramDescription = suggestDescription(for: selectedDiagramType, content: note.content)
        }
    }
    
    private func generateDiagram() {
        isGenerating = true
        
        // Simulate diagram generation with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let svgContent = generateMockSVG(for: selectedDiagramType, title: diagramTitle)
            
            let diagram = DiagramData(
                type: selectedDiagramType,
                title: diagramTitle,
                description: diagramDescription,
                svgContent: svgContent
            )
            
            note.addDiagram(diagram)
            isGenerating = false
            dismiss()
        }
    }
    
    private func suggestTitle(for type: DiagramType, content: String) -> String {
        switch type {
        case .flowchart:
            return "Process Flow"
        case .sequence:
            return "Interaction Sequence"
        case .component:
            return "Component Structure"
        case .architecture:
            return "System Architecture"
        case .classdiagram:
            return "Class Relationships"
        }
    }
    
    private func suggestDescription(for type: DiagramType, content: String) -> String {
        switch type {
        case .flowchart:
            return "Shows the logical flow and decision points in the process"
        case .sequence:
            return "Illustrates the sequence of interactions between components"
        case .component:
            return "Displays the structural relationships between components"
        case .architecture:
            return "Overview of the system architecture and component interactions"
        case .classdiagram:
            return "Shows class relationships, inheritance, and dependencies"
        }
    }
    
    private func generateMockSVG(for type: DiagramType, title: String) -> String {
        switch type {
        case .flowchart:
            return generateFlowchartSVG(title: title)
        case .sequence:
            return generateSequenceSVG(title: title)
        case .component:
            return generateComponentSVG(title: title)
        case .architecture:
            return generateArchitectureSVG(title: title)
        case .classdiagram:
            return generateClassDiagramSVG(title: title)
        }
    }
    
    private func generateFlowchartSVG(title: String) -> String {
        return """
        <svg width="400" height="300" viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <style>
                    .box { fill: #e1f5fe; stroke: #0277bd; stroke-width: 2; }
                    .diamond { fill: #fff3e0; stroke: #f57c00; stroke-width: 2; }
                    .text { font-family: Arial, sans-serif; font-size: 12px; text-anchor: middle; }
                    .title { font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; text-anchor: middle; }
                    .arrow { stroke: #424242; stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                </style>
                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                    <polygon points="0 0, 10 3.5, 0 7" fill="#424242" />
                </marker>
            </defs>
            
            <text x="200" y="20" class="title">\(title)</text>
            
            <!-- Start -->
            <rect x="160" y="40" width="80" height="40" rx="20" class="box"/>
            <text x="200" y="65" class="text">Start</text>
            
            <!-- Decision -->
            <polygon points="200,100 240,130 200,160 160,130" class="diamond"/>
            <text x="200" y="135" class="text">Decision?</text>
            
            <!-- Process 1 -->
            <rect x="100" y="180" width="80" height="40" class="box"/>
            <text x="140" y="205" class="text">Process A</text>
            
            <!-- Process 2 -->
            <rect x="220" y="180" width="80" height="40" class="box"/>
            <text x="260" y="205" class="text">Process B</text>
            
            <!-- End -->
            <rect x="160" y="240" width="80" height="40" rx="20" class="box"/>
            <text x="200" y="265" class="text">End</text>
            
            <!-- Arrows -->
            <line x1="200" y1="80" x2="200" y2="100" class="arrow"/>
            <line x1="180" y1="145" x2="140" y2="180" class="arrow"/>
            <line x1="220" y1="145" x2="260" y2="180" class="arrow"/>
            <line x1="140" y1="220" x2="180" y2="240" class="arrow"/>
            <line x1="260" y1="220" x2="220" y2="240" class="arrow"/>
            
            <!-- Labels -->
            <text x="150" y="165" class="text" style="font-size: 10px;">Yes</text>
            <text x="250" y="165" class="text" style="font-size: 10px;">No</text>
        </svg>
        """
    }
    
    private func generateSequenceSVG(title: String) -> String {
        return """
        <svg width="500" height="300" viewBox="0 0 500 300" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <style>
                    .lifeline { stroke: #424242; stroke-width: 2; stroke-dasharray: 5,5; }
                    .actor { fill: #e3f2fd; stroke: #1976d2; stroke-width: 2; }
                    .message { stroke: #424242; stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                    .text { font-family: Arial, sans-serif; font-size: 12px; text-anchor: middle; }
                    .title { font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; text-anchor: middle; }
                    .msg-text { font-family: Arial, sans-serif; font-size: 10px; text-anchor: middle; }
                </style>
                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                    <polygon points="0 0, 10 3.5, 0 7" fill="#424242" />
                </marker>
            </defs>
            
            <text x="250" y="20" class="title">\(title)</text>
            
            <!-- Actors -->
            <rect x="50" y="40" width="80" height="40" class="actor"/>
            <text x="90" y="65" class="text">Client</text>
            
            <rect x="200" y="40" width="80" height="40" class="actor"/>
            <text x="240" y="65" class="text">Server</text>
            
            <rect x="350" y="40" width="80" height="40" class="actor"/>
            <text x="390" y="65" class="text">Database</text>
            
            <!-- Lifelines -->
            <line x1="90" y1="80" x2="90" y2="280" class="lifeline"/>
            <line x1="240" y1="80" x2="240" y2="280" class="lifeline"/>
            <line x1="390" y1="80" x2="390" y2="280" class="lifeline"/>
            
            <!-- Messages -->
            <line x1="90" y1="120" x2="240" y2="120" class="message"/>
            <text x="165" y="115" class="msg-text">Request</text>
            
            <line x1="240" y1="150" x2="390" y2="150" class="message"/>
            <text x="315" y="145" class="msg-text">Query</text>
            
            <line x1="390" y1="180" x2="240" y2="180" class="message"/>
            <text x="315" y="175" class="msg-text">Result</text>
            
            <line x1="240" y1="210" x2="90" y2="210" class="message"/>
            <text x="165" y="205" class="msg-text">Response</text>
        </svg>
        """
    }
    
    private func generateComponentSVG(title: String) -> String {
        return """
        <svg width="400" height="300" viewBox="0 0 400 300" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <style>
                    .component { fill: #f3e5f5; stroke: #7b1fa2; stroke-width: 2; }
                    .interface { fill: #e8f5e8; stroke: #388e3c; stroke-width: 2; }
                    .connection { stroke: #424242; stroke-width: 2; fill: none; marker-end: url(#arrowhead); }
                    .text { font-family: Arial, sans-serif; font-size: 12px; text-anchor: middle; }
                    .title { font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; text-anchor: middle; }
                </style>
                <marker id="arrowhead" markerWidth="10" markerHeight="7" refX="9" refY="3.5" orient="auto">
                    <polygon points="0 0, 10 3.5, 0 7" fill="#424242" />
                </marker>
            </defs>
            
            <text x="200" y="20" class="title">\(title)</text>
            
            <!-- UI Component -->
            <rect x="50" y="50" width="100" height="60" class="component"/>
            <text x="100" y="85" class="text">UI Component</text>
            
            <!-- Business Logic -->
            <rect x="200" y="50" width="100" height="60" class="component"/>
            <text x="250" y="85" class="text">Business Logic</text>
            
            <!-- Data Layer -->
            <rect x="125" y="150" width="100" height="60" class="component"/>
            <text x="175" y="185" class="text">Data Layer</text>
            
            <!-- API Interface -->
            <circle cx="350" cy="80" r="30" class="interface"/>
            <text x="350" y="85" class="text">API</text>
            
            <!-- Database Interface -->
            <circle cx="175" cy="240" r="30" class="interface"/>
            <text x="175" y="245" class="text">DB</text>
            
            <!-- Connections -->
            <line x1="150" y1="80" x2="200" y2="80" class="connection"/>
            <line x1="300" y1="80" x2="320" y2="80" class="connection"/>
            <line x1="225" y1="110" x2="200" y2="150" class="connection"/>
            <line x1="175" y1="210" x2="175" y2="210" class="connection"/>
        </svg>
        """
    }
    
    private func generateArchitectureSVG(title: String) -> String {
        return """
        <svg width="500" height="350" viewBox="0 0 500 350" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <style>
                    .layer { fill: #fff8e1; stroke: #ff8f00; stroke-width: 2; }
                    .service { fill: #e1f5fe; stroke: #0277bd; stroke-width: 2; }
                    .database { fill: #e8f5e8; stroke: #388e3c; stroke-width: 2; }
                    .text { font-family: Arial, sans-serif; font-size: 11px; text-anchor: middle; }
                    .title { font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; text-anchor: middle; }
                    .layer-title { font-family: Arial, sans-serif; font-size: 14px; font-weight: bold; text-anchor: start; }
                </style>
            </defs>
            
            <text x="250" y="20" class="title">\(title)</text>
            
            <!-- Presentation Layer -->
            <rect x="20" y="40" width="460" height="60" class="layer"/>
            <text x="30" y="55" class="layer-title">Presentation Layer</text>
            <rect x="50" y="65" width="80" height="25" class="service"/>
            <text x="90" y="80" class="text">Web UI</text>
            <rect x="150" y="65" width="80" height="25" class="service"/>
            <text x="190" y="80" class="text">Mobile UI</text>
            <rect x="250" y="65" width="80" height="25" class="service"/>
            <text x="290" y="80" class="text">API Gateway</text>
            
            <!-- Business Layer -->
            <rect x="20" y="120" width="460" height="80" class="layer"/>
            <text x="30" y="135" class="layer-title">Business Layer</text>
            <rect x="50" y="145" width="100" height="25" class="service"/>
            <text x="100" y="160" class="text">User Service</text>
            <rect x="170" y="145" width="100" height="25" class="service"/>
            <text x="220" y="160" class="text">Order Service</text>
            <rect x="290" y="145" width="100" height="25" class="service"/>
            <text x="340" y="160" class="text">Payment Service</text>
            
            <!-- Data Layer -->
            <rect x="20" y="220" width="460" height="60" class="layer"/>
            <text x="30" y="235" class="layer-title">Data Layer</text>
            <rect x="80" y="245" width="80" height="25" class="database"/>
            <text x="120" y="260" class="text">User DB</text>
            <rect x="180" y="245" width="80" height="25" class="database"/>
            <text x="220" y="260" class="text">Order DB</text>
            <rect x="280" y="245" width="80" height="25" class="database"/>
            <text x="320" y="260" class="text">Payment DB</text>
            
            <!-- External Services -->
            <rect x="20" y="300" width="460" height="40" class="layer"/>
            <text x="30" y="315" class="layer-title">External Services</text>
            <rect x="100" y="320" width="100" height="15" class="service"/>
            <text x="150" y="330" class="text">Email Service</text>
            <rect x="220" y="320" width="100" height="15" class="service"/>
            <text x="270" y="330" class="text">SMS Service</text>
        </svg>
        """
    }
    
    private func generateClassDiagramSVG(title: String) -> String {
        return """
        <svg width="450" height="350" viewBox="0 0 450 350" xmlns="http://www.w3.org/2000/svg">
            <defs>
                <style>
                    .class { fill: #fff3e0; stroke: #e65100; stroke-width: 2; }
                    .interface { fill: #e8f5e8; stroke: #388e3c; stroke-width: 2; }
                    .inheritance { stroke: #424242; stroke-width: 2; fill: none; marker-end: url(#triangle); }
                    .composition { stroke: #424242; stroke-width: 2; fill: none; marker-end: url(#diamond); }
                    .text { font-family: Arial, sans-serif; font-size: 10px; text-anchor: middle; }
                    .title { font-family: Arial, sans-serif; font-size: 16px; font-weight: bold; text-anchor: middle; }
                    .class-name { font-family: Arial, sans-serif; font-size: 12px; font-weight: bold; text-anchor: middle; }
                    .member { font-family: Arial, sans-serif; font-size: 9px; text-anchor: start; }
                </style>
                <marker id="triangle" markerWidth="12" markerHeight="12" refX="12" refY="6" orient="auto">
                    <polygon points="0,0 12,6 0,12" fill="white" stroke="#424242" stroke-width="2"/>
                </marker>
                <marker id="diamond" markerWidth="12" markerHeight="12" refX="12" refY="6" orient="auto">
                    <polygon points="0,6 6,0 12,6 6,12" fill="white" stroke="#424242" stroke-width="2"/>
                </marker>
            </defs>
            
            <text x="225" y="20" class="title">\(title)</text>
            
            <!-- Animal Class -->
            <rect x="150" y="40" width="120" height="80" class="class"/>
            <text x="210" y="55" class="class-name">Animal</text>
            <line x1="150" y1="60" x2="270" y2="60" stroke="#e65100" stroke-width="1"/>
            <text x="155" y="75" class="member">- name: String</text>
            <text x="155" y="88" class="member">- age: Int</text>
            <line x1="150" y1="95" x2="270" y2="95" stroke="#e65100" stroke-width="1"/>
            <text x="155" y="108" class="member">+ makeSound()</text>
            
            <!-- Dog Class -->
            <rect x="50" y="180" width="120" height="80" class="class"/>
            <text x="110" y="195" class="class-name">Dog</text>
            <line x1="50" y1="200" x2="170" y2="200" stroke="#e65100" stroke-width="1"/>
            <text x="55" y="215" class="member">- breed: String</text>
            <line x1="50" y1="220" x2="170" y2="220" stroke="#e65100" stroke-width="1"/>
            <text x="55" y="235" class="member">+ bark()</text>
            <text x="55" y="248" class="member">+ makeSound()</text>
            
            <!-- Cat Class -->
            <rect x="250" y="180" width="120" height="80" class="class"/>
            <text x="310" y="195" class="class-name">Cat</text>
            <line x1="250" y1="200" x2="370" y2="200" stroke="#e65100" stroke-width="1"/>
            <text x="255" y="215" class="member">- indoor: Boolean</text>
            <line x1="250" y1="220" x2="370" y2="220" stroke="#e65100" stroke-width="1"/>
            <text x="255" y="235" class="member">+ meow()</text>
            <text x="255" y="248" class="member">+ makeSound()</text>
            
            <!-- Owner Class -->
            <rect x="150" y="290" width="120" height="50" class="class"/>
            <text x="210" y="305" class="class-name">Owner</text>
            <line x1="150" y1="310" x2="270" y2="310" stroke="#e65100" stroke-width="1"/>
            <text x="155" y="325" class="member">- pets: Animal[]</text>
            
            <!-- Inheritance arrows -->
            <line x1="110" y1="180" x2="180" y2="120" class="inheritance"/>
            <line x1="310" y1="180" x2="240" y2="120" class="inheritance"/>
            
            <!-- Composition arrow -->
            <line x1="210" y1="290" x2="210" y2="120" class="composition"/>
        </svg>
        """
    }
}

struct DiagramTypeCard: View {
    let type: DiagramType
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: type.icon)
                .font(.title2)
                .foregroundColor(isSelected ? .white : .accentColor)
            
            Text(type.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 80)
        .frame(maxWidth: .infinity)
        .background(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture {
            onSelect()
        }
    }
}

#Preview {
    DiagramGeneratorView(note: .constant(Note(
        title: "Sample Note",
        content: "Sample content",
        analysis: nil,
        diagrams: []
    )))
}