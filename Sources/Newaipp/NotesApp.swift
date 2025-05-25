import SwiftUI
import NotesCore

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(DefaultWindowStyle())
    }
}

struct ContentView: View {
    @StateObject private var notesManager = NotesManager()
    @StateObject private var cursorIntegration = CursorIntegration()
    @State private var selectedNote: Note?
    @State private var showingNewNoteSheet = false
    @State private var searchText = ""
    
    var filteredNotes: [Note] {
        if searchText.isEmpty {
            return notesManager.notes
        } else {
            return notesManager.searchNotes(query: searchText)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            VStack {
                // Search bar
                SearchField(text: $searchText)
                    .padding(.horizontal)
                
                // Notes list
                List(filteredNotes, id: \\.id, selection: $selectedNote) { note in
                    NoteListItemView(note: note)
                }
                .navigationTitle("Notes")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button("New Note") {
                            showingNewNoteSheet = true
                        }
                    }
                    
                    ToolbarItem(placement: .secondaryAction) {
                        Button("Paste from Cursor") {
                            pasteFromCursor()
                        }
                    }
                }
            }
        } detail: {
            if let selectedNote = selectedNote {
                NoteDetailView(note: selectedNote, notesManager: notesManager)
            } else {
                Text("Select a note to view details")
                    .foregroundColor(.secondary)
            }
        }
        .sheet(isPresented: $showingNewNoteSheet) {
            NewNoteView(notesManager: notesManager)
        }
    }
    
    private func pasteFromCursor() {
        let clipboardContent = cursorIntegration.readFromClipboard()
        guard !clipboardContent.isEmpty else { return }
        
        if let newNote = cursorIntegration.createNoteFromCursor(content: clipboardContent, notesManager: notesManager) {
            selectedNote = newNote
        }
    }
}

struct NoteListItemView: View {
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(note.content)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                if note.containsCode() {
                    Label("Code", systemImage: "chevron.left.forwardslash.chevron.right")
                        .font(.caption2)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text(note.updatedAt, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct SearchField: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Search notes...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    ContentView()
}