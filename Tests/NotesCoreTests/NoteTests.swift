import XCTest
@testable import NotesCore

final class NoteTests: XCTestCase {
    
    // MARK: - Note Model Tests
    
    func testNoteInitialization() {
        // Given
        let title = "Test Note"
        let content = "This is test content"
        
        // When
        let note = Note(title: title, content: content)
        
        // Then
        XCTAssertEqual(note.title, title)
        XCTAssertEqual(note.content, content)
        XCTAssertNotNil(note.id)
        XCTAssertNotNil(note.createdAt)
        XCTAssertNotNil(note.updatedAt)
        XCTAssertEqual(note.createdAt, note.updatedAt)
    }
    
    func testNoteUpdate() {
        // Given
        let note = Note(title: "Original", content: "Original content")
        let originalUpdatedAt = note.updatedAt
        
        // When
        note.update(title: "Updated", content: "Updated content")
        
        // Then
        XCTAssertEqual(note.title, "Updated")
        XCTAssertEqual(note.content, "Updated content")
        XCTAssertGreaterThan(note.updatedAt, originalUpdatedAt)
    }
    
    func testNoteContentAnalysis() {
        // Given
        let swiftCode = """
        func calculateSum(a: Int, b: Int) -> Int {
            return a + b
        }
        """
        let note = Note(title: "Swift Function", content: swiftCode)
        
        // When
        let hasCode = note.containsCode()
        
        // Then
        XCTAssertTrue(hasCode)
    }
    
    func testNoteWithoutCode() {
        // Given
        let plainText = "This is just plain text without any code"
        let note = Note(title: "Plain Text", content: plainText)
        
        // When
        let hasCode = note.containsCode()
        
        // Then
        XCTAssertFalse(hasCode)
    }
}