import SwiftUI
import AppKit

struct ContentView: View {
    @State private var notes: [Note] = []
    @State private var selectedNote: Note? = nil
    @State private var isAnalyzing = false
    
    var body: some View {
        NavigationSplitView {
            // Notes List
            NotesList(notes: $notes, selectedNote: $selectedNote)
        } detail: {
            // Note Detail/Editor
            if let selectedNote = selectedNote {
                NoteDetailView(
                    note: binding(for: selectedNote),
                    isAnalyzing: $isAnalyzing
                )
            } else {
                EmptyNoteView()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            setupInitialNotes()
        }
    }
    
    private func binding(for note: Note) -> Binding<Note> {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else {
            return .constant(note)
        }
        return $notes[index]
    }
    
    private func setupInitialNotes() {
        if notes.isEmpty {
            notes = [
                Note(title: "Welcome to AI Notes", content: "Paste content from Cursor here and get AI-powered diagrams!", analysis: nil, diagrams: [])
            ]
            selectedNote = notes.first
        }
    }
}

struct EmptyNoteView: View {
    var body: some View {
        VStack {
            Image(systemName: "note.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            Text("Select a note or create a new one")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ContentView()
}