import XCTest
@testable import NotesCore

final class AIAnalyzerTests: XCTestCase {
    
    var analyzer: AIAnalyzer!
    
    override func setUp() {
        super.setUp()
        analyzer = AIAnalyzer()
    }
    
    override func tearDown() {
        analyzer = nil
        super.tearDown()
    }
    
    // MARK: - Content Analysis Tests
    
    func testAnalyzeSwiftCode() {
        // Given
        let swiftCode = """
        class UserService {
            func fetchUser(id: String) -> User? {
                return database.find(User.self, id: id)
            }
        }
        """
        
        // When
        let analysis = analyzer.analyzeContent(swiftCode)
        
        // Then
        XCTAssertEqual(analysis.contentType, .code)
        XCTAssertEqual(analysis.programmingLanguage, "Swift")
        XCTAssertTrue(analysis.patterns.contains(.classDefinition))
        XCTAssertTrue(analysis.patterns.contains(.functionDefinition))
    }
    
    func testAnalyzeJavaScriptCode() {
        // Given
        let jsCode = """
        const express = require('express');
        const app = express();
        
        app.get('/api/users', (req, res) => {
            res.json({ users: [] });
        });
        """
        
        // When
        let analysis = analyzer.analyzeContent(jsCode)
        
        // Then
        XCTAssertEqual(analysis.contentType, .code)
        XCTAssertEqual(analysis.programmingLanguage, "JavaScript")
        XCTAssertTrue(analysis.patterns.contains(.apiEndpoint))
        XCTAssertTrue(analysis.patterns.contains(.functionDefinition))
    }
    
    func testAnalyzePlainText() {
        // Given
        let plainText = "This is just regular text about project requirements and planning."
        
        // When
        let analysis = analyzer.analyzeContent(plainText)
        
        // Then
        XCTAssertEqual(analysis.contentType, .text)
        XCTAssertNil(analysis.programmingLanguage)
        XCTAssertTrue(analysis.patterns.isEmpty)
    }
    
    func testAnalyzeArchitecturalContent() {
        // Given
        let architecturalText = """
        System Architecture:
        - Frontend: React with TypeScript
        - Backend: Node.js with Express
        - Database: PostgreSQL
        - Cache: Redis
        - Message Queue: RabbitMQ
        """
        
        // When
        let analysis = analyzer.analyzeContent(architecturalText)
        
        // Then
        XCTAssertEqual(analysis.contentType, .architecture)
        XCTAssertTrue(analysis.patterns.contains(.systemArchitecture))
        XCTAssertTrue(analysis.patterns.contains(.databaseDesign))
    }
    
    // MARK: - Diagram Suggestion Tests
    
    func testSuggestDiagramForClass() {
        // Given
        let classCode = """
        class Animal {
            var name: String
            init(name: String) { self.name = name }
        }
        
        class Dog: Animal {
            func bark() { print("Woof!") }
        }
        """
        
        // When
        let suggestions = analyzer.suggestDiagrams(for: classCode)
        
        // Then
        XCTAssertTrue(suggestions.contains(.classDiagram))
        XCTAssertFalse(suggestions.contains(.sequenceDiagram))
    }
    
    func testSuggestDiagramForSequence() {
        // Given
        let sequenceCode = """
        1. User clicks login button
        2. Frontend sends request to API
        3. API validates credentials
        4. API returns JWT token
        5. Frontend stores token
        """
        
        // When
        let suggestions = analyzer.suggestDiagrams(for: sequenceCode)
        
        // Then
        XCTAssertTrue(suggestions.contains(.sequenceDiagram))
        XCTAssertTrue(suggestions.contains(.flowChart))
    }
}