//
//  UnitTestProjectTests.swift
//  UnitTestProjectTests
//
//  Created by SHIN YOON AH on 8/11/24.
//

import Testing
@testable import UnitTestProject

struct TestProject {
    @Test(
        arguments: [
            "1 + 2 + 3 - 1",
            "2 + 4 - 1",
            "7 - 3 + 1"
        ]
    )
    func calculated_Result_Is_Valid(expression: String) async throws {
        let calculator = MockCalculator()
        let sut = createStudent(with: calculator)
        
        let result = sut.calculate(expression)
        
        #expect(result == 5)
    }
    
    private func createStudent(with calculator: any Calculator) -> Student {
        return Student(calculator: calculator)
    }
}

//final class UnitTestProjectTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
//    func test_student() {
//        let calculator = MockCalculator()
//        let sut = createStudent(with: calculator)
//        
//        let result = sut.calculate("1 + 2 + 3 - 1")
//        
//        XCTAssertEqual(result, 5)
//    }
//    
//    private func createStudent(with calculator: any Calculator) -> Student {
//        return Student(calculator: calculator)
//    }
//}
