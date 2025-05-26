import XCTest
@testable import Newaipp
@testable import NotesCore

final class CursorIntegrationTests: XCTestCase {
    
    var cursorIntegration: CursorIntegration!
    
    override func setUp() {
        super.setUp()
        cursorIntegration = CursorIntegration()
    }
    
    override func tearDown() {
        cursorIntegration = nil
        super.tearDown()
    }
    
    // MARK: - Clipboard Integration Tests
    
    func testReadFromClipboard() {
        // Given - This test would require mocking the system clipboard
        // For now, we'll test the method exists and handles empty clipboard
        
        // When
        let content = cursorIntegration.readFromClipboard()
        
        // Then
        XCTAssertNotNil(content) // Should return empty string if no content
    }
    
    func testDetectCursorContent() {
        // Given
        let cursorContent = """
        // From Cursor Editor
        func calculateTax(income: Double) -> Double {
            let taxRate = 0.25
            return income * taxRate
        }
        """
        
        // When
        let isCursorContent = cursorIntegration.detectCursorContent(cursorContent)
        
        // Then
        XCTAssertTrue(isCursorContent)
    }
    
    func testDetectNonCursorContent() {
        // Given
        let regularContent = "Just some regular text from another app"
        
        // When
        let isCursorContent = cursorIntegration.detectCursorContent(regularContent)
        
        // Then
        XCTAssertFalse(isCursorContent)
    }
    
    // MARK: - Content Processing Tests
    
    func testProcessCursorCode() {
        // Given
        let codeContent = """
        import React from 'react';
        
        const UserComponent = ({ user }) => {
            return <div>{user.name}</div>;
        };
        
        export default UserComponent;
        """
        
        // When
        let processedContent = cursorIntegration.processCursorContent(codeContent)
        
        // Then
        XCTAssertNotNil(processedContent)
        XCTAssertTrue(processedContent.content.contains("React"))
        XCTAssertEqual(processedContent.detectedLanguage, "JavaScript")
        XCTAssertTrue(processedContent.isCode)
    }
    
    func testProcessCursorText() {
        // Given
        let textContent = """
        Project Requirements:
        - User authentication system
        - Dashboard with metrics
        - Data export functionality
        """
        
        // When
        let processedContent = cursorIntegration.processCursorContent(textContent)
        
        // Then
        XCTAssertNotNil(processedContent)
        XCTAssertTrue(processedContent.content.contains("Requirements"))
        XCTAssertNil(processedContent.detectedLanguage)
        XCTAssertFalse(processedContent.isCode)
    }
    
    // MARK: - Auto-paste Tests
    
    func testAutoPasteEnabled() {
        // Given
        cursorIntegration.enableAutoPaste()
        
        // When
        let isEnabled = cursorIntegration.isAutoPasteEnabled()
        
        // Then
        XCTAssertTrue(isEnabled)
    }
    
    func testAutoPasteDisabled() {
        // Given
        cursorIntegration.disableAutoPaste()
        
        // When
        let isEnabled = cursorIntegration.isAutoPasteEnabled()
        
        // Then
        XCTAssertFalse(isEnabled)
    }
    
    // MARK: - Integration with Notes Tests
    
    func testCreateNoteFromCursorContent() {
        // Given
        let swiftCode = """
        struct User {
            let id: UUID
            let name: String
            let email: String
        }
        """
        let notesManager = NotesManager()
        
        // When
        let note = cursorIntegration.createNoteFromCursor(
            content: swiftCode,
            notesManager: notesManager
        )
        
        // Then
        XCTAssertNotNil(note)
        XCTAssertTrue(note?.title.contains("Swift") ?? false)
        XCTAssertEqual(note?.content, swiftCode)
        XCTAssertEqual(notesManager.notes.count, 1)
    }
    
    func testAutoGenerateTitleFromCode() {
        // Given
        let pythonCode = """
        def calculate_fibonacci(n):
            if n <= 1:
                return n
            return calculate_fibonacci(n-1) + calculate_fibonacci(n-2)
        """
        
        // When
        let title = cursorIntegration.generateTitleFromContent(pythonCode)
        
        // Then
        XCTAssertTrue(title.contains("Python"))
        XCTAssertTrue(title.contains("fibonacci") || title.contains("function"))
    }
    
    func testAutoGenerateTitleFromText() {
        // Given
        let meetingNotes = """
        Meeting Notes - Project Planning
        Attendees: John, Sarah, Mike
        Date: Today
        
        Discussion points:
        - Timeline for Q1 delivery
        - Resource allocation
        """
        
        // When
        let title = cursorIntegration.generateTitleFromContent(meetingNotes)
        
        // Then
        XCTAssertTrue(title.contains("Meeting") || title.contains("Project"))
    }
}