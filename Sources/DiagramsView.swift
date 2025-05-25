import SwiftUI
import WebKit

struct DiagramsView: View {
    let diagrams: [DiagramData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "chart.bar.xaxis")
                    .foregroundColor(.green)
                Text("Generated Diagrams")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            if diagrams.isEmpty {
                Text("No diagrams yet. Generate one using the 'Generate Diagram' button.")
                    .foregroundColor(.secondary)
                    .italic()
            } else {
                ForEach(diagrams) { diagram in
                    DiagramCardView(diagram: diagram)
                }
            }
        }
    }
}

struct DiagramCardView: View {
    let diagram: DiagramData
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                Image(systemName: diagram.type.icon)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(diagram.title)
                        .font(.headline)
                    Text(diagram.type.displayName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .buttonStyle(.borderless)
            }
            
            // Description
            Text(diagram.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Diagram Content (when expanded)
            if isExpanded {
                DiagramWebView(svgContent: diagram.svgContent)
                    .frame(height: 300)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .padding(12)
        .background(Color.green.opacity(0.1))
        .cornerRadius(8)
    }
}

struct DiagramWebView: NSViewRepresentable {
    let svgContent: String
    
    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        let htmlContent = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                body {
                    margin: 0;
                    padding: 20px;
                    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
                    background: transparent;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    min-height: 100vh;
                }
                .diagram-container {
                    text-align: center;
                    max-width: 100%;
                    overflow: auto;
                }
                svg {
                    max-width: 100%;
                    height: auto;
                }
            </style>
        </head>
        <body>
            <div class="diagram-container">
                \(svgContent)
            </div>
        </body>
        </html>
        """
        nsView.loadHTMLString(htmlContent, baseURL: nil)
    }
}

#Preview {
    DiagramsView(diagrams: [
        DiagramData(
            type: .flowchart,
            title: "Sample Flowchart",
            description: "A sample flowchart showing process flow",
            svgContent: "<svg><text x='50' y='50'>Sample Diagram</text></svg>"
        )
    ])
}