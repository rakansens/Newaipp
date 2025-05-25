import XCTest
@testable import NotesCore

final class DiagramGeneratorTests: XCTestCase {
    
    var generator: DiagramGenerator!
    
    override func setUp() {
        super.setUp()
        generator = DiagramGenerator()
    }
    
    override func tearDown() {
        generator = nil
        super.tearDown()
    }
    
    // MARK: - Class Diagram Tests
    
    func testGenerateClassDiagram() {
        // Given
        let classCode = """
        class User {
            var id: String
            var name: String
            func login() -> Bool { return true }
        }
        
        class AdminUser: User {
            func deleteUser() { }
        }
        """
        
        // When
        let diagram = generator.generateDiagram(type: .classDiagram, content: classCode)
        
        // Then
        XCTAssertNotNil(diagram)
        XCTAssertEqual(diagram?.type, .classDiagram)
        XCTAssertTrue(diagram?.svgContent.contains("User") ?? false)
        XCTAssertTrue(diagram?.svgContent.contains("AdminUser") ?? false)
        XCTAssertTrue(diagram?.svgContent.contains("inheritance") ?? false)
    }
    
    // MARK: - Flow Chart Tests
    
    func testGenerateFlowChart() {
        // Given
        let processContent = """
        1. Start process
        2. Check if user is logged in
        3. If yes: show dashboard
        4. If no: redirect to login
        5. End process
        """
        
        // When
        let diagram = generator.generateDiagram(type: .flowChart, content: processContent)
        
        // Then
        XCTAssertNotNil(diagram)
        XCTAssertEqual(diagram?.type, .flowChart)
        XCTAssertTrue(diagram?.svgContent.contains("Start") ?? false)
        XCTAssertTrue(diagram?.svgContent.contains("decision") ?? false)
        XCTAssertTrue(diagram?.svgContent.contains("End") ?? false)
    }
    
    // MARK: - Sequence Diagram Tests
    
    func testGenerateSequenceDiagram() {
        // Given
        let sequenceContent = """
        User -> Frontend: Click login
        Frontend -> API: POST /auth/login
        API -> Database: Validate credentials
        Database -> API: Return user data
        API -> Frontend: Return JWT token
        Frontend -> User: Show dashboard
        """
        
        // When
        let diagram = generator.generateDiagram(type: .sequenceDiagram, content: sequenceContent)
        
        // Then
        XCTAssertNotNil(diagram)
        XCTAssertEqual(diagram?.type, .sequenceDiagram)
        XCTAssertTrue(diagram?.svgContent.contains("User") ?? false)
        XCTAssertTrue(diagram?.svgContent.contains("Frontend") ?? false)
        XCTAssertTrue(diagram?.svgContent.contains("API") ?? false)
    }
    
    // MARK: - Component Diagram Tests
    
    func testGenerateComponentDiagram() {
        // Given
        let componentContent = """
        Frontend Components:
        - UserInterface
        - AuthenticationService
        - DataService
        
        Backend Components:
        - API Gateway
        - User Service
        - Database Layer
        """
        
        // When
        let diagram = generator.generateDiagram(type: .componentDiagram, content: componentContent)
        
        // Then
        XCTAssertNotNil(diagram)
        XCTAssertEqual(diagram?.type, .componentDiagram)
        XCTAssertTrue(diagram?.svgContent.contains("component") ?? false)
    }
    
    // MARK: - Architecture Diagram Tests
    
    func testGenerateArchitectureDiagram() {
        // Given
        let architectureContent = """
        System Architecture:
        Presentation Layer: Web Frontend
        Business Layer: API Services
        Data Layer: Database
        External: Third-party APIs
        """
        
        // When
        let diagram = generator.generateDiagram(type: .architectureDiagram, content: architectureContent)
        
        // Then
        XCTAssertNotNil(diagram)
        XCTAssertEqual(diagram?.type, .architectureDiagram)
        XCTAssertTrue(diagram?.svgContent.contains("layer") ?? false)
    }
    
    // MARK: - Error Handling Tests
    
    func testGenerateDiagramWithInvalidContent() {
        // Given
        let invalidContent = ""
        
        // When
        let diagram = generator.generateDiagram(type: .classDiagram, content: invalidContent)
        
        // Then
        XCTAssertNil(diagram)
    }
    
    func testGenerateDiagramWithMismatchedType() {
        // Given
        let classContent = "class User { }"
        
        // When
        let diagram = generator.generateDiagram(type: .sequenceDiagram, content: classContent)
        
        // Then
        // Should still generate a diagram but might be less accurate
        XCTAssertNotNil(diagram)
    }
}