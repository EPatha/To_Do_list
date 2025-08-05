import XCTest
@testable import todo_list_macos

class TaskTests: XCTestCase {

    var task: Task!

    override func setUp() {
        super.setUp()
        task = Task(title: "Test Task", description: "This is a test task.", isCompleted: false)
    }

    override func tearDown() {
        task = nil
        super.tearDown()
    }

    func testTaskInitialization() {
        XCTAssertEqual(task.title, "Test Task")
        XCTAssertEqual(task.description, "This is a test task.")
        XCTAssertFalse(task.isCompleted)
    }

    func testTaskCompletion() {
        task.isCompleted = true
        XCTAssertTrue(task.isCompleted)
    }

    func testTaskDescriptionUpdate() {
        task.description = "Updated description."
        XCTAssertEqual(task.description, "Updated description.")
    }
}