import SwiftUI
import NotesCore
import WebKit

struct NoteDetailView: View {
    @ObservedObject var note: Note
    @ObservedObject var notesManager: NotesManager
    @State private var isEditing = false
    @State private var editingTitle = ""
    @State private var editingContent = ""
    @State private var showingDiagramSheet = false
    @State private var generatedDiagrams: [Diagram] = []
    @State private var analysis: AIAnalysis?
    
    private let aiAnalyzer = AIAnalyzer()
    private let diagramGenerator = DiagramGenerator()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Header with title and actions
                headerView
                
                // Content
                contentView
                
                // AI Analysis section
                if let analysis = analysis {
                    aiAnalysisView(analysis)
                }
                
                // Generated diagrams
                if !generatedDiagrams.isEmpty {
                    diagramsView
                }
            }
            .padding()
        }
        .navigationTitle(note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(isEditing ? "Done" : "Edit") {
                    if isEditing {
                        saveChanges()
                    } else {
                        startEditing()
                    }
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button("Analyze with AI") {
                    analyzeContent()
                }
            }
        }
        .sheet(isPresented: $showingDiagramSheet) {
            DiagramGenerationView(
                content: note.content,
                diagramGenerator: diagramGenerator,
                onDiagramGenerated: { diagram in
                    generatedDiagrams.append(diagram)
                }
            )
        }
        .onAppear {
            setupEditingState()
        }
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if isEditing {
                TextField("Title", text: $editingTitle)
                    .font(.title2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(note.title)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            HStack {
                Text("Created: \\(note.createdAt, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text("Updated: \\(note.updatedAt, formatter: dateFormatter)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if isEditing {
                TextEditor(text: $editingContent)
                    .font(.system(.body, design: .monospaced))
                    .frame(minHeight: 200)
                    .border(Color.gray.opacity(0.3))
            } else {
                ScrollView {
                    Text(note.content)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                .frame(maxHeight: 300)
            }
            
            if note.containsCode() {
                Label("Contains code", systemImage: "chevron.left.forwardslash.chevron.right")
                    .font(.caption)
                    .foregroundColor(.blue)
                    .padding(.top, 4)
            }
        }
    }
    
    private func aiAnalysisView(_ analysis: AIAnalysis) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("AI Analysis")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Content Type:")
                        .fontWeight(.medium)
                    Text("\\(analysis.contentType)")
                        .foregroundColor(.secondary)
                }
                
                if let language = analysis.programmingLanguage {
                    HStack {
                        Text("Language:")
                            .fontWeight(.medium)
                        Text(language)
                            .foregroundColor(.blue)
                    }
                }
                
                if !analysis.patterns.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Detected Patterns:")
                            .fontWeight(.medium)
                        ForEach(Array(analysis.patterns), id: \\.self) { pattern in
                            Text("• \\(pattern)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if !analysis.suggestedDiagrams.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Suggested Diagrams:")
                            .fontWeight(.medium)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                            ForEach(analysis.suggestedDiagrams, id: \\.self) { diagramType in
                                Button(diagramType.displayName) {
                                    generateDiagram(type: diagramType)
                                }
                                .buttonStyle(.bordered)
                                .font(.caption)
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private var diagramsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Generated Diagrams")
                .font(.headline)
            
            ForEach(generatedDiagrams, id: \\.id) { diagram in
                DiagramView(diagram: diagram)
            }
        }
    }
    
    private func setupEditingState() {
        editingTitle = note.title
        editingContent = note.content
    }
    
    private func startEditing() {
        setupEditingState()
        isEditing = true
    }
    
    private func saveChanges() {
        notesManager.updateNote(note, title: editingTitle, content: editingContent)
        isEditing = false
    }
    
    private func analyzeContent() {
        analysis = aiAnalyzer.analyzeContent(note.content)
    }
    
    private func generateDiagram(type: DiagramType) {
        if let diagram = diagramGenerator.generateDiagram(type: type, content: note.content) {
            generatedDiagrams.append(diagram)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct DiagramView: View {
    let diagram: Diagram
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(diagram.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(isExpanded ? "Collapse" : "Expand") {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .font(.caption)
            }
            
            if isExpanded {
                WebView(svgContent: diagram.svgContent)
                    .frame(height: 300)
                    .border(Color.gray.opacity(0.3))
            }
        }
        .padding()
        .background(Color.blue.opacity(0.05))
        .cornerRadius(8)
    }
}

struct WebView: NSViewRepresentable {
    let svgContent: String
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { margin: 0; padding: 10px; font-family: Arial, sans-serif; }
                svg { max-width: 100%; height: auto; }
            </style>
        </head>
        <body>
            \\(svgContent)
        </body>
        </html>
        """
        nsView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

struct DiagramGenerationView: View {
    let content: String
    let diagramGenerator: DiagramGenerator
    let onDiagramGenerated: (Diagram) -> Void
    @Environment(\\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Generate Diagram")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Choose the type of diagram to generate:")
                    .foregroundColor(.secondary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                    ForEach(DiagramType.allCases, id: \\.self) { diagramType in
                        Button(action: {
                            generateDiagram(type: diagramType)
                        }) {
                            VStack(spacing: 8) {
                                Image(systemName: iconForDiagramType(diagramType))
                                    .font(.title)
                                
                                Text(diagramType.displayName)
                                    .font(.caption)
                                    .multilineTextAlignment(.center)
                            }
                            .frame(height: 80)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func generateDiagram(type: DiagramType) {
        if let diagram = diagramGenerator.generateDiagram(type: type, content: content) {
            onDiagramGenerated(diagram)
            dismiss()
        }
    }
    
    private func iconForDiagramType(_ type: DiagramType) -> String {
        switch type {
        case .classDiagram:
            return "rectangle.3.group"
        case .sequenceDiagram:
            return "arrow.right.arrow.left"
        case .flowChart:
            return "flowchart"
        case .componentDiagram:
            return "square.3.layers.3d"
        case .architectureDiagram:
            return "building.2"
        }
    }
}

struct NewNoteView: View {
    @ObservedObject var notesManager: NotesManager
    @Environment(\\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                TextField("Note title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $content)
                    .font(.system(.body, design: .monospaced))
                    .border(Color.gray.opacity(0.3))
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveNote()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
    
    private func saveNote() {
        notesManager.createNote(title: title, content: content)
        dismiss()
    }
}

#Preview {
    let note = Note(title: "Sample Note", content: "This is sample content")
    let manager = NotesManager()
    return NoteDetailView(note: note, notesManager: manager)
}