import SwiftUI

struct NotesList: View {
    @Binding var notes: [Note]
    @Binding var selectedNote: Note?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Notes")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: createNewNote) {
                    Image(systemName: "plus")
                        .font(.title3)
                }
                .buttonStyle(.borderless)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            Divider()
            
            // Notes List
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(notes.sorted(by: { $0.modifiedAt > $1.modifiedAt })) { note in
                        NoteRowView(
                            note: note,
                            isSelected: selectedNote?.id == note.id,
                            onSelect: { selectedNote = note },
                            onDelete: { deleteNote(note) }
                        )
                    }
                }
            }
        }
        .frame(minWidth: 250, maxWidth: 350)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func createNewNote() {
        let newNote = Note(
            title: "New Note",
            content: "",
            analysis: nil,
            diagrams: []
        )
        notes.append(newNote)
        selectedNote = newNote
    }
    
    private func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        if selectedNote?.id == note.id {
            selectedNote = notes.first
        }
    }
}

struct NoteRowView: View {
    let note: Note
    let isSelected: Bool
    let onSelect: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(note.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(note.content.isEmpty ? "No content" : note.content)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                    
                    HStack {
                        Text(formatDate(note.modifiedAt))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if !note.diagrams.isEmpty {
                            HStack(spacing: 2) {
                                Image(systemName: "chart.bar")
                                    .font(.caption2)
                                Text("\(note.diagrams.count)")
                                    .font(.caption2)
                            }
                            .foregroundColor(.accentColor)
                        }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
        .contentShape(Rectangle())
        .onTapGesture {
            onSelect()
        }
        .contextMenu {
            Button("Delete", action: onDelete)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    NotesList(
        notes: .constant([
            Note(title: "Sample Note", content: "This is a sample note content", analysis: nil, diagrams: []),
            Note(title: "Another Note", content: "More content here", analysis: "Some analysis", diagrams: [])
        ]),
        selectedNote: .constant(nil)
    )
}