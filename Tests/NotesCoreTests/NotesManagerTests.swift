import XCTest
@testable import NotesCore

final class NotesManagerTests: XCTestCase {
    
    var notesManager: NotesManager!
    
    override func setUp() {
        super.setUp()
        notesManager = NotesManager()
    }
    
    override func tearDown() {
        notesManager = nil
        super.tearDown()
    }
    
    // MARK: - Notes Management Tests
    
    func testCreateNote() {
        // Given
        let title = "Test Note"
        let content = "Test content"
        
        // When
        let note = notesManager.createNote(title: title, content: content)
        
        // Then
        XCTAssertEqual(note.title, title)
        XCTAssertEqual(note.content, content)
        XCTAssertEqual(notesManager.notes.count, 1)
        XCTAssertEqual(notesManager.notes.first?.id, note.id)
    }
    
    func testUpdateNote() {
        // Given
        let note = notesManager.createNote(title: "Original", content: "Original content")
        let newTitle = "Updated Title"
        let newContent = "Updated content"
        
        // When
        notesManager.updateNote(note, title: newTitle, content: newContent)
        
        // Then
        XCTAssertEqual(note.title, newTitle)
        XCTAssertEqual(note.content, newContent)
        XCTAssertEqual(notesManager.notes.count, 1)
    }
    
    func testDeleteNote() {
        // Given
        let note1 = notesManager.createNote(title: "Note 1", content: "Content 1")
        let note2 = notesManager.createNote(title: "Note 2", content: "Content 2")
        XCTAssertEqual(notesManager.notes.count, 2)
        
        // When
        notesManager.deleteNote(note1)
        
        // Then
        XCTAssertEqual(notesManager.notes.count, 1)
        XCTAssertEqual(notesManager.notes.first?.id, note2.id)
    }
    
    func testFindNoteById() {
        // Given
        let note = notesManager.createNote(title: "Test", content: "Content")
        
        // When
        let foundNote = notesManager.findNote(by: note.id)
        
        // Then
        XCTAssertNotNil(foundNote)
        XCTAssertEqual(foundNote?.id, note.id)
    }
    
    func testFindNonExistentNote() {
        // Given
        let nonExistentId = UUID()
        
        // When
        let foundNote = notesManager.findNote(by: nonExistentId)
        
        // Then
        XCTAssertNil(foundNote)
    }
    
    // MARK: - Search Tests
    
    func testSearchNotesByTitle() {
        // Given
        notesManager.createNote(title: "Swift Programming", content: "Content about Swift")
        notesManager.createNote(title: "Python Basics", content: "Content about Python")
        notesManager.createNote(title: "Swift Advanced", content: "Advanced Swift topics")
        
        // When
        let results = notesManager.searchNotes(query: "Swift")
        
        // Then
        XCTAssertEqual(results.count, 2)
        XCTAssertTrue(results.allSatisfy { $0.title.contains("Swift") })
    }
    
    func testSearchNotesByContent() {
        // Given
        notesManager.createNote(title: "Programming", content: "This note contains Swift code examples")
        notesManager.createNote(title: "Cooking", content: "Recipe for apple pie")
        
        // When
        let results = notesManager.searchNotes(query: "Swift")
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.title, "Programming")
    }
    
    func testSearchWithNoResults() {
        // Given
        notesManager.createNote(title: "Note 1", content: "Content 1")
        notesManager.createNote(title: "Note 2", content: "Content 2")
        
        // When
        let results = notesManager.searchNotes(query: "NonExistent")
        
        // Then
        XCTAssertTrue(results.isEmpty)
    }
    
    // MARK: - Sorting Tests
    
    func testSortNotesByCreationDate() {
        // Given
        let note1 = notesManager.createNote(title: "First", content: "Content 1")
        Thread.sleep(forTimeInterval: 0.01) // Ensure different timestamps
        let note2 = notesManager.createNote(title: "Second", content: "Content 2")
        Thread.sleep(forTimeInterval: 0.01)
        let note3 = notesManager.createNote(title: "Third", content: "Content 3")
        
        // When
        let sortedNotes = notesManager.getNotesSorted(by: .creationDate, ascending: false)
        
        // Then
        XCTAssertEqual(sortedNotes.count, 3)
        XCTAssertEqual(sortedNotes[0].id, note3.id) // Most recent first
        XCTAssertEqual(sortedNotes[1].id, note2.id)
        XCTAssertEqual(sortedNotes[2].id, note1.id)
    }
    
    func testSortNotesByTitle() {
        // Given
        notesManager.createNote(title: "Zebra", content: "Content")
        notesManager.createNote(title: "Apple", content: "Content")
        notesManager.createNote(title: "Banana", content: "Content")
        
        // When
        let sortedNotes = notesManager.getNotesSorted(by: .title, ascending: true)
        
        // Then
        XCTAssertEqual(sortedNotes.count, 3)
        XCTAssertEqual(sortedNotes[0].title, "Apple")
        XCTAssertEqual(sortedNotes[1].title, "Banana")
        XCTAssertEqual(sortedNotes[2].title, "Zebra")
    }
}