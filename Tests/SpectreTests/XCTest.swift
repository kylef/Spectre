import XCTest
import Spectre

class SpectreTests: XCTestCase {
  func testSpectre() {
    describe("Failure", testFailure)
    describe("Expectation", testExpectation)
  }
}
