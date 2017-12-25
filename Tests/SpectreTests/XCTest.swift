import XCTest
import Spectre

class SpectreTests: XCTestCase {
  
  func testSpectre() {
    testFailure()
    testExpectation()
  }
  
  func test_Xcode_reporter() {
    describe {
      $0.it("reports failures") {
        try expect(true) == false
      }
    }
    
    describe("Custom test") {
      $0.it("reports failures") {
        try expect(true) == false
      }
    }
  }
  
}

