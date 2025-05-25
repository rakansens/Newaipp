import SwiftUI
import AppKit

struct NoteDetailView: View {
    @Binding var note: Note
    @Binding var isAnalyzing: Bool
    @State private var contentText: String = ""
    @State private var showingDiagramGenerator = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            HStack {
                Text(note.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button("Paste from Cursor") {
                        pasteFromClipboard()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Analyze with AI") {
                        analyzeContent()
                    }
                    .disabled(contentText.isEmpty || isAnalyzing)
                    
                    Button("Generate Diagram") {
                        showingDiagramGenerator = true
                    }
                    .disabled(contentText.isEmpty)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            Divider()
            
            // Content Area
            HSplitView {
                // Text Editor
                VStack(alignment: .leading, spacing: 8) {
                    Text("Content")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    TextEditor(text: $contentText)
                        .font(.system(.body, design: .monospaced))
                        .padding(.horizontal, 16)
                        .onChange(of: contentText) { oldValue, newValue in
                            note.updateContent(newValue)
                        }
                }
                .frame(minWidth: 300)
                
                // AI Analysis & Diagrams
                VStack(alignment: .leading, spacing: 8) {
                    Text("AI Analysis & Diagrams")
                        .font(.headline)
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // AI Analysis Section
                            if isAnalyzing {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                    Text("Analyzing content...")
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 16)
                            } else if let analysis = note.analysis {
                                AnalysisView(analysis: analysis)
                                    .padding(.horizontal, 16)
                            } else {
                                Text("Click 'Analyze with AI' to get insights about your code")
                                    .foregroundColor(.secondary)
                                    .italic()
                                    .padding(.horizontal, 16)
                            }
                            
                            Divider()
                                .padding(.horizontal, 16)
                            
                            // Diagrams Section
                            DiagramsView(diagrams: note.diagrams)
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .frame(minWidth: 300)
            }
        }
        .onAppear {
            contentText = note.content
        }
        .sheet(isPresented: $showingDiagramGenerator) {
            DiagramGeneratorView(note: $note)
        }
    }
    
    private func pasteFromClipboard() {
        let pasteboard = NSPasteboard.general
        if let clipboardContent = pasteboard.string(forType: .string) {
            contentText = clipboardContent
            note.updateContent(clipboardContent)
        }
    }
    
    private func analyzeContent() {
        guard !contentText.isEmpty else { return }
        
        isAnalyzing = true
        
        // Simulate AI analysis with delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let analysis = generateMockAnalysis(for: contentText)
            note.updateAnalysis(analysis)
            isAnalyzing = false
        }
    }
    
    private func generateMockAnalysis(for content: String) -> String {
        // Mock AI analysis based on content patterns
        var insights: [String] = []
        
        if content.contains("func") || content.contains("function") {
            insights.append("• Detected function definitions - this appears to be code")
        }
        
        if content.contains("class") || content.contains("struct") {
            insights.append("• Object-oriented structures found - good for component diagrams")
        }
        
        if content.contains("import") || content.contains("require") {
            insights.append("• Module dependencies detected - architecture diagram recommended")
        }
        
        if content.contains("if") || content.contains("while") || content.contains("for") {
            insights.append("• Control flow logic present - flowchart would be helpful")
        }
        
        if content.contains("async") || content.contains("await") || content.contains("Promise") {
            insights.append("• Asynchronous patterns found - sequence diagram recommended")
        }
        
        if insights.isEmpty {
            insights.append("• General text content - consider creating a conceptual diagram")
        }
        
        let summary = "Analysis of your content:\n\n" + insights.joined(separator: "\n") + 
                     "\n\nRecommendation: Use the 'Generate Diagram' feature to visualize the structure and flow of your code."
        
        return summary
    }
}

struct AnalysisView: View {
    let analysis: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.blue)
                Text("AI Analysis")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Text(analysis)
                .font(.body)
                .textSelection(.enabled)
                .padding(12)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
        }
    }
}

#Preview {
    NoteDetailView(
        note: .constant(Note(
            title: "Sample Note",
            content: "func example() {\n    print(\"Hello World\")\n}",
            analysis: "This is a sample analysis",
            diagrams: []
        )),
        isAnalyzing: .constant(false)
    )
}