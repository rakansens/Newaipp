import Foundation

public enum SortOption {
    case creationDate
    case title
    case updatedDate
}

public class NotesManager: ObservableObject {
    @Published public var notes: [Note] = []
    
    public init() {}
    
    // MARK: - CRUD Operations
    
    @discardableResult
    public func createNote(title: String, content: String) -> Note {
        let note = Note(title: title, content: content)
        notes.append(note)
        return note
    }
    
    public func updateNote(_ note: Note, title: String, content: String) {
        note.update(title: title, content: content)
    }
    
    public func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }
    
    public func findNote(by id: UUID) -> Note? {
        return notes.first { $0.id == id }
    }
    
    // MARK: - Search
    
    public func searchNotes(query: String) -> [Note] {
        guard !query.isEmpty else { return notes }
        
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(query) ||
            note.content.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Sorting
    
    public func getNotesSorted(by option: SortOption, ascending: Bool = true) -> [Note] {
        let sortedNotes: [Note]
        
        switch option {
        case .creationDate:
            sortedNotes = notes.sorted { ascending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt }
        case .title:
            sortedNotes = notes.sorted { ascending ? $0.title < $1.title : $0.title > $1.title }
        case .updatedDate:
            sortedNotes = notes.sorted { ascending ? $0.updatedAt < $1.updatedAt : $0.updatedAt > $1.updatedAt }
        }
        
        return sortedNotes
    }
    
    // MARK: - Utility Methods
    
    public func getNotesCount() -> Int {
        return notes.count
    }
    
    public func getNotesWithCode() -> [Note] {
        return notes.filter { $0.containsCode() }
    }
    
    public func getRecentNotes(limit: Int = 5) -> [Note] {
        return Array(getNotesSorted(by: .creationDate, ascending: false).prefix(limit))
    }
}